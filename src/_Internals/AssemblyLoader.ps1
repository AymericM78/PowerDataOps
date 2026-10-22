# SDK assemblies of the running edition: Assemblies\Core (PowerShell 7+) or Assemblies\Desktop (Windows PowerShell 5.1).
# Dot-sourced once by PowerDataOps.psm1, before the function files.
$Global:PowerDataOpsAssemblyPath = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\Assemblies\$($PSVersionTable.PSEdition)");

# Every DLL is loaded up front: PowerShell only finds a type literal ([Microsoft.Xrm.Sdk.Entity]) in an assembly already loaded.
$loadedAssemblies = [System.Collections.Generic.List[System.Reflection.Assembly]]::new();
$assemblyFiles = @(Get-ChildItem -LiteralPath $Global:PowerDataOpsAssemblyPath -File | Where-Object { $_.Extension -eq ".dll" });
foreach ($assemblyFile in $assemblyFiles) {
    try {
        $loadedAssemblies.Add([System.Reflection.Assembly]::LoadFile($assemblyFile.FullName));
    }
    catch {
        Write-Warning "PowerDataOps: cannot load '$($assemblyFile.FullName)'. Reason = '$($_.Exception.Message)'";
    }
}

# The DLLs reference other versions of each other (e.g. Microsoft.Extensions.* 3.1.0 for 3.1.9 shipped), which a module cannot redirect
# with a configuration file: the resolver answers with the shipped one, whatever the version asked.
# It only answers for the DLLs of this folder: any other request is left to the runtime, so it never resolves for another module.
$assemblyResolverSource = @'
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Reflection;

public class PowerDataOpsAssemblyResolver
{
    private static readonly Dictionary<string, PowerDataOpsAssemblyResolver> Resolvers = new Dictionary<string, PowerDataOpsAssemblyResolver>(StringComparer.OrdinalIgnoreCase);
    private readonly ConcurrentDictionary<string, Assembly> assemblies = new ConcurrentDictionary<string, Assembly>(StringComparer.OrdinalIgnoreCase);
    private readonly string folder;

    private PowerDataOpsAssemblyResolver(string folder)
    {
        this.folder = folder;
    }

    // One handler per folder and process: a module imported again (-Force) only refreshes the loaded assemblies
    public static void Register(string folder, Assembly[] loadedAssemblies)
    {
        PowerDataOpsAssemblyResolver resolver;
        lock (Resolvers)
        {
            if (!Resolvers.TryGetValue(folder, out resolver))
            {
                resolver = new PowerDataOpsAssemblyResolver(folder);
                Resolvers[folder] = resolver;
                AppDomain.CurrentDomain.AssemblyResolve += resolver.Resolve;
            }
        }
        foreach (Assembly assembly in loadedAssemblies)
        {
            resolver.assemblies[assembly.GetName().Name] = assembly;
        }
    }

    public Assembly Resolve(object sender, ResolveEventArgs args)
    {
        string name;
        try
        {
            name = new AssemblyName(args.Name).Name;
        }
        catch (Exception)
        {
            return null;
        }

        // The copy this folder loaded at module load, even when another module loaded its own first
        Assembly assembly;
        if (assemblies.TryGetValue(name, out assembly))
        {
            return assembly;
        }

        string path = Path.Combine(folder, name + ".dll");
        if (!File.Exists(path))
        {
            return null;
        }

        // Not loaded at module load (a warning said why): a copy already loaded, else this folder's.
        // LoadFile, as at module load: LoadFrom would bind its dependencies in another context, and could load a second Microsoft.Xrm.Sdk.
        foreach (Assembly loaded in AppDomain.CurrentDomain.GetAssemblies())
        {
            if (!loaded.IsDynamic && string.Equals(loaded.GetName().Name, name, StringComparison.OrdinalIgnoreCase))
            {
                return loaded;
            }
        }
        return assemblies.GetOrAdd(name, Assembly.LoadFile(path));
    }
}
'@;

if (-not ("PowerDataOpsAssemblyResolver" -as [type])) {
    Add-Type -TypeDefinition $assemblyResolverSource;
}
[PowerDataOpsAssemblyResolver]::Register($Global:PowerDataOpsAssemblyPath, $loadedAssemblies.ToArray());

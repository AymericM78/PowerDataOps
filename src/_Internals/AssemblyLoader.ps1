$Global:PowerDataOpsAssemblyPath = "$PSScriptRoot\..\Assemblies\$($PSVersionTable.PSEdition)";

function Import-Assemblies {
    param()

    $assemblies = Get-ChildItem -Path "$($Global:PowerDataOpsAssemblyPath)\*.dll";
    foreach ($assembly in $assemblies) {
        try {
            [System.Reflection.Assembly]::LoadFile($assembly.FullName) | Out-Null;
        }
        catch {
            $err = $_.Exception.Message;
        }
    }
}

function Import-AssemblyRedirector {
    param()

    $assemblyRedirectorCSharpSource = '
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Reflection;

    public class PowerDataOpsAssemblyRedirector
    {
        public ResolveEventHandler AssemblyResolver;
        public static Dictionary<string, string> AssemblyRedirections = new Dictionary<string, string>();

        public PowerDataOpsAssemblyRedirector()
        {
            this.AssemblyResolver += new ResolveEventHandler(AssemblyResolve);
            [AssemblyRedirections]
        }
        
        protected Assembly AssemblyResolve(object sender, ResolveEventArgs resolveEventArgs)
        {
            var name = resolveEventArgs.Name.Split([QUOTE],[QUOTE]).FirstOrDefault(); 
            
            var domainAssembly = AppDomain.CurrentDomain.GetAssemblies().FirstOrDefault(a => string.Compare(a.GetName().Name, name, true) == 0);
            if (domainAssembly != null)
            {
				/*
				if(AssemblyRedirections.ContainsKey(name) && !domainAssembly.Location.StartsWith("[ASSEMBLYPATH]")){
					var path = AssemblyRedirections[name];
					// Console.WriteLine("Assembly : " + path);
					var assembly = Assembly.LoadFrom(path);
					return assembly;
				}				
				*/
                // Console.WriteLine("Assembly already loaded : " + domainAssembly.Location);
                return domainAssembly;
            }

            if (AssemblyRedirections.ContainsKey(name))
            {
                var path = AssemblyRedirections[name];
                // Console.WriteLine("Assembly : " + path);
                var assembly = Assembly.LoadFrom(path);
                return assembly;
            }            
           
            // Console.WriteLine("Assembly not found : " + name);
            return null;
        }
    }';

    $assemblyRedirections = '';
    $assemblies = Get-ChildItem -Path "$($Global:PowerDataOpsAssemblyPath)\*.dll";
    foreach ($assembly in $assemblies) {
        $assemblyRedirections += 'AssemblyRedirections.Add("' + $assembly.Name.Replace('.dll', '') + '", "' + $assembly.FullName.Replace('\', "\\") + '");';
    }

    $assemblyRedirectorCSharpSource = $assemblyRedirectorCSharpSource.Replace("[AssemblyRedirections]", $assemblyRedirections);
    $assemblyRedirectorCSharpSource = $assemblyRedirectorCSharpSource.Replace("[ASSEMBLYPATH]", $Global:PowerDataOpsAssemblyPath.Replace('\', "\\"));
    $assemblyRedirectorCSharpSource = $assemblyRedirectorCSharpSource.Replace("[QUOTE]", "'");

    if (!("PowerDataOpsAssemblyRedirector" -as [type])) {
        Add-Type -TypeDefinition $assemblyRedirectorCSharpSource -PassThru | Out-Null;

        $redirector = [PowerDataOpsAssemblyRedirector]::new();
        [System.AppDomain]::CurrentDomain.add_AssemblyResolve($redirector.AssemblyResolver);
    }
}

Import-Assemblies;
Import-AssemblyRedirector;
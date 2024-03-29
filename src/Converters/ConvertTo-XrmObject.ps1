<#
    .SYNOPSIS
    Transform Entity to custom object.

    .DESCRIPTION
    Represent Entity object to custom object.

    .PARAMETER Record
    Entity record / table row (Entity).
#>
function ConvertTo-XrmObject {
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [Microsoft.Xrm.Sdk.Entity]
        $Record
    )
    begin {  
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {               
        $hash = [ordered]@{
            "Id"          = $Record.Id
            "LogicalName" = $Record.LogicalName
            "Record"      = $Record
            "Reference"   = $Record.ToEntityReference()
        };
        
        $attributes = $Record.Attributes | Sort-Object -Property Key;
        foreach ($attribute in $attributes) {
            $value = "";
            if ($Record.FormattedValues.ContainsKey($attribute.Key)) {
                $value = $Record.FormattedValues[$attribute.Key];
                $hash["$($attribute.Key)_Value"] = $Record[$attribute.Key];
            }
            else {             
                $value = $Record[$attribute.Key];
                if ($value) {
                    if ($value.GetType().Name -eq "AliasedValue") {
                        $value = $value.Value;
                    }
                }
            }

            $hash[$attribute.Key] = $value;
        }

        $object = [pscustomobject]$hash;
        $object;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Export-ModuleMember -Function ConvertTo-XrmObject -Alias *;
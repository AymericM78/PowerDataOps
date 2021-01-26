<#
    .SYNOPSIS
    Retrieve security roles
#>
function Get-XrmRoles {
    [CmdletBinding()]    
    [OutputType("Microsoft.Xrm.Sdk.Query.QueryExpression")]
    param
    ( 
        [Parameter(Mandatory=$false, ValueFromPipeline)]
        [Microsoft.Xrm.Tooling.Connector.CrmServiceClient]
        $XrmClient = $Global:XrmClient,

        [Parameter(Mandatory=$false)]
        [Guid]
        $BusinessUnitId,

        [Parameter(Mandatory=$false)]
        [switch]
        $OnlyRoots = $false,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Columns = @("roleid","name","parentrootroleid","businessunitid"),

        # TODO : A faire une fois la méthode Get-XrmPrivileges implémentée
        [Parameter(Mandatory=$false)]
        [switch]
        $ExportPrivileges = $false
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);       
    }    
    process {
       $queryRoles = New-XrmQueryExpression -LogicalName "role" -Columns $Columns;
       if ($PSBoundParameters.ContainsKey('$BusinessUnitId'))
       {           
            $queryRoles = $queryRoles | Add-XrmQueryCondition -Field "businessunitid" -Condition Equal -Values $BusinessUnitId;
       }
       if($OnlyRoots)
       {           
            $parentBusinessUnit = Get-XrmRootBusinessUnit;
            $queryRoles = $queryRoles | Add-XrmQueryCondition -Field "businessunitid" -Condition Equal -Values  $parentBusinessUnit.Id;
       }
       $roles = $XrmClient | Get-XrmMultipleRecords -Query $queryRoles;
       $roles;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}
Export-ModuleMember -Function Get-XrmRoles -Alias *;
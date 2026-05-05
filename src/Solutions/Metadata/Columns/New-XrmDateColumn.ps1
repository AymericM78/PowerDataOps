<#
    .SYNOPSIS
    Build a DateTimeAttributeMetadata for a Dataverse column.

    .DESCRIPTION
    Creates a configured Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata object
    that can be passed to Add-XrmColumn.

    .PARAMETER LogicalName
    Column logical name.

    .PARAMETER SchemaName
    Column schema name.

    .PARAMETER DisplayName
    Column display name.

    .PARAMETER Format
    Date format. DateOnly or DateAndTime.

    .PARAMETER Behavior
    DateTime behavior. UserLocal, DateOnly, or TimeZoneIndependent.

    .PARAMETER Description
    Column description label.

    .PARAMETER RequiredLevel
    Required level. Default: None.

    .PARAMETER LanguageCode
    Label language code. Default: 1033.

    .OUTPUTS
    Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata.

    .EXAMPLE
    $attribute = New-XrmDateColumn -LogicalName "new_startdate" -SchemaName "new_StartDate" -DisplayName "Start Date" -Format DateAndTime -Behavior TimeZoneIndependent;
    Add-XrmColumn -EntityLogicalName "account" -Attribute $attribute;

    .LINK
    https://learn.microsoft.com/power-apps/developer/data-platform/behavior-format-date-time-attribute
#>
function New-XrmDateColumn {
    [CmdletBinding()]
    [OutputType([Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $LogicalName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SchemaName,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $DisplayName,

        [Parameter(Mandatory = $false)]
        [ValidateSet("DateOnly", "DateAndTime")]
        [string]
        $Format = "DateOnly",

        [Parameter(Mandatory = $false)]
        [ValidateSet("UserLocal", "DateOnly", "TimeZoneIndependent")]
        [string]
        $Behavior,

        [Parameter(Mandatory = $false)]
        [string]
        $Description,

        [Parameter(Mandatory = $false)]
        [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]
        $RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevel]::None,

        [Parameter(Mandatory = $false)]
        [int]
        $LanguageCode = 1033
    )
    begin {
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters);
    }
    process {
        $attribute = [Microsoft.Xrm.Sdk.Metadata.DateTimeAttributeMetadata]::new();
        $attribute.LogicalName = $LogicalName;
        $attribute.SchemaName = $SchemaName;
        $attribute.DisplayName = New-XrmLabel -Text $DisplayName -LanguageCode $LanguageCode;
        $attribute.RequiredLevel = [Microsoft.Xrm.Sdk.Metadata.AttributeRequiredLevelManagedProperty]::new($RequiredLevel);

        if ($Format -eq "DateAndTime") {
            $attribute.Format = [Microsoft.Xrm.Sdk.Metadata.DateTimeFormat]::DateAndTime;
        }
        else {
            $attribute.Format = [Microsoft.Xrm.Sdk.Metadata.DateTimeFormat]::DateOnly;
        }

        if ($PSBoundParameters.ContainsKey('Behavior')) {
            $attribute.DateTimeBehavior = $Behavior;
        }

        if (-not [string]::IsNullOrWhiteSpace($Description)) {
            $attribute.Description = New-XrmLabel -Text $Description -LanguageCode $LanguageCode;
        }

        $attribute;
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }
}

Set-Alias -Name New-DateColumn -Value New-XrmDateColumn;
Export-ModuleMember -Function New-XrmDateColumn -Alias *;

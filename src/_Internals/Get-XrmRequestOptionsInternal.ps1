<#
    Pick the request options (see Set-XrmRequestOptions) out of a cmdlet's bound parameters, as a hashtable to splat:
    $options = Get-XrmRequestOptionsInternal -BoundParameters $PSBoundParameters;
    $request = $request | Set-XrmRequestOptions @options;
#>
function Get-XrmRequestOptionsInternal {
    param(
        [Parameter(Mandatory = $true)]
        [System.Collections.IDictionary]
        $BoundParameters
    )

    $optionNames = @("BypassCustomPluginExecution", "BypassBusinessLogicExecution", "BypassBusinessLogicExecutionStepIds", "SuppressCallbackRegistrationExpanderJob", "SuppressDuplicateDetection", "Tag");
    $options = @{};
    foreach ($optionName in $optionNames) {
        if ($BoundParameters.ContainsKey($optionName)) {
            $options[$optionName] = $BoundParameters[$optionName];
        }
    }
    $options;
}

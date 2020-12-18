<#
    .SYNOPSIS
    Get Solution Component name from Id
#>
function Get-XrmSolutionComponentName {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $SolutionComponentType
    )
    begin {   
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew(); 
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Start -Parameters ($MyInvocation.MyCommand.Parameters); 
    }    
    process {
        
        # https://docs.microsoft.com/en-us/dynamics365/customer-engagement/web-api/solutioncomponent?view=dynamics-ce-odata-9

        $componentTypeDefinitions = @{};
        $componentTypeDefinitions[1] = "Entity";
        $componentTypeDefinitions[2] = "Attribute";
        $componentTypeDefinitions[3] = "Relationship";
        $componentTypeDefinitions[4] = "Attribute Picklist Value";
        $componentTypeDefinitions[5] = "Attribute Lookup Value";
        $componentTypeDefinitions[6] = "View Attribute";
        $componentTypeDefinitions[7] = "Localized Label";
        $componentTypeDefinitions[8] = "Relationship Extra Condition";
        $componentTypeDefinitions[9] = "Option Set";
        $componentTypeDefinitions[10] = "EntityRelationship";
        $componentTypeDefinitions[11] = "Entity Relationship Role";
        $componentTypeDefinitions[12] = "Entity Relationship Relationships";
        $componentTypeDefinitions[13] = "Managed Property";
        $componentTypeDefinitions[14] = "EntityKey";
        $componentTypeDefinitions[16] = "Privilege";
        $componentTypeDefinitions[17] = "PrivilegeObjectTypeCode";
        $componentTypeDefinitions[18] = "Index";
        $componentTypeDefinitions[20] = "Role";
        $componentTypeDefinitions[21] = "Role Privilege";
        $componentTypeDefinitions[22] = "Display String";
        $componentTypeDefinitions[23] = "Display String Map";
        $componentTypeDefinitions[24] = "Form";
        $componentTypeDefinitions[25] = "Organization";
        $componentTypeDefinitions[26] = "SavedQuery";
        $componentTypeDefinitions[29] = "Workflow";
        $componentTypeDefinitions[31] = "Report";
        $componentTypeDefinitions[32] = "Report Entity";
        $componentTypeDefinitions[33] = "Report Category";
        $componentTypeDefinitions[34] = "Report Visibility";
        $componentTypeDefinitions[35] = "Attachment";
        $componentTypeDefinitions[36] = "Email Template";
        $componentTypeDefinitions[37] = "Contract Template";
        $componentTypeDefinitions[38] = "KB Article Template";
        $componentTypeDefinitions[39] = "Mail Merge Template";
        $componentTypeDefinitions[44] = "Duplicate Rule";
        $componentTypeDefinitions[45] = "Duplicate Rule Condition";
        $componentTypeDefinitions[46] = "Entity Map";
        $componentTypeDefinitions[47] = "Attribute Map";
        $componentTypeDefinitions[48] = "Ribbon Command";
        $componentTypeDefinitions[49] = "Ribbon Context Group";
        $componentTypeDefinitions[50] = "Ribbon Customization";
        $componentTypeDefinitions[52] = "Ribbon Rule";
        $componentTypeDefinitions[53] = "Ribbon Tab To Command Map";
        $componentTypeDefinitions[55] = "Ribbon Diff";
        $componentTypeDefinitions[59] = "SavedQueryVisualization";
        $componentTypeDefinitions[60] = "SystemForm";
        $componentTypeDefinitions[61] = "Web Resource";
        $componentTypeDefinitions[62] = "Site Map";
        $componentTypeDefinitions[63] = "Connection Role";
        $componentTypeDefinitions[64] = "Complex Control";
        $componentTypeDefinitions[66] = "Custom Control";
        $componentTypeDefinitions[68] = "Custom Control Default Config";
        $componentTypeDefinitions[65] = "Hierarchy Rule";
        $componentTypeDefinitions[70] = "Field Security Profile";
        $componentTypeDefinitions[71] = "Field Permission";
        $componentTypeDefinitions[90] = "Plugin Type";
        $componentTypeDefinitions[91] = "Plugin Assembly";
        $componentTypeDefinitions[92] = "SDK Message Processing Step";
        $componentTypeDefinitions[93] = "SDK Message Processing Step Image";
        $componentTypeDefinitions[95] = "Service Endpoint";
        $componentTypeDefinitions[150] = "Routing Rule";
        $componentTypeDefinitions[151] = "Routing Rule Item";
        $componentTypeDefinitions[152] = "SLA";
        $componentTypeDefinitions[153] = "SLA Item";
        $componentTypeDefinitions[154] = "Convert Rule";
        $componentTypeDefinitions[155] = "Convert Rule Item";
        $componentTypeDefinitions[161] = "Mobile Offline Profile";
        $componentTypeDefinitions[162] = "Mobile Offline Profile Item";
        $componentTypeDefinitions[165] = "Similarity Rule";
        $componentTypeDefinitions[166] = "Data Source Mapping";
        $componentTypeDefinitions[201] = "SDKMessage";
        $componentTypeDefinitions[202] = "SDKMessageFilter";
        $componentTypeDefinitions[203] = "SdkMessagePair";
        $componentTypeDefinitions[204] = "SdkMessageRequest";
        $componentTypeDefinitions[205] = "SdkMessageRequestField";
        $componentTypeDefinitions[206] = "SdkMessageResponse";
        $componentTypeDefinitions[207] = "SdkMessageResponseField";
        $componentTypeDefinitions[208] = "Import Map";
        $componentTypeDefinitions[210] = "WebWizard";
        $componentTypeDefinitions[300] = "Canvas App";
        $componentTypeDefinitions[371] = "Connector";
        $componentTypeDefinitions[372] = "Connector";
        $componentTypeDefinitions[380] = "Environment Variable Definition";
        $componentTypeDefinitions[381] = "Environment Variable Value";
        $componentTypeDefinitions[400] = "AI Project Type";
        $componentTypeDefinitions[401] = "AI Project";
        $componentTypeDefinitions[402] = "AI Configuration";
        $componentTypeDefinitions[430] = "Entity Analytics Configuration";
        $componentTypeDefinitions[431] = "Attribute Image Configuration";
        $componentTypeDefinitions[432] = "Entity Image Configuration";

        if(-not $componentTypeDefinitions.Contains($SolutionComponentType))
        {
            throw "Unknown solution component type '$SolutionComponentType'!"
        }

        $componentTypeDefinitions[$SolutionComponentType];
    }
    end {
        $StopWatch.Stop();
        Trace-XrmFunction -Name $MyInvocation.MyCommand.Name -Stage Stop -StopWatch $StopWatch;
    }    
}

Export-ModuleMember -Function Get-XrmSolutionComponentName -Alias *;
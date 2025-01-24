namespace Forey.ProjectZPL.General;

using System.AI;
using Forey.ProjectZPL.CopilotBasic;

codeunit 89551 SecretsAndCapabilitiesSetup
{
    Subtype = Install;
    InherentEntitlements = X;
    InherentPermissions = X;
    Access = Internal;

    trigger OnRun()
    begin
        RegisterCapability();
    end;

    local procedure RegisterCapability()
    var
        CopilotCapability: Codeunit "Copilot Capability";
        IsolatedStorageWrapper: Codeunit "Isolated Storage Wrapper";
        LearnMoreUrlTxt: Label 'https://example.com/CopilotToolkit', Locked = true;
    begin
        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Find Item") then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Find Item", Enum::"Copilot Availability"::Preview, LearnMoreUrlTxt);

        if not CopilotCapability.IsCapabilityRegistered(Enum::"Copilot Capability"::"Project ZPL Task Creation") then
            CopilotCapability.RegisterCapability(Enum::"Copilot Capability"::"Project ZPL Task Creation", LearnMoreUrlTxt);
    end;
}

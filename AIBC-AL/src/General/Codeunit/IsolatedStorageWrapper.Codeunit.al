namespace Forey.ProjectZPL.General;

codeunit 89552 "Isolated Storage Wrapper"
{
    SingleInstance = true;
    Access = Internal;

    var
        IsolatedStorageSecretKeyKey: Label 'CopilotToolkitDemoSecret', Locked = true;
        IsolatedStorageDeploymentKey: Label 'CopilotToolkitDemoDeployment', Locked = true;
        IsolatedStorageEndpointKey: Label 'CopilotToolkitDemoEndpoint', Locked = true;


    procedure SetSecretKey(SecretKey: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageSecretKeyKey, SecretKey);
    end;

    procedure SetDeployment(Deployment: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageDeploymentKey, Deployment);
    end;

    procedure SetEndpoint(Endpoint: Text)
    begin
        IsolatedStorage.Set(IsolatedStorageEndpointKey, Endpoint);
    end;

    procedure GetApiKey(): SecretText
    begin
        if not OpenAISetup.Get() then
            Error(OpenAISetupErr);
        exit(Format(OpenAISetup.GetSharedAccessKey()));
    end;

    procedure GetDeployment(): Text
    begin
        if not OpenAISetup.Get() then
            Error(OpenAISetupErr);

        exit(OpenAISetup.Deployment);
    end;

    procedure GetEndpoint(): Text
    begin
        if not OpenAISetup.Get() then
            Error(OpenAISetupErr);
        exit(OpenAISetup.Endpoint);
    end;

    var
        OpenAISetup: Record OpenAISetup;
        OpenAISetupErr: Label 'Open AI Setup is not configured.';

}
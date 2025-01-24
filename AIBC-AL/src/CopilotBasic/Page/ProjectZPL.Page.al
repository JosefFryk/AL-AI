namespace Forey.ProjectZPL.CopilotBasic;
using System.AI;
using Forey.ProjectZPL.General;

page 89550 "ZPL Main Page Project"
{
    PageType = PromptDialog;
    ApplicationArea = All;
    Caption = 'Draft with Copilot';
    PromptMode = Prompt;
    Extensible = false;

    layout
    {
        area(Prompt)
        {
            field(ProjectDescriptionField; InputProjectDescription)
            {
                ShowCaption = false;
                MultiLine = true;
                InstructionalText = 'Please describe the project or work to be done that needs to be converted into tasks';
            }
        }

        area(PromptOptions)
        {
            // In PromptDialog pages, you can define a PromptOptions area. Here you can add different settings to tweak the output that Copilot will generate.
            // These settings must be defined as page fields, and must be of type Option or Enum. You cannot define groups in this area.
        }

        area(Content)
        {
            field("Project Tasks"; OutputProjectTasks)
            {
                MultiLine = true;
                ExtendedDatatype = RichContent;
                Editable = false;
            }
        }
    }

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                trigger OnAction()
                var
                    SystemPrompt: Text;
                begin
                    SystemPrompt := 'The user will describe a project. Your task is to prepare the project plan for this project to be used in Microsoft Dynamics 365 Business Central.'
                        + 'The output should be html formatted bulleted list. '
                        + 'Generate at least 6 tasks.'
                        + 'Order the tasks in order of execution.'
                        + 'If a task needs an item format the item name with bold.'
                        + 'Add relevant emoji to each task.'
                        + 'If a tasks needs a person format task with underline.';

                    OutputProjectTasks := CreateSuggestion(SystemPrompt, InputProjectDescription);
                end;
            }
        }
        area(PromptGuide)
        {
            action("AOrganizeEvent")
            {
                Caption = 'Organize an event';
                trigger OnAction()
                begin
                    InputProjectDescription += 'Plan for organizing a <project name> for the attendees of <event name>';
                end;
            }
        }
    }

    var
        InputProjectDescription: Text;
        OutputProjectTasks: Text;

    local procedure CreateSuggestion(SystemPrompt: Text; ProjectDescription: Text): Text
    var
        CopilotCapability: Codeunit "Copilot Capability";
        AzureOpenAI: Codeunit "Azure OpenAI";
        AOAIDeployments: Codeunit "AOAI Deployments";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        IsNotEnabledErr: Label 'Error: Open AI Setup is not enabled.';
        IsolatedStorageWrapper: Codeunit "Isolated Storage Wrapper";
    begin
        if not OpenAISetup.Get() then
            Error(OpenAISetupErr);

        if not OpenAISetup.IsEnabled then
            Error(IsNotEnabledErr);

        // If you are using managed resources, call this function:
        // NOTE: endpoint, deployment, and key are only used to verify that you have a valid Azure OpenAI subscription; we don't use them to generate the result
        // AzureOpenAI.SetManagedResourceAuthorization(Enum::"AOAI Model Type"::"Chat Completions",
        //     GetEndpoint(), GetDeployment(), GetApiKey(), AOAIDeployments.GetGPT4oLatest());
        // If you are using your own Azure OpenAI subscription, call this function instead:
        AzureOpenAI.SetAuthorization(Enum::"AOAI Model Type"::"Chat Completions", IsolatedStorageWrapper.GetEndpoint(), IsolatedStorageWrapper.GetDeployment(), IsolatedStorageWrapper.GetApiKey());
        AzureOpenAI.SetCopilotCapability(Enum::"Copilot Capability"::"Project ZPL Task Creation");

        AOAIChatCompletionParams.SetMaxTokens(2500);
        AOAIChatCompletionParams.SetTemperature(0);

        AOAIChatMessages.AddSystemMessage(SystemPrompt);
        AOAIChatMessages.AddUserMessage(ProjectDescription);

        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if (AOAIOperationResponse.IsSuccess()) then
            exit(AOAIChatMessages.GetLastMessage());

        exit('Error: ' + AOAIOperationResponse.GetError());
    end;

    var
        OpenAISetup: Record OpenAISetup;
        OpenAISetupErr: Label 'Open AI Setup is not configured.';

}


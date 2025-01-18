namespace Forey.ProjectZPL;

table 89550 OpenAISetup
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "API Key"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'API Key';
            ToolTip = 'API Key for OpenAI';
        }
        field(3; "Deployment"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Deployment';
            ToolTip = 'Deployment for OpenAI';
        }
        field(4; "Endpoint"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Endpoint';
            ToolTip = 'Endpoint for OpenAI';
        }
        field(5; KeyStorageId; Guid)
        {
            DataClassification = CustomerContent;
        }
        field(6; IsEnabled; Boolean)
        {
            Caption = 'Is Enabled';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    procedure SetSharedAccessKey(SharedAccessKey: Text)
    begin
        if IsNullGuid(KeyStorageId) then
            KeyStorageId := CreateGuid();

        if not EncryptionEnabled() then
            IsolatedStorage.Set(KeyStorageId, SharedAccessKey, Datascope::Module)
        else
            IsolatedStorage.SetEncrypted(KeyStorageId, SharedAccessKey, Datascope::Module);
    end;

    [NonDebuggable]
    internal procedure GetSharedAccessKey(): Text
    var
        Value: Text;
    begin
        if not IsNullGuid(KeyStorageId) then
            IsolatedStorage.Get(KeyStorageId, Datascope::Module, Value);
        exit(Value);
    end;

    [NonDebuggable]
    procedure HasSharedAccessKey(): Boolean
    begin
        exit(GetSharedAccessKey() <> '');
    end;

}
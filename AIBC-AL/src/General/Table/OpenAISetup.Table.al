namespace Forey.ProjectZPL.General;

table 89550 OpenAISetup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[20])
        {
            Caption = 'Primary Key';
        }
        field(3; "Deployment"; Text[250])
        {
            Caption = 'Deployment';
            ToolTip = 'Deployment for OpenAI';
        }
        field(4; "Endpoint"; Text[250])
        {
            Caption = 'Endpoint';
            ToolTip = 'Endpoint for OpenAI';
        }
        field(5; KeyStorageId; Guid)
        {
        }
        field(6; IsEnabled; Boolean)
        {
            Caption = 'Is Enabled';
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
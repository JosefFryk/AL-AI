namespace Forey.ProjectZPL;
using System.Security.Encryption;

page 89551 "Open AI Setup"
{
    Caption = 'Open AI Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = OpenAISetup;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("API Key"; Rec."API Key")
                {

                }
                field(Deployment; Rec.Deployment)
                {

                }
                field(Endpoint; Rec.Endpoint)
                {

                }
                field(SharedAccessKey; SharedAccessKeyValue)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                    Caption = 'Shared Acces Key';
                    ToolTip = 'Specifies the key used for authentication';

                    trigger OnValidate()
                    begin
                        if (SharedAccessKeyValue <> '') and (not EncryptionEnabled()) then
                            if Confirm(EncryptionIsNotActivatedQst) then
                                PAGE.RunModal(PAGE::"Data Encryption Management");
                        Rec.SetSharedAccessKey(SharedAccessKeyValue);
                    end;
                }
                field(IsEnabled; Rec.IsEnabled)
                {

                }

            }
        }
    }
    var
        SharedAccessKeyValue: Text;
        EncryptionIsNotActivatedQst: Label 'Data encryption is currently not enabled. We recommend that you encrypt data. \Do you want to open the Data Encryption Management window?';

    trigger OnAfterGetRecord()
    begin
        if Rec.HasSharedAccessKey() then
            SharedAccessKeyValue := '*';
    end;
}
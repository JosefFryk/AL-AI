namespace Forey.ProjectZPL.CopilotBasic;
using Microsoft.Inventory.Item;

pageextension 89552 ItemList extends "Item List"
{
    layout
    {

    }

    actions
    {
        addlast(Functions)
        {
            action("DraftWithCopilot")
            {
                ApplicationArea = All;
                Caption = 'Draft with Copilot';

                RunObject = Page "ZPL Main Page Project";
            }
        }
    }
}
namespace Forey.ProjectZPL.CopilotBasic;
using Microsoft.Inventory.Item;

pageextension 89551 ItemCard extends "Item Card"
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
        addfirst(Category_Process)
        {
            actionref(SuggestItem_Promoted; "Substituti&ons") { }
        }
    }
}
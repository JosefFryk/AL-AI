namespace Forey.ProjectZPL.CopilotBasic;
using Microsoft.Projects.Project.Job;

pageextension 89550 JobList extends "Job List"
{
    layout
    {

    }
    actions
    {
        addfirst(Prompting)
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
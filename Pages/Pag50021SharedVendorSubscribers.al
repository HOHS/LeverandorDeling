page 50021 "Shared Vendor Subscribers"
{
    PageType = List;
    SourceTable = "Shared Vendor Subscriber";
    Caption = 'Delte Leverandører - Abonnenter';
    captionml = ENU = 'Shared Vendor Subscribers',
                DAN = 'Delte Leverandører';
    Editable = false;
    layout
    {
        area(content)
        {
            group(GroupName)
            {
                field(Name; NameSource)
                {
                    
                }
            }
        }
    }
    
    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                trigger OnAction()
                begin
                    
                end;
            }
        }
    }
    
    var
        myInt: Integer;
}
page 50021 "Shared Vendor Subscribers"
{
    Editable = false;
    PageType = List;
    Caption = 'Delte Leverandører - Abonnenter';
    SourceTable = "Shared Vendor Subscriber";
    layout
    {
        area(content)
        {
            group(Gruppe)
            {
                field("Shared from Company Name"; "Shared from Company Name")
                {
                    Caption = 'Delt fra virksomhedsnavn';
                }
                field("Shared to Company Name";"Shared to Company Name")
                {
                    Caption = 'Delt til virksomhedsnavn';
                }
                field("Vendor No.";"Vendor No.")
                {
                    Caption = 'Leverandørnr.';
                }
                field("Vendor Name";"Vendor Name")
                {
                    Caption = 'Leverandørnavn';
                }
            }
        }
    }
}
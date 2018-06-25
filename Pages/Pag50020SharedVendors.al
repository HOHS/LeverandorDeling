//DONE
page 50020 "Shared Vendors"
{
    PageType = List;
    SourceTable = "Shared Vendor";
    Caption = 'Delte Leverandører';
    Editable = false;
    layout
    {
        area(content)
        {
            group(Gruppe)
            {
                field("Shared from Company Name";"Shared from Company Name")
                {
                    Caption = 'Delt fra virksomhedsnavn';
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
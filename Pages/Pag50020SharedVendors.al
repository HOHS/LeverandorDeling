//DONE
page 50020 "Shared Vendors"
{
    PageType = List;
    SourceTable = "Shared Vendor";
    Caption = 'Delte Leverandører';
    captionML = ENU = 'Shared Vendors',
                DAN = 'Delte Leverandører';
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
                    captionml = ENU = 'Shared from Company Name',
                                DAN = 'Delt fra virksomhedsnavn';
                }
                field("Vendor No.";"Vendor No.")
                {
                    Caption = 'Leverandørnr.';
                    captionml = ENU ='Vendor No.',
                                DAN = 'Leverandørnr.';
                }
                field("Vendor Name";"Vendor Name")
                {
                    Caption = 'Leverandørnavn';
                    captionml = ENU = 'Vendor Name',
                                DAN = 'Leverandørnavn';
                }
            }
        }
    }
}
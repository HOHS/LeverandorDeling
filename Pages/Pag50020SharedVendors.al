page 50020 "Shared Vendors"
{
    PageType = List;
    SourceTable = "Shared Vendor";
    Caption = 'shared Vendors';
    Editable = false;
    layout
    {
        area(content)
        {
            group(Gruppe)
            {
                field("Shared from Company Name";"Shared from Company Name")
                {
                    Caption = 'Shared from Comapany Name';
                }
                field("Vendor No.";"Vendor No.")
                {
                    Caption = 'Vendor no..';
                }
                field("Vendor Name";"Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
            }
        }
    }
}
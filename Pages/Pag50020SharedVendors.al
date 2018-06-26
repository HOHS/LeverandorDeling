page 50020 "Shared Vendors"
{
    PageType = List;
    SourceTable = "Shared Vendor";
    Caption = 'Shared Vendor';
    Editable = false;
    layout
    {
        area(content)
        {
            group(Gruppe)
            {
                field("Shared from Company Name";"Shared from Company Name")
                {
                    Caption = 'Shared from Company Name';
                }
                field("Vendor No.";"Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field("Vendor Name";"Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
            }
        }
    }
}
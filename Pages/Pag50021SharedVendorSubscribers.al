page 50021 "Shared Vendor Subscribers"
{
    Editable = false;
    PageType = List;
    Caption = 'Shared Vendor Subscribers';
    SourceTable = "Shared Vendor Subscriber";
    layout
    {
        area(content)
        {
            group(Gruppe)
            {
                field("Shared from Company Name"; "Shared from Company Name")
                {
                    Caption = 'Shared from Company Name';
                }
                field("Shared to Company Name";"Shared to Company Name")
                {
                    Caption = 'Shared to Company Name';
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
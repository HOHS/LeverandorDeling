table 50020 "Shared Vendor"
{
    DataClassification = CustomerContent;
    Caption = 'Shared Vendor';
    DataPerCompany = false;
    LookupPageId = "Shared Vendors";
    DrillDownPageId = "Shared Vendors";
    fields
    {
        field(1;"Shared from Company Name"; text[30])
        {
            Caption = 'Shared from Company Name';
            TableRelation = Company.Name;
            DataClassification = CustomerContent;
        }

        field(2;"Vendor No."; code[20])
        {
            caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }

        field(3;"Vendor Name"; text[50])
        {
            caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Shared from Company Name","Vendor No.")
        {
            Clustered = true;
        }
    }
}
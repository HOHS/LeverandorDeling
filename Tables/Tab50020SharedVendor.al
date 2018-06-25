//DONE
table 50020 "Shared Vendor"
{
    DataClassification = CustomerContent;
    Caption = 'Delt leverandør';
    DataPerCompany = false;
    LookupPageId = "Shared Vendors";
    DrillDownPageId = "Shared Vendors";
    fields
    {
        field(1;"Shared from Company Name"; text[30])
        {
            Caption = 'Delt fra virksomhedsnavn';
            TableRelation = Company.Name;
            DataClassification = CustomerContent;
        }

        field(2;"Vendor No."; code[20])
        {
            caption = 'Leverandørnr.';
            DataClassification = CustomerContent;
        }

        field(3;"Vendor Name"; text[50])
        {
            caption = 'Leverandørnavn';
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
table 50021 "Shared Vendor Subscriber"
{
    DataPerCompany = false;
    LookupPageId = "Shared Vendor Subscribers";
    DrillDownPageId = "Shared Vendor Subscribers";
    DataClassification = CustomerContent;
    
    fields
    {
        field(1;"Shared from Company Name"; Text[30])
        {
            caption = 'Shared from Company Name';
            TableRelation = company.Name;
            DataClassification = CustomerContent;
        }
        field(2; "Shared to Company Name"; Text[30])
        {
            caption = 'Shared to Company Name';
            DataClassification = CustomerContent;
        }
        field(3; "Vendor No."; Code[20])
        {
            caption = 'Vendor No.';
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Name"; Text[50])
        {
            caption = 'Vendor Name';
            DataClassification = ToBeClassified;
        }
    }  
    keys
    {
        key(PK; "Shared from Company Name","Shared to Company Name","Vendor No.")
        {
            Clustered = true;
        }
    }
}
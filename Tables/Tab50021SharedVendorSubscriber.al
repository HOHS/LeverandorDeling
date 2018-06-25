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
            caption = 'Delt fra virksomhedsnavn';
            TableRelation = company.Name;
            DataClassification = CustomerContent;
        }
        field(2; "Shared to Company Name"; Text[30])
        {
            caption = 'Delt til virksomhedsnavn';
            DataClassification = CustomerContent;
        }
        field(3; "Vendor No."; Code[20])
        {
            caption = 'Leverandørnr.';
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Name"; Text[50])
        {
            caption = 'Leverandørnavn';
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
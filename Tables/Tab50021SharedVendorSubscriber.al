//DONE
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
            Captionml = ENU = 'Shared from Company Name',
                        DAN = 'Delt fra virksomhedsnavn';
            TableRelation = company.Name;
            DataClassification = CustomerContent;
        }
        field(2; "Shared to Company Name"; Text[30])
        {
            caption = 'Delt til virksomhedsnavn';
            CaptionML = ENU = 'Shared to Company Name',
                        DAN = 'Delt til virksomhedsnavn';
            DataClassification = CustomerContent;
        }
        field(3; "Vendor No."; Code[20])
        {
            caption = 'Leverandørnr.';
            CaptionML = ENU = 'Vendor No.',
                        DAN = 'Leverandørnr.';
            DataClassification = CustomerContent;
        }
        field(4; "Vendor Name"; Text[50])
        {
            caption = 'Leverandørnavn';
            CaptionML = ENU = 'Vendor Name',
                        DAN = 'Leverandørnavn';
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
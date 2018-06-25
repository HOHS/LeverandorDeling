//DONE
tableextension 50020 "Purch and Payables setup ext." extends 318
{
    fields
    {
        // Add changes to table fields here
        field(50020; "Share Vendors"; Boolean)
        {
            caption = 'Del leverandører';
            DataClassification = CustomerContent;
            
            trigger OnValidate()
            var
                VendorSharingManagement: Codeunit "Vendor Sharing Management";
            begin
                if "Share Vendors" then
                    VendorSharingManagement.PublishAllVendors
                else
                    VendorSharingManagement.UnPublishAllVendors;
            end;
        }
    }
}
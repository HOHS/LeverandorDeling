tableextension 50020 "AddShareVendorsField" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50020; "Share Vendors"; Option)
        {
            caption = 'Share Vendors';
            OptionCaption =' ,Share Vendors, Subscribe to Vendors';
            OptionMembers = " ","Share Vendors","Subscribe to Vendors";
            DataClassification = CustomerContent;
            
            trigger OnValidate()
            var
                VendorSharingManagement: Codeunit "Vendor Sharing Management";
            begin
                if "Share Vendors" = "Share Vendors"::"Share Vendors" then
                    VendorSharingManagement.PublishAllVendors()
                else
                    VendorSharingManagement.UnPublishAllVendors();
            end;
        }
    }
}
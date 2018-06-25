tableextension 50020 "AddShareVendorsField" extends "Purchases & Payables Setup"
{
    fields
    {
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
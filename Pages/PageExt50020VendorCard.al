pageextension 50020 AddActionsToVendorCard extends "Vendor Card"
{
    actions
    {
        addlast("&Purchases")
        {
            action(SharedWithCompanies)
            {
                Visible = ShowSharedVendorList;
                Caption = 'Shared in Companies';
                Image = ShowSelected;
                

                trigger OnAction()
                var
                    SharedVendorSubscriber: Record "Shared Vendor Subscriber";
                begin
                    SharedVendorSubscriber.SetRange("Shared to Company Name",CompanyName());
                    SharedVendorSubscriber.SetRange("Vendor No.","No.");
                    Page.RunModal(0,SharedVendorSubscriber);
                end;
            }
            action(SharedFromCompany)
            {
                Visible = ShowVendorUnsubscribe;
                Caption = 'Shared from Company';
                Image = ShowSelected;
                

                trigger OnAction()
                var
                    SharedVendorSubscriber: Record "Shared Vendor Subscriber";
                begin
                    SharedVendorSubscriber.SetRange("Shared to Company Name",CompanyName());
                    SharedVendorSubscriber.SetRange("Vendor No.","No.");
                    Page.RunModal(0,SharedVendorSubscriber);
                end;
            }
        }
        addlast("Incoming Documents")
        {
            action("Unsubscribe to Vendor")
            {
                Visible = ShowVendorUnsubscribe;
                Caption = 'Unsubscribe to Vendor';
                Image = UnApply;
                trigger OnAction()
                var 
                    VendorSharingManagement: Codeunit "Vendor Sharing Management";
                begin
                    VendorSharingManagement.UnsubscribeToVendor(Rec);
                end;
            }
        }
    }
var
    ShowSharedVendorList: Boolean;
    ShowVendorUnsubscribe: Boolean;
trigger OnOpenPage()
    var
        VendorSharingManagement: Codeunit "Vendor Sharing Management";
    begin
        ShowSharedVendorList := VendorSharingManagement.ThisCompanySharesItsVendors();
        ShowVendorUnsubscribe := Not ShowSharedVendorList;
    end;
}

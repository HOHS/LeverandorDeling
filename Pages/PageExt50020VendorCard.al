pageextension 50020 AddActionsToVendorCard extends "Vendor Card"
{
    actions
    {
        addlast("&Purchases")
        {
            action(SharedWithCompanies)
            {
                Visible = ShowSharedVendorList;
                Caption = 'Shared in companies';
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
                Caption = 'Shared from company';
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
                Caption = 'Stop subscribing to Vendor';
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
}

codeunit 50020 "Vendor Sharing Management"
{
    trigger OnRun()
    begin

    end;

    //<functions>
    procedure SetVendorAsShared(Vendor: Record Vendor; FromCompany: Text[35])
    var
        SharedVendor: Record "Shared Vendor";
    begin
        SharedVendor."Shared from Company Name" := FromCompany;
        SharedVendor."Vendor No." := Vendor."No.";
        SharedVendor."Vendor Name" := Vendor.Name;
        if not SharedVendor.Insert(false) then
            sharedvendor.Modify(false);
    end;

    procedure RemoveVendorAsShared(Vendor: Record Vendor; FromCompany: Text[35])
    var
        SharedVendor: Record "Shared Vendor";
        SharedVendorSubscriberTemp: Record "Shared Vendor Subscriber" temporary;
    begin
        If SharedVendor.Get(FromCompany, vendor."No.") then
            SharedVendor.Delete(false)
        else
            exit;

        If VendorIsShared(Vendor."No.") then begin
            GetSharedVendorList(SharedVendorSubscriberTemp, Vendor."No.", FromCompany, '');
            if SharedVendorSubscriberTemp.FindSet() then repeat
                BlockVendor(SharedVendorSubscriberTemp."Shared from Company Name", Vendor."No.");
                RemoveVendorSubscribtion(FromCompany, SharedVendorSubscriberTemp."Shared to Company Name", SharedVendorSubscriberTemp."Vendor No.");
            until SharedVendorSubscriberTemp.Next() = 0;
        end;

    end;

    procedure SubscibeToVendor()
    //this needs to be called from the company that wants to subscribe to a vendor
    var
        SharedVendor: Record "Shared Vendor";
    begin
        If page.RunModal(0, SharedVendor) = Action::LookupOK then begin
            AddVendorSubscribtion(SharedVendor, CompanyName());
            CopySharedVendor(SharedVendor, CompanyName());
            CopyVendorBankInformation(SharedVendor, CompanyName());
        end;
    end;

    procedure UnsubscribeToVendor(Vendor: Record Vendor)
    //This needs to be called from the company that wants to unsubscribe to a vendor
    var
        SharedVendorSubscriber: Record "Shared Vendor Subscriber";
    begin
        SharedVendorSubscriber.SetRange("Shared to Company Name", CompanyName());
        SharedVendorSubscriber.SetRange("Vendor No.", Vendor."No.");
        if SharedVendorSubscriber.FindFirst() then begin
            RemoveVendorSubscribtion(SharedVendorSubscriber."Shared from Company Name", SharedVendorSubscriber."Shared to Company Name", Vendor."No.");
            Vendor.Blocked := Vendor.Blocked::All;
            Vendor.Modify(false);
        end;
    end;

    procedure PublishAllVendors()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.FindSet() then repeat
            SetVendorAsShared(Vendor, CompanyName());
        until vendor.Next() = 0;
    end;

    procedure UnPublishAllVendors()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.FindSet() then repeat
            RemoveVendorAsShared(Vendor, CompanyName());
        until vendor.next = 0;
    end;

    local procedure AddVendorSubscribtion(SharedVendor: Record "Shared Vendor"; ShareWithCompanyName: text[35])
    var
        SharedVendorSubscriber: Record "Shared Vendor Subscriber";
    begin
        SharedVendorSubscriber."Shared from Company Name" := SharedVendor."Shared from Company Name";
        SharedVendorSubscriber."Shared to Company Name" := ShareWithCompanyName;
        SharedVendorSubscriber."Vendor No." := SharedVendor."Vendor No.";
        SharedVendorSubscriber."Vendor Name" := SharedVendor."Vendor Name";
        if not SharedVendorSubscriber.Insert(false) then
            SharedVendorSubscriber.Modify(false);
    end;

    local procedure RemoveVendorSubscribtion(FromCompany: Text[35]; ToCompany: text[35]; VendorNo: Code[20])
    var
        SharedVendorSubscriber: Record "Shared Vendor Subscriber";
    begin
        if SharedVendorSubscriber.Get(FromCompany, ToCompany, VendorNo) then
            SharedVendorSubscriber.Delete(false);
    end;

    local procedure CopySharedVendor(SharedVendor: Record "Shared Vendor"; ShareWithCompanyName: text[35])
    var
        VendorToBeShared: Record Vendor;
        NewVendor: Record Vendor;
    begin
        VendorToBeShared.ChangeCompany(SharedVendor."Shared from Company Name");
        NewVendor.ChangeCompany(ShareWithCompanyName);
        IF VendorToBeShared.get(SharedVendor."Vendor No.") then begin
            if not NewVendor.get(SharedVendor."Vendor No.") then begin
                NewVendor.Init();
                NewVendor.TransferFields(VendorToBeShared, true);
                NewVendor.insert(false);
            end else begin
                NewVendor.TransferFields(VendorToBeShared, false);
                newvendor.Modify(false);
            end;
        end;
    end;

    local procedure CopyVendorBankInformation(SharedVendor: Record "Shared Vendor"; ShareWithCompanyName: Text[35])
    var
        PaymentManagementSetup: Record "Payment Setup";
    begin
        CopyVendorBankAccount(SharedVendor, ShareWithCompanyName);
        PaymentManagementSetup.ChangeCompany(ShareWithCompanyName);
        if PaymentManagementSetup.Get() then begin
            CopyVendorPaymentMethod(SharedVendor, ShareWithCompanyName);
            CopyVendorPaymentInformation(SharedVendor, ShareWithCompanyName);
        end;
    end;

    local procedure CopyVendorBankAccount(SharedVendor: Record "Shared Vendor"; ShareWithCompanyName: text[35])
    var
        VendorBankAccount: Record "Vendor Bank Account";
        NewVendorBankAccount: Record "Vendor Bank Account";
    begin
        VendorBankAccount.ChangeCompany(SharedVendor."Shared from Company Name");
        VendorBankAccount.setrange("Vendor No.", SharedVendor."Vendor No.");
        NewVendorBankAccount.ChangeCompany(ShareWithCompanyName);
        if VendorBankAccount.findset then repeat
            if not NewVendorBankAccount.get(VendorBankAccount."Vendor No.", VendorBankAccount.Code) then begin
                NewVendorBankAccount.Init();
                NewVendorBankAccount.TransferFields(VendorBankAccount, true);
                NewVendorBankAccount.Insert(false);
            end else begin
                NewVendorBankAccount.TransferFields(VendorBankAccount, false);
                NewVendorBankAccount.Modify(false);
            end;
        until VendorBankAccount.Next() = 0;
    end;

    local procedure CopyVendorPaymentMethod(SharedVendor: Record "Shared Vendor"; ShareWithCompanyName: Text[35])
    var
        VendorPaymentMethod: Record "Vendor/Payment Method";
        NewVendorPaymentMethod: Record "Vendor/Payment Method";
    begin
        VendorPaymentMethod.ChangeCompany(SharedVendor."Shared from Company Name");
        VendorPaymentMethod.setrange("Vendor No.", SharedVendor."Vendor No.");
        NewVendorPaymentMethod.ChangeCompany(ShareWithCompanyName);
        if VendorPaymentMethod.FindSet() then repeat
            if not NewVendorPaymentMethod.Get(VendorPaymentMethod."Vendor No.", VendorPaymentMethod."Payment Method") then begin
                NewVendorPaymentMethod.init();
                NewVendorPaymentMethod.TransferFields(VendorPaymentMethod, true);
                NewVendorPaymentMethod.Insert(false);
            end else begin
                NewVendorPaymentMethod.TransferFields(VendorPaymentMethod, false);
                NewVendorPaymentMethod.Modify(false);
            end;
        until VendorPaymentMethod.Next() = 0;
    end;

    local procedure CopyVendorPaymentInformation(SharedVendor: Record "Shared Vendor"; ShareWithCompanyName: Text[35])
    var
        VendorPaymentInformation: Record "Vendor/Payment Information";
        NewVendorPaymentInformation: Record "Vendor/Payment Information";
    begin
        VendorPaymentInformation.ChangeCompany(SharedVendor."Shared from Company Name");
        NewVendorPaymentInformation.ChangeCompany(ShareWithCompanyName);
        if VendorPaymentInformation.Get(SharedVendor."Vendor No.") then begin
            if not NewVendorPaymentInformation.get(SharedVendor."Vendor No.") then begin
                NewVendorPaymentInformation.Init();
                NewVendorPaymentInformation.TransferFields(VendorPaymentInformation, true);
                NewVendorPaymentInformation.Insert(false);
            end else begin
                NewVendorPaymentInformation.TransferFields(VendorPaymentInformation, false);
                NewVendorPaymentInformation.Modify(false);
            end;
        end;
    end;

    local procedure UpdateSharedVendor(Vendor: Record Vendor; FromCompany: Text[35])
    var
        SharedVendor: Record "Shared Vendor";
        SharedVendorSubscriberTemp: Record "Shared Vendor Subscriber" temporary;
    begin
        GetSharedVendorList(SharedVendorSubscriberTemp, Vendor."No.", FromCompany, '');
        if SharedVendorSubscriberTemp.FindSet() then repeat
            SharedVendor.Get(SharedVendorSubscriberTemp."Shared from Company Name", SharedVendorSubscriberTemp."Vendor No.");
            CopySharedVendor(SharedVendor, SharedVendorSubscriberTemp."Shared to Company Name");
        until SharedVendorSubscriberTemp.Next() = 0;

    end;


    local procedure UpdateVendorBankAccount(Vendor: Record Vendor; FromCompany: Text[35])
    var
        SharedVendor: Record "Shared Vendor";
        SharedVendorSubscriberTemp: Record "Shared Vendor Subscriber" temporary;
    begin
        GetSharedVendorList(SharedVendorSubscriberTemp, Vendor."No.", FromCompany, '');
        if SharedVendorSubscriberTemp.FindSet() then repeat
            SharedVendor.get(SharedVendorSubscriberTemp."Shared from Company Name", SharedVendorSubscriberTemp."Vendor No.");
            CopyVendorBankAccount(SharedVendor, SharedVendorSubscriberTemp."Shared to Company Name");
        until SharedVendorSubscriberTemp.Next() = 0;
    end;

    local procedure UpdateVendorPaymentMethod(Vendor: Record Vendor; FromCompany: Text[35])
    var
        SharedVendor: Record "Shared Vendor";
        SharedVendorSubscriberTemp: Record "Shared Vendor Subscriber" temporary;
    begin
        GetSharedVendorList(SharedVendorSubscriberTemp, vendor."No.", FromCompany, '');
        if SharedVendorSubscriberTemp.FindSet() then repeat
            SharedVendor.get(SharedVendorSubscriberTemp."Shared from Company Name", SharedVendorSubscriberTemp."Vendor No.");
            CopyVendorPaymentMethod(SharedVendor, SharedVendorSubscriberTemp."Shared to Company Name");
        until SharedVendorSubscriberTemp.Next() = 0
    end;

    local procedure UpdateVendorPaymentInformation(Vendor: Record Vendor; FromCompany: Text[35])
    var
        SharedVendor: Record "Shared Vendor";
        SharedVendorSubscriberTemp: Record "Shared Vendor Subscriber" temporary;
    begin
        GetSharedVendorList(SharedVendorSubscriberTemp, Vendor."No.", FromCompany, '');
        if SharedVendorSubscriberTemp.FindSet() then repeat
            SharedVendor.get(SharedVendorSubscriberTemp."Shared from Company Name", SharedVendorSubscriberTemp."Vendor No.");
            CopyVendorPaymentInformation(SharedVendor, SharedVendorSubscriberTemp."Shared to Company Name");
        until SharedVendorSubscriberTemp.Next() = 0;
    end;

    local procedure BlockVendor(InCompany: text[35]; VendorNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        Vendor.ChangeCompany(InCompany);
        if Vendor.Get(VendorNo) then begin
            Vendor.Blocked := Vendor.Blocked::All;
            Vendor.Modify(false);
        end;
    end;

    local procedure VendorIsShared(VendorNo: Code[20]): Boolean
    var
        SharedVendorSubscriber: Record "Shared Vendor Subscriber";
    begin
        SharedVendorSubscriber.SetRange("Vendor No.", VendorNo);
        exit(SharedVendorSubscriber.Count() <> 0);
    end;

    local procedure GetSharedVendorList(SharedVendorSubscriberTemp: Record "Shared Vendor Subscriber"; VendorNoFilter: Text[1024]; FromCompanyNameFilter: Text[1024]; ToCompanyNameFilter: Text[1024])
    var
        SharedVendorSubscriber: Record "Shared Vendor Subscriber";
    begin
        if VendorNoFilter <> '' then
            SharedVendorSubscriber.SetFilter("Vendor No.", VendorNoFilter);
        if FromCompanyNameFilter <> '' then
            SharedVendorSubscriber.SetFilter("Shared from Company Name", FromCompanyNameFilter);
        if ToCompanyNameFilter <> '' then
            SharedVendorSubscriber.SetFilter("Shared to Company Name", ToCompanyNameFilter);
        if SharedVendorSubscriber.FindSet() then repeat
            SharedVendorSubscriberTemp := SharedVendorSubscriber;
            if not SharedVendorSubscriberTemp.Insert() then;
        until SharedVendorSubscriber.Next() = 0;
    end;

    local procedure ThisCompanySharesItsVendors(): Boolean
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get();
        exit(PurchasesPayablesSetup."Share Vendors"); 
    end;
    //</functions>





    //<events>
    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterInsertEvent', '', true, true)]
    local procedure SetVendorAsSharedOnAfterInsert(var Rec: Record Vendor; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot insert Vendors in this company. Subscribe to the vendors that you want to use.', comment = '', Maxlength = 999, locked = true;
    begin
        If not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then
            SetVendorAsShared(Rec, CompanyName())
        else
            Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifySharedVendorOnAfterModify(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot modify Vedors in this company. Modify the vendor in the company it is created in.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        if ThisCompanySharesItsVendors() then
            SetVendorAsShared(Rec, CompanyName())
        else
            Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteSharedVendorOnAfterDelete(var Rec: Record Vendor; Runtrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot delete Vendors.', comment = '', Maxlength = 999, locked = true;
    begin
        if not Runtrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterRenameEvent', '', true, true)]
    local procedure RenameSharedVendorOnAfterRename(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot rename Vendors.', comment = '', Maxlength = 999, locked = true;
    begin
        if not Runtrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertSharedVendorBankAccountOnAfterInsert(var Rec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot insert Vendor Bank Accounts in this company. Subscribe to the vendors that you want to use.', comment = '', Maxlength = 999, locked = true;
        Vendor: Record Vendor;
    begin
        if not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then begin
            Vendor.Get(Rec."Vendor No.");
            UpdateVendorBankAccount(Vendor, CompanyName())
        end else
            Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifySharedVendorBankAccountOnAfterModify(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot modify Vendor Bank Accounts in this company. Subscribe to the vendors that you want to use.', comment = '', Maxlength = 999, locked = true;
        Vendor: Record Vendor;
    begin
        if not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then begin
            Vendor.Get(Rec."Vendor No.");
            UpdateVendorBankAccount(Vendor, CompanyName());
        end else
            Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteSharedVendorBankAccountOnAfterDelete(var Rec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot delete Vendor Bank Accounts.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterRenameEvent', '', true, true)]
    local procedure RenameSharedVendorBankAccountOnAfterRename(var Rec: Record "Vendor Bank Account"; var xRec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot rename Vendor Bank Accounts.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Method", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertSharedVendorPaymentMethodOnAfterInsert(var Rec: Record "Vendor/Payment Method"; RunTrigger: Boolean)
    var
        Vendor: Record Vendor;
        ErrorMsg: Label 'You cannot insert Vendor Payment Methods in this company. Subscribe to the vendors that you want to use.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then begin
            Vendor.Get(Rec."Vendor No.");
            UpdateVendorPaymentMethod(Vendor, CompanyName());
        end else
            Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Method", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifySharedVendorPaymentMethodOnAfterModify(var Rec: Record "Vendor/Payment Method"; var xRec: Record "Vendor/Payment Method"; RunTrigger: Boolean)
    var
        Vendor: Record Vendor;
        ErrorMsg: Label 'You cannot modify Vendor Payment Methods in this company. Modify it in the company it is created in.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then begin
            Vendor.Get(Rec."Vendor No.");
            UpdateVendorPaymentMethod(Vendor, CompanyName());
        end else
            Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Method", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteSharedVendorPaymentMethodOnAfterDelete(var Rec: Record "Vendor/Payment Method"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot delete Vendor Payment Methods.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Method", 'OnAfterRenameEvent', '', true, true)]
    local procedure RenameSharedVendorPaymentMethodOnAfterRename(var Rec: Record "Vendor/Payment Method"; var xRec: Record "Vendor/Payment Method"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot rename Vendor Payment Methods.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Information", 'OnAfterInsertEvent', '', true, true)]
    local procedure InsertSharedVendorPaymentInformationOnAfterInsert(var Rec: Record "Vendor/Payment Information"; RunTrigger: Boolean)
    var
        Vendor: Record Vendor;
        ErrorMsg: Label 'You cannot insert Vendor Payment Information in this company. Subscribe to the vendors that you want to use.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then begin
            Vendor.Get(Rec."Vendor No.");
            UpdateVendorPaymentInformation(Vendor, CompanyName());
        end else
            Error(ErrorMsg);
        ;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Information", 'OnAfterModifyEvent', '', true, true)]
    local procedure ModifySharedVendorPaymentInformationOnAfterModify(var Rec: Record "Vendor/Payment Information"; var xRec: Record "Vendor/Payment Information"; RunTrigger: Boolean)
    var
        Vendor: Record Vendor;
        ErrorMsg: Label 'You cannot modify Vendor Payment Information in this company. Modify it in the company it is created in.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;

        if ThisCompanySharesItsVendors() then begin
            Vendor.Get(Rec."Vendor No.");
            UpdateVendorPaymentInformation(Vendor, CompanyName());
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Information", 'OnAfterDeleteEvent', '', true, true)]
    local procedure DeleteSharedVendorPaymentInformationOnAfterDelete(var Rec: Record "Vendor/Payment Information"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot delete payment information.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        Error(ErrorMsg);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor/Payment Information", 'OnAfterRenameEvent', '', true, true)]
    local procedure RenameSharedVendorPaymentInformationOnAfterRename(var Rec: Record "Vendor/Payment Information"; var xRec: Record "Vendor/Payment Information"; RunTrigger: Boolean)
    var
        ErrorMsg: Label 'You cannot rename Payment Information.', comment = '', Maxlength = 999, locked = true;
    begin
        if not RunTrigger then
            exit;
        Error(ErrorMsg);
    end;
    //</events>
}
// added group sharing  - added field share vendors to new group.
pageextension 50022 AddShareVendorGroup extends 460
{
    layout
    {
        addafter("Default Accounts")
        {
            group(Sharing)
            {
                Caption = 'Deling';

                
            }
            
        }
        
    }

}
public class AccountHandler {
    public static Account insertNewAccount (String nombre)
    {
        if(nombre == ''){
            Return null;
        }else{
            
        }
        Account acct = new Account(Name = nombre);
        Insert acct;
        Return acct;
    }
    public static void insertAccount (integer numeroCuentas )
    {
        List<Account> addAccounts = new List<Account>();
        Integer A = 0 ;
        
        while(A <= numeroCuentas)
        {
            Account cuenta = new Account();
            cuenta.Name = 'Acme Inc '+A;
            cuenta.AccountNumber = 'A000'+A;
            A++;
            addAccounts.add(cuenta);
        }
        
        Insert addAccounts;
        system.debug(addAccounts);
    }
}
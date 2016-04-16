//Oppinlinecontroller 
@isTest
public class OppinlinecontrollerTest{

        
        Static testmethod void TestPositiveCase()
    {
            PageReference pageRef = Page.TaskHistory;           
            Test.setCurrentPageReference(pageRef);

            //Create Account
            Account ac = new Account (name='XYZ Organization');
            insert ac;

            //Create Opportunity
            Opportunity op = new Opportunity (name='test opportunity');
            op.AccountId = ac.Id;
            op.Type = 'New Users';
            op.StageName = 'Win';
            op.CloseDate = system.today();
            insert op;
            
            //create a contact
            Contact c = new Contact(LastName ='xyz',AccountId=ac.Id);
            insert c;
           
           ApexPages.currentPage().getParameters().put('id', op.Id);
           ApexPages.StandardController sc = new ApexPages.standardController(op);
           
           
           Oppinlinecontroller ic = new Oppinlinecontroller(sc);
    }

}
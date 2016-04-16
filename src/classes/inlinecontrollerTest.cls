//inlinecontroller 
@isTest
public class inlinecontrollerTest
{
    Static testmethod void TestPositiveCase()
    {
            PageReference pageRef = Page.OpenOpportunities;
           
            Test.setCurrentPageReference(pageRef);

            //Create Account
            Account ac = new Account (name='XYZ Organization');
            insert ac;

            //Create Opportunity
            Opportunity op = new Opportunity (name='test opportunity');
            op.Account = ac;
            op.Type = 'New Users';
            op.StageName = 'Win';
            op.CloseDate = system.today();
            insert op;
            
            //create a contact
            Contact c = new Contact(LastName ='xyz',AccountId=ac.Id);
            insert c;
           
           
           ApexPages.StandardController sc = new ApexPages.standardController(op);
           ApexPages.currentPage().getParameters().put('id', c.Id);
           inlinecontroller ic = new inlinecontroller(sc);
    }
    
}
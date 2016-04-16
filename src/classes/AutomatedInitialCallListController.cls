/********************************************************************************
@author Abhishek Parghi
@date 12/24/2015
@description: Controller for AutomatedInitialCallList Page 
*********************************************************************************/
public class AutomatedInitialCallListController {

  public List<SelectOption> paginationSizeOptions{get;set;}
       Public Integer size{get;set;} 
       Public Integer noOfRecords{get; set;} 
    //   public List<AutomatedCallListWrapper> AccountLista {get; set;}
       List<AutomatedCallListWrapper2> categories {get;set;}

  //  public List<AutomatedCallListWrapper> Ac1 {get; set;}
    // instantiate the StandardSetController from a query locator
   public AutomatedInitialCallListController (ApexPages.StandardSetController controller) {
        con= controller;
    }
    public AutomatedInitialCallListController (){
        size=50;
        
        paginationSizeOptions = new List<SelectOption>();
    //  paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
    //    paginationSizeOptions.add(new SelectOption('100','100'));
    }
     
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                con = new ApexPages.StandardSetController(Database.getQueryLocator([select FirstName,Full_Name__pc,
                                                                                    PersonHomePhone,PersonOtherPhone,Createddate,PersonMobilephone,Initial_CallList_Follow_up_Date__c, 
                                                                                    Patient_Care_Follow_up__c,Id,Initial_List_FollowUp_Date__c,
                                                                                    BillingState, Name, SMS_Opt_Out__c,Has_PCS_Notes__c,
                                                                                    DOB__c,Pediatric__c,Phone,Initial_call__c,PCS_Additional_Information__c,
                                                                                    Territory_Code__c, ispersonaccount from Account 
                                                                                    where Initial_call__c =true AND Account_Record_Type__c = 'Consumers'
                                                                                    AND Initial_List_FollowUp_Date__c<=Today
                                                                                    Order by Initial_List_FollowUp_Date__c DESC LIMIT 10000]));
                // sets the number of records in each page set
             
                con.setPageSize(size);
                noOfRecords = Con.getResultSize();
            }
            return con;
        }
        set;
    }

    // returns a list of wrapper objects for the sObjects in the current page set
  public List<AutomatedCallListWrapper2> getCategories() {
        categories = new List<AutomatedCallListWrapper2>();
        for (Account category : (List<Account>)con.getRecords())
            categories.add(new AutomatedCallListWrapper2(category));

        return categories;
    }

    public PageReference processSelected() {
  
        List<Account> selectedAccounts = new List<Account>();
        List<Account> Accs = new List<Account>();
        List<Dx_Notes__c> PCSNotes = new List<Dx_Notes__c>();
    
        
        for(AutomatedCallListWrapper2 cCon: categories) {
            if(cCon.checked ) {
                selectedAccounts.add(cCon.cc);
                
            }
        }
        // logic
        system.debug('selectedAccounts  ' + selectedAccounts .size() + '.');
        for(Account con: selectedAccounts) {
           IF(Con.id != null){
              PCSNotes.add(new Dx_Notes__c(Return_Call_List__c= true,
                                          Call_Type__c = 'Outbound',
                                          Comments__c = 'PC NOTE: Outreach to customer. Information about product training, education and ongoing support resources provided.',
                                          CONSUMER__c = Con.id,
                                          Oracle_Notes_Id__c = '1259',
                                          PC_Reasons__c = '840 Patient Care Outreach',
                                          Interaction_Status__c = 'Follow up in 30')); 
           
           }
            system.debug(con);
        }
        Insert PCSNotes;
        
        categories=null; // we need this line if we performed a write operation  because getAccounts gets a fresh list now
         PageReference pageRef3 = new PageReference('/apex/AutomatedInitialCallList');
        pageRef3.setRedirect(true);
        return pageRef3;
    }
    public PageReference processSelected2() {
  
        List<Account> selectedAccounts = new List<Account>();
        List<Account> Accs = new List<Account>();
        List<Dx_Notes__c> PCSNotes = new List<Dx_Notes__c>();
    
        
        for(AutomatedCallListWrapper2 cCon: categories) {
            if(cCon.checked ) {
                selectedAccounts.add(cCon.cc);
                
            }
        }
        // logic
        system.debug('selectedAccounts  ' + selectedAccounts .size() + '.');
        for(Account con: selectedAccounts) {
           IF(Con.id != null){
              PCSNotes.add(new Dx_Notes__c(Return_Call_List__c= true,
                                          Call_Type__c = 'Outbound',
                                          Comments__c = 'PC NOTE: Outreach to customer. Information about product training, education and ongoing support resources provided.',
                                          CONSUMER__c = Con.id,
                                          Oracle_Notes_Id__c = '1259',
                                          PC_Reasons__c = '840 Patient Care Outreach',
                                          Interaction_Status__c = 'Follow up in 14')); 
           
           }
            system.debug(con);
        }
        Insert PCSNotes;
        
        categories=null; // we need this line if we performed a write operation  because getAccounts gets a fresh list now
         PageReference pageRef4 = new PageReference('/apex/AutomatedInitialCallList');
        pageRef4.setRedirect(true);
        return pageRef4;
    }public PageReference processSelected3() {
  
        List<Account> selectedAccounts = new List<Account>();
        List<Account> Accs = new List<Account>();
        List<Dx_Notes__c> PCSNotes = new List<Dx_Notes__c>();
    
        
        for(AutomatedCallListWrapper2 cCon: categories) {
            if(cCon.checked ) {
                selectedAccounts.add(cCon.cc);
                
            }
        }
        // logic
        system.debug('selectedAccounts  ' + selectedAccounts .size() + '.');
        for(Account con: selectedAccounts) {
           IF(Con.id != null){
              PCSNotes.add(new Dx_Notes__c(Return_Call_List__c= true,
                                          Call_Type__c = 'Outbound',
                                          Comments__c = 'PC NOTE: Outreach to customer. Information about product training, education and ongoing support resources provided.',
                                          CONSUMER__c = Con.id,
                                          Oracle_Notes_Id__c = '1259',
                                          PC_Reasons__c = '840 Patient Care Outreach',
                                          Interaction_Status__c = 'Follow up in 7')); 
           
           }
            system.debug(con);
        }
        Insert PCSNotes;
        
        categories=null; // we need this line if we performed a write operation  because getAccounts gets a fresh list now
         PageReference pageRef5 = new PageReference('/apex/AutomatedInitialCallList');
        pageRef5.setRedirect(true);
        return pageRef5;
    }
    public PageReference processSelected4() {
  
        List<Account> selectedAccounts = new List<Account>();
        List<Account> Accs = new List<Account>();
        List<Dx_Notes__c> PCSNotes = new List<Dx_Notes__c>();
    
        
        for(AutomatedCallListWrapper2 cCon: categories) {
            if(cCon.checked ) {
                selectedAccounts.add(cCon.cc);
                
            }
        }
        // logic
        system.debug('selectedAccounts  ' + selectedAccounts .size() + '.');
        for(Account con: selectedAccounts) {
           IF(Con.id != null){
              PCSNotes.add(new Dx_Notes__c(Return_Call_List__c= true,
                                          Call_Type__c = 'Outbound',
                                          Comments__c = 'PC NOTE: Outreach to customer. Information about product training, education and ongoing support resources provided.',
                                          CONSUMER__c = Con.id,
                                          Oracle_Notes_Id__c = '1259',
                                          PC_Reasons__c = '840 Patient Care Outreach',
                                          Interaction_Status__c = 'Follow up in 60')); 
           
           }
            system.debug(con);
        }
        Insert PCSNotes;
        
        categories=null; // we need this line if we performed a write operation  because getAccounts gets a fresh list now
         PageReference pageRef6 = new PageReference('/apex/AutomatedInitialCallList');
        pageRef6.setRedirect(true);
        return pageRef6;
    }
    
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }

    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }set;
    }
    // returns the first page of records
     public void first() {
         con.first();
     }
     // returns the last page of records
     public void last() {
         con.last();
     }
     // returns the previous page of records
     public void previous() {
         con.previous();
     }
     // returns the next page of records
     public void next() {
         con.next();
     }
     // returns the PageReference of the original page, if known, or the home page.
     public void cancel() {
         con.cancel();
     }
public class AutomatedCallListWrapper2{
    public Boolean checked{ get; set; }
    public Account cc { get; set;}
    public AutomatedCallListWrapper2(Account c){
        cc = c;
        checked = false;
        this.cc =c;
    }    
}
 public PageReference refreshPageSize() {
         Con.setPageSize(size);
         return null;
    } 
}
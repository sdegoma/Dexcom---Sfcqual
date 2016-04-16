public class LeadPageController {
      public  ApexPages.StandardController controller {get; set;}

    public string LeadID = ApexPages.currentPage().getparameters().get('id'); // Stores Agreement Id

    public Lead L; 
    public LeadPageController (ApexPages.StandardController controller) {
        this.controller = controller;        
        L = (Lead)controller.getRecord();              
    }
  
      public Pagereference save(){
        L.Leadsource = 'Inside Sales';
        L.Dex_Campaign__c = '701330000012ocfAAA';
        PageReference detailPage = controller.save();
        if(detailPage != null){ 
        pagereference Pref1 = new PageReference('/home/home.jsp');
        Pref1.setRedirect(true);
        return Pref1;
        }else{        
         return detailPage;
        }  
    }  
}
/**********************************************************
 **Description: Lead trigger handler Class. All the CRUD events are handled here.
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JUN.01.2015
**********************************************************/
public class LeadTriggerHandler {

    //initialize all the custom setting variables used for scoring
    public static Decimal lsContactInfoHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Contact_Info_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Contact Info High Value is missing');
            return ls.Contact_Info_High__c;
        }
    }

    public static Decimal lsContactInfoLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Contact_Info_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Contact Info Low Value is missing');
            return ls.Contact_Info_Low__c;
        }
    }

    public static Decimal lsContactInfoMid{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Contact_Info_Mid__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Contact Info Mid Value is missing');
            return ls.Contact_Info_Mid__c;
        }
    }
    //prescriber
    public static Decimal lsPrescriberInfoHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Prescriber_Info_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Prescriber Info High Value is missing');
            return ls.Prescriber_Info_High__c;
        }
    }

    public static Decimal lsPrescriberInfoLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Prescriber_Info_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Prescriber Info Low Value is missing');
            return ls.Prescriber_Info_Low__c;
        }
    }

    public static Decimal lsPrescriberInfoMid{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Prescriber_Info_Mid__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Prescriber Info Mid Value is missing');
            return ls.Prescriber_Info_Mid__c;
        }
    }
    // Insurance Info
    public static Decimal lsInsuranceInfoHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Insurance_Info_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Insurance Info High Value is missing');
            return ls.Insurance_Info_High__c;
        }
    }

    public static Decimal lsInsuranceInfoLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Insurance_Info_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Insurance Info Low Value is missing');
            return ls.Insurance_Info_Low__c;
        }
    }

    public static Decimal lsInsuranceInfoMid{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Insurance_Info_Mid__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Insurance Info Mid Value is missing');
            return ls.Insurance_Info_Mid__c;
        }
    }
    // Applicable
    public static Decimal lsApplicableHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Applicable_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Applicable High Value is missing');
            return ls.Applicable_High__c;
        }
    }
    public static Decimal lsApplicableMid{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Applicable_Mid__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Applicable Info Mid Value is missing');
            return ls.Applicable_Mid__c;
        }
    }
    // Interest
    public static Decimal lsInterestHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Interest_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Interest High Value is missing');
            return ls.Interest_High__c;
        }
    }

    public static Decimal lsInterestMid{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Interest_Mid__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Interest Mid Value is missing');
            return ls.Interest_Mid__c;
        }
    }

    public static Decimal lsInterestLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Interest_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Interest Low Value is missing');
            return ls.Interest_Low__c;
        }
    }
   // ---04.01.2016 Added by Abhishek Parghi---// 
    public static Decimal Interest{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Interest__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Interest');
            return ls.Interest__c;
        }
    }
    //**************************************** // 
    
    //qualified
        public static Decimal lsQualifiedOpportunityHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Qualified_Opportunity_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Qualified Opportunity High Value is missing');
            return ls.Qualified_Opportunity_High__c;
        }
    }

    public static Decimal lsQualifiedOpportunityLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Qualified_Opportunity_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Qualified Opportunity Low Value is missing');
            return ls.Qualified_Opportunity_Low__c;
        }
    }
    //active
        public static Decimal lsActiveEvaluationHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Active_Evaluation_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Active Evaluation High Value is missing');
            return ls.Active_Evaluation_High__c;
        }
    }

    public static Decimal lsActiveEvaluationLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Active_Evaluation_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Active Evaluation Low Value is missing');
            return ls.Active_Evaluation_Low__c;
        }
    }
    //potential
            public static Decimal lsPotentialOpportunityHigh{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Potential_Opportunity_High__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Potential Opportunity High Value is missing');
            return ls.Potential_Opportunity_High__c;
        }
    }

    public static Decimal lsPotentialOpportunityLow{
        Get{
            Lead_Scoring__c ls = Lead_Scoring__c.getOrgDefaults();
            if(ls == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Lead scoring custom settings not found');
            if(ls.Potential_Opportunity_Low__c == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Potential Opportunity Low Value is missing');
            return ls.Potential_Opportunity_Low__c;
        }
    }
    
    public static String defaultDexCampaign{
        Get{
            Default_Campaign__c dc = Default_Campaign__c.getOrgDefaults();
            if(dc == null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Default Campaign custom settings not found');
            if(dc.Default_Dex_Campaign__c== null) throw new LeadTriggerHandler.LeadTriggerHandlerException('Default Dex Campaign Value is missing');
            return dc.Default_Dex_Campaign__c;
        }
    }
    
    private static boolean alreadyConverted = false;
    
    public static void onBeforeInsert(List<Lead> listLead){
        existingAccounts(listLead);
        leadScoring(listLead);
        UpdateLeads(listLead);
    }

    public static void onBeforeUpdate(List<Lead> listLead){
        existingAccounts(listLead);
        leadScoring(listLead);
    }

    public static void onAfterUpdate(List<Lead> listLead){
        
        //if(!alreadyConverted){       //Lead conversion for updated Leads now handled by LeadConversionBatch class
        //	leadConversion(listLead);
        //}
    }

    public static void onAfterInsert(List<Lead> listLead){
        UrlExpiryBatchJob urlE = new UrlExpiryBatchJob();
        urlE.urlExpiry(listLead);
        createCampaignMember(listLead);
        
        if(!alreadyConverted){
        	leadConversion(listLead);
        }
    }

    /**********************************************************
     **Description: Checks for an Account with matching email or phone, flags the Lead.
     **Parameters:  List<Lead> listLead
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    public static void existingAccounts(List<Lead> listLead){
        // check email leads.
        List<Account> listAccount = new List<Account>();
        List<Lead> listLeadUpsert = new List<Lead>();
        Map<String,List<Account>> mapAccount = new Map<String,List<Account>>();
        Set<String> setLeadLastName = new Set<String>();
        String LeadLastName;
        try{
            for(Lead l:listLead){
                if(l.hasAccount__c == false && l.isConverted == false){
                    setLeadLastName.add(l.LastName);
                }
            }

            listAccount = [SELECT Id,PersonEmail,Phone,LastName FROM Account WHERE LastName IN :setLeadLastName];
            if(listAccount.size() > 0){
                for(Account a: listAccount){
                    if(mapAccount.get(a.LastName) != null){
                        mapAccount.get(a.LastName).add(a);
                    }else{
                        mapAccount.put(a.LastName,new List<Account>{a});
                    }
                }
            }
            
            for(Lead l:listLead){
                if(l.hasAccount__c == false && l.isConverted == false){
                    LeadLastName = TitleCase(l.lastName);
                    System.debug('##AP##' + LeadLastName);
                    List<Account> listAccountNew = mapAccount.get(LeadLastName);
                    
                    if(listAccountNew.size() > 0){
                    
                    for(Account a:listAccountNew){ 
                        if(mapAccount.containsKey(LeadLastName)){
                                System.debug('#### matching lastname is in account map ' + LeadLastName);
                                
                                //this section for testing/debugging only (scottie)
                                System.Debug('#### EMAIL IS NOT NULL');
                                System.Debug('#### EMAIL: ' + l.email);
                                System.Debug('#### PMAIL: ' + a.PersonEmail);
                                System.Debug('#### LNAME: ' + l.lastname);
                                System.Debug('#### ANAME: ' + a.LastName);
                                
                                //check for match on lastname and email
                                if(l.Email != NULL && l.Email == a.PersonEmail && LeadLastName == a.LastName){
                                    System.debug('#### MATCH ON LASTNAME AND EMAIL');
                                    l.hasAccount__c = true;
                                }
                                
                                //check for match on lastname and phone number
                                if(l.Phone != NULL && l.Phone == a.Phone && LeadLastName == a.LastName){
                                    System.debug('#### MATCH ON LASTNAME AND PHONE');
                                    l.hasAccount__c = true;
                                }
                                
                                listLeadUpsert.add(l); 
                        }
                    }
                    }//end if listAccountNew.size > 0
                }
            }
        }catch(Exception e){
            System.debug('### Exception existingAccounts' +e);
        }
    }
   
    /**********************************************************
     **Description: Updates the lead status based from the score that it gets based from the fields that has values.
     **Parameters:  List<Lead> listLead
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    public static void leadScoring(List<Lead> listLead){

        Decimal total = 0;
        List<Lead> listLeadUpsert = new List<Lead>();
        Boolean disqualified = false;
        try{
            if(listLead.size() > 0){
                for(Lead l: listLead){
                    if(l.hasAccount__c == false && l.Initial_Data_Load__c == false && l.isConverted == false){
                        //Applicable
                        if(l.Patient_Diabetes_Type__c == 'Type 1' ||  l.Patient_Diabetes_Type__c == 'Type 2' || l.Patient_Diabetes_Type__c == 'Gestational'){
                            total = total + lsApplicableHigh;
                        }else if(l.Patient_Diabetes_Type__c == null){
                            total = total + lsApplicableMid;
                        }else{
                            disqualified = true;
                        }
                        System.debug('##### Total Score after Applicable ' + total);
                        
                        //contact info
                        if((l.Email != null && l.Phone !=null  && l.City != null && l.PostalCode != null) || 
                            (l.Phone !=null  && l.City != null && l.PostalCode != null) ||
                            (l.Email != null && l.City != null && l.PostalCode != null)){
                            total = total + lsContactInfoHigh;
                        }else if(l.Email != null || l.Phone != null){ //&& l.State == null && l.City == null && l.Street == null && l.PostalCode == null){
                            total = total + lsContactInfoMid;
                        }else{
                            total = total + lsContactInfoLow;
                        }
                        System.debug('##### Total Score after Contact ' + total);
                        
                        //prescriber info
                        if(l.Doctor_Name__c != null && l.Doctor_City__c !=null && l.Doctor_Zip__c != null){
                            total = total + lsPrescriberInfoHigh;
                        }else if(l.Doctor_Name__c == null && l.Doctor_City__c ==null && l.Doctor_Zip__c == null){
                            total = total + lsPrescriberInfoLow;
                        }else{
                            total = total + lsPrescriberInfoMid;
                        }
                        System.debug('##### Total Score after Prescriber ' + total);
                        
                        //insurance Info
                        if(l.Insurance_Provider__c != null  && l.Insurance_Group_Number__c != null && l.Insurance_Member_ID__c !=null && l.Relationship_to_PH__c != null && 
                           l.Policy_Holder_First_Name__c !=null && l.Policy_Holder_Last_Name__c !=null  && l.Policy_Holder_DOB__c !=null){
                            total = total + lsInsuranceInfoHigh;
                        }else if(l.Insurance_Provider__c == null && l.Insurance_Group_Number__c == null && l.Insurance_Member_ID__c ==null && l.Relationship_to_PH__c == null && 
                           l.Policy_Holder_First_Name__c ==null && l.Policy_Holder_Last_Name__c ==null && l.Policy_Holder_DOB__c ==null){
                            total = total + lsInsuranceInfoLow;
                        }else{
                            total = total + lsInsuranceInfoMid;
                        }
                        System.debug('##### Total Score after Insurance ' + total);
                        
                        //Interest
                      // ---04.01.2016 Updated by Abhishek Parghi---//  
                     /* if(l.Interest_Level__c == 'Very Interested. I would like to begin the ordering process as soon as possible'){
                            total = total + lsInterestHigh;
                        }else if(l.Interest_Level__c == 'Somewhat interested. I'+'\''+'d like to do more research before starting the ordering process'){
                            total = total + lsInterestMid;
                        }else if(l.Interest_Level__c == 'Not Interested'){
                            disqualified = true;
                        }else{*/
                      // ---04.01.2016 Updated by Abhishek Parghi---// 
                        if(l.Interest_Level__c == null){    
                           total = total + Interest;
                        }
                        
                        System.debug('##### Total Score after Interest ' + total);
                        
                        //set the Lead status based on the total score
                        if(disqualified == true){
                            l.Lead_Score__c = 0.0;
                            l.Status = 'Not Qualified';
                            listLeadUpsert.add(l);
                        }else{
                            System.debug('##### Total Score ' + total);
                            if(total <= lsQualifiedOpportunityHigh && total >= lsQualifiedOpportunityLow){
                                l.Lead_Score__c = total;
                                l.Status = 'Qualified';
                                listLeadUpsert.add(l);
                            }else if(total <= lsActiveEvaluationHigh && total >= lsActiveEvaluationLow){
                                l.Lead_Score__c = total;
                                l.Status = 'Semi-Qualified - High';
                                listLeadUpsert.add(l);
                            }else if(total <= lsPotentialOpportunityHigh && total >= lsPotentialOpportunityLow){
                                l.Lead_Score__c = total;
                                l.Status = 'Semi-Qualified - Low';
                                listLeadUpsert.add(l);
                            }else{
                                l.Lead_Score__c = total;
                                l.Status = 'Prospect';
                                listLeadUpsert.add(l);
                            }
                        }
                        if(l.LeadSource == 'Clinician Referral Site' ||l.LeadSource == 'Inside Sales'){
                            System.debug('###Lead LeadSource');
                            l.Lead_Score__c = 0.0;
                            l.Status = 'Qualified';
                        }
                        
                    }//1st if 
                    total = 0;/*AP 8/3/2015 */
                }//for
            }//if
            
        }catch(Exception e){
            System.debug('### Exception leadScoring' +e);
        }
    }
    /**********************************************************
     **Description: Converts the lead into a account and contact if it has the status of Qualified.
     **Parameters:  List<Lead> listLead
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    public static void leadConversion(List<lead> listlead){
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];

        List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

        for(Lead l:listLead){
            if(l.hasAccount__c == false && l.Initial_Data_Load__c == false && l.isConverted == false){
                System.Debug('#####Lead to be converted status: ' + l.Status);
                if(l.status == 'Qualified'){
                    try{
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(l.Id);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        leadConverts.add(lc);
                        
                    }catch(Exception e){
                        System.debug('### Exception leadConversion' +e);
                    }
                }
            }
        }

        if (!leadConverts.isEmpty()) {
        	alreadyConverted = true;
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
        }
    }

    /**********************************************************
     **Description: Inserts a campaign member
     **Parameters:  List<Lead> listLead
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.09.2015
    **********************************************************/
    public static void createCampaignMember(List<Lead> listLead){
        List<CampaignMember> listCampaignMemberInsert = new List<CampaignMember>();
        Id campId;
        Map<String,Campaign> campIdMap = new Map<String,Campaign>([SELECT Id FROM Campaign]);
        try{
            for(Lead l:listLead){
                if(campIdMap.containsKey(l.Dex_Campaign__c)){
                    CampaignMember cm = new CampaignMember();
                    campId = l.Dex_Campaign__c;
                    cm.CampaignId = campId;
                    cm.Status = 'Responded';
                    cm.LeadId = l.Id;
                    listCampaignMemberInsert.add(cm);
                    System.debug('### Dex Cammp Id inside If ---  ' +l.Dex_Campaign__c);
                }else{
                    CampaignMember cm = new CampaignMember();
                    campId = defaultDexCampaign;
                    cm.CampaignId = campId;
                    cm.Status = 'Responded';
                    cm.LeadId = l.Id;
                    listCampaignMemberInsert.add(cm);
                    System.debug('### Dex Cammp Id inside Else ---  ' +l.Dex_Campaign__c);
                }
            }

            insert listCampaignMemberInsert;

        }catch(Exception e){
            System.debug('### Exception createCampaignMember' +e);
        }
    }
    public class LeadTriggerHandlerException extends Exception {}

    /*AP*/
     /**********************************************************
     **Description:    Convert a string to title case
     **Author:         Abhishek Parghi
     **Date Created:   Aug.07.2015
    **********************************************************/
    public static String TitleCase(String value) {
        	// Normalize - Convert to lowercase
        	value = value.toLowerCase();
        	// Hold each word
        	List<String> pieces = new List<String>();
        	// Split
        	for(String t : value.split(' ')) {
               // Capitalize each piece
               t = t.capitalize();
               // Add to pieces
               pieces.add(t);
            }
            // Join
            return String.join(pieces, ' ');
    }
    /*AP*/    
     /**********************************************************
     **Description:    Copy Doctor City/Zip to Patient City/Zip and 
                       If Patient Address is blank, write “Address Needed”  
     **Author:         Abhishek Parghi
     **Date Created:   Aug.17.2015
    **********************************************************/
     public static void UpdateLeads(List<Lead> listLead){
        if(listLead.size() > 0){
                for(Lead l: listLead){
                    if(l.Street == null){
                       l.Street = 'Address Needed'; 
                    } 
                   // ---04.01.2016 Updated by Abhishek Parghi---//  
                   // if(l.lastname != null){
                    if(l.lastname != null && l.Dex_Campaign__c =='70133000001LlUdAAK'){
                     if(l.PostalCode ==null || l.City ==null ){
                        l.PostalCode = l.Doctor_Zip__c;
                        l.City = l.Doctor_City__c;
                     }
                    }    
                }
        }
    }
}
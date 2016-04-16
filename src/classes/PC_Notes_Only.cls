/************************************
 *  PC Notes Only
 * Author : Venkat Kollimerla
 * Description:
 * This class collects the DX Notes to be presented to the TBMs and PCS users that includes only the PCS-generated DX Notes.
**************************************/
public with sharing class PC_Notes_Only{

Public List<DX_Notes__c> notesList { get;set; }
Public id AccRecId {get;set;}
public  string accName {get;set;}


    public PC_Notes_Only(ApexPages.StandardController controller) 
    { 
         AccRecId = [select id FROM Account where id =: ApexPages.currentPage().getParameters().get('id')].id;
         accName =  [select id,Name FROM Account where id =: ApexPages.currentPage().getParameters().get('id')].Name;
             
         notesList = [select id,Name,Call_Type__c,Comments__c,CreatedById,Oracle_Created_By__c,Oracle_Date_Created__c,CreatedDate,PC_Reasons__c,Interaction_Status__c FROM DX_Notes__c WHERE ( CONSUMER__c = : AccRecId AND Call_Type__c != '') ORDER BY CreatedDate DESC];
    }   
    
}
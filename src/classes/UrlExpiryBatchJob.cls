/**********************************************************
 **Description: url Expiry Batch Class. Updates the URL in the lead record every once a week.
 **Author:      Louis Augusto Del Rosario, CLOUD SHERPAS
 **Date Created:    JUN.25.2015
**********************************************************/
global class UrlExpiryBatchJob implements Database.Batchable<sObject> {
    //Custom Settings for the URL Expiry
    public static String secretKey{
        Get{
            URL_Expiry__c urlExp = URL_Expiry__c.getOrgDefaults();
            if(urlExp == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('URL Expiry custom settings not found');
            if(urlExp.secretKey__c == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('Secret key is missing');
            return urlExp.secretKey__c;
        }
    }

    public static String baseURL{
        Get{
            URL_Expiry__c urlExp = URL_Expiry__c.getOrgDefaults();
            if(urlExp == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('URL Expiry custom settings not found');
            if(urlExp.baseURL__c == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('Base URL is missing');
            return urlExp.baseURL__c;
        }
    }

    public static String algorithmName{
        Get{
            URL_Expiry__c urlExp = URL_Expiry__c.getOrgDefaults();
            if(urlExp == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('URL Expiry custom settings not found');
            if(urlExp.AlgorithmName__c == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('Algorithim Name is missing');
            return urlExp.AlgorithmName__c;
        }
    }

    public static Double expiryDate{
        Get{
            URL_Expiry__c urlExp = URL_Expiry__c.getOrgDefaults();
            if(urlExp == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('URL Expiry custom settings not found');
            if(urlExp.Expiry_Date__c == null) throw new UrlExpiryBatchJob.UrlExpiryBatchJobException('Expiry Date is missing');
            return urlExp.Expiry_Date__c;
        }
    }

    //Encode Generator.
    public String getEncodedPolicy(String sfLeadId){
        String bUrl = baseURL;
        Double addDays = expiryDate;
        Datetime timeNow = Datetime.now().addDays(Integer.valueOf(addDays));
        String convertedTime = timeConvert(timeNow);
        String leadId = sfLeadId;
        String policyString = getJSON(bUrl, convertedTime, leadId);
        return policyString;
        
        //scottie 07.10.2015 - removed this additiona base64Encode step so our signature will match theirs
        //Blob policyBlob = Blob.valueOf(policyString);
        //String encodedPolicy = EncodingUtil.base64Encode(policyBlob);
        //return encodedPolicy;
    }
    // policy statement
    private String getJSON(String baseURLEnc, String expireTime, String sfLeadId){

        String ps = '';
        ps += '{"Statement":[';
        ps += '{';
        ps += '"Resource":"'+ baseURLEnc+'",';
        ps += '"LeadId":"'+sfLeadId+'",';
        ps += '"Condition":{';
        ps += '"DateLessThan":{';
        ps += '"ExpireTime":'+ expireTime;
        ps += '}';
        ps += '}}]}';
        return ps;

    }
    // to convert time to unix format.
    public String timeConvert(Datetime timeNow){
        DateTime dateTimeNow = timeNow;
        String unixTime = ''+dateTimeNow.getTime()/1000;
        return unixTime;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<String> operators = new List<String> {'Open','Prospect','Semi-Qualified - Low','Semi-Qualified - High'};
        String query ='SELECT Id, Signed_URL__c FROM Lead  WHERE isConverted = false';
        query += ' AND Status IN :operators';
        return Database.getQueryLocator(query);
    }
    /**********************************************************
     **Description: Update the url field with the corresponding signature and expiry date.
     **Parameters:  List<Lead> listLead
     **Returns:     None
     **Author:      CLOUD SHERPAS, Louis Augusto Del Rosario
     **Date Created:    JUN.25.2015
    **********************************************************/
    public void urlExpiry(List<Lead> listLead){
        String algoName = algorithmName;
        String sKey = secretKey;
        Double addDays = expiryDate;
        Datetime timeNow = Datetime.now().addDays(Integer.valueOf(addDays));
        String convertedTime = timeConvert(timeNow);
        List<Lead> listLeadUpdate = new List<Lead>();
        List<Lead> listLeadInsert = new List<Lead>();
        try{
            Set<Id> LeadIds = new Set<Id>();
            for(Lead l:listLead){
                leadids.add(l.Id);
            }
            for(Lead le: [SELECT Id FROM Lead WHERE Id IN: leadIds ]){
                Blob policyString = Blob.valueOf(getEncodedPolicy(le.Id));
                Blob privateKey = Blob.valueOf(sKey);
                //uses the HMacSHA1 algorithim
                Blob hashSignature = Crypto.generateMac(algoName, policyString, privateKey);
                String encodedSignature = EncodingUtil.base64Encode(hashSignature);
                encodedSignature = EncodingUtil.urlEncode(encodedSignature, 'UTF-8');
                le.Signed_URL__c = baseURL + '?signature=' + encodedSignature + '&LeadId=' + le.Id + '&expires=' +convertedTime;
                listLeadUpdate.add(le);
            }
            if(!listLeadUpdate.isEmpty()){
                update listLeadUpdate;
            }
        }catch(Exception e){
            System.debug('### Exception urlExpiryBatch' +e);
        }
    }
    global void execute(Database.BatchableContext BC, List<Lead> listLead) {
        urlExpiry(listLead);
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    public class UrlExpiryBatchJobException extends Exception {}
    
}
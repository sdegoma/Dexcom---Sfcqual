/***************************************
 * @author      : Noy De Goma
 * @date        : JAN 26, 2015
 * @description : Class to invoke webservice for copay
***************************************/
public class CopayServiceCall{
    public static map<String, String> getCalloutResponseContents(String url, String reqBody) {
        try{
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            system.debug('URL****' + URL);
            req.setEndpoint(url);
            req.setMethod('POST');
            req.setBody(reqBody);
            //req.setTimeout(2000);
            req.setHeader('User-Agent', 'Fiddler');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Content-Length', '268');
            req.setHeader('Host', 'dexsfd.dexcom.com');
            HttpResponse res = h.send(req);
            System.debug(res.toString());
            System.debug('STATUS:'+res.getStatus());
            System.debug('STATUS_CODE:'+res.getStatusCode()); 
            System.debug('BODY:'+res.getBody());  
            map<String, String> results;    
            if (res.getStatus() == 'OK'){
                results = (map<String, String>)JSON.deserialize(res.getBody(), map<String, String>.class);
                if(results.get('ResponseCode') == '1'){
                    if(results.get('CopayPrice')!=null){
                        System.debug('=========================result==>>>>>>>>>>>>>>>>>>>>> ' + results);
                        return results;
                    }else{
                        System.debug('No CopayPrice Found.');
                        return results;
                    }
                }else{
                    System.debug('===========================>>>>>>>>>>>>>>>>>>>>> ' + results.get('Message'));
                    return results;
                }
            }else{
                System.debug('==== No Results Were Found ====');
                results = new map<String, String>();
                results.put('STATUS', res.getStatus());
                return results;
            }
        }catch(Exception e){
            System.debug('ERROR:'+e.getMessage());
        }
        return null;
    }
    
}
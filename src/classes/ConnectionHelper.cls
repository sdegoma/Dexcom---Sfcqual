public class ConnectionHelper 
{

        public static Id getConnectionId(String connectionName) //getConnectionId
            {
   
            List<PartnerNetworkConnection> partnerNetConList = [Select id from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];

                    if ( partnerNetConList.size() != 0 ) { return partnerNetConList.get(0).Id; }         

                    return null;
            }

       public static Id getConnectionOwnerId(String connectionName)  //getConnection OwnerId
            {     

            List<PartnerNetworkConnection> partnerNetConList = [Select createdById from PartnerNetworkConnection where connectionStatus = 'Accepted' and connectionName = :connectionName];
     

            if ( partnerNetConList.size() != 0 ) { return partnerNetConList.get(0).createdById; }         

            return null;

        }

}
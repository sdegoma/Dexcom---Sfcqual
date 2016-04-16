//ConnectionHelper 
@isTest

private class ConnectionHelperTest {
    
        static testMethod void runPositiveTestCases()
            {
            
           
            System.debug(ConnectionHelper.getConnectionId('Diabetes Specialty Center'));
            System.debug(ConnectionHelper.getConnectionOwnerId('Diabetes Specialty Center'));
            
            
            System.debug(ConnectionHelper.getConnectionId('zaqmlp'));
            System.debug(ConnectionHelper.getConnectionOwnerId('zaqmlp'));
            
            
            
            }

}
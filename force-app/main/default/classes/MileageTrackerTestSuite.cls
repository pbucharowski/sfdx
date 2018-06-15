@isTest
private class MileageTrackerTestSuite {

    static testMethod void runPositiveTestCases() {
        
        Double totalMiles = 0;
        final Double maxtotalMiles = 500;
        final Double singletotalMiles = 300;
        final Double u2Miles = 100;
  
        
        //Set up user
        User u1 = [SELECT Id FROM User WHERE Alias='UUser'];
        
        //Run As U1
        System.RunAs(u1){

            
        System.debug('Inserting 300  miles... (single record validation)');
        
        Mileage__c testMiles1 = new Mileage__c(Miles__c = 300, Date__c = System.today());
        insert testMiles1;
        
        //Validate single insert
        for(Mileage__c m:[SELECT miles__c FROM Mileage__c 
            WHERE CreatedDate = TODAY
            and CreatedById = :u1.id
            and miles__c != null]) {
                totalMiles += m.miles__c;
            }
        
        System.assertEquals(singletotalMiles, totalMiles);
    
    
        //Bulk validation   
        totalMiles = 0; 
        System.debug('Inserting 200 mileage records... (bulk validation)');
        
        List<Mileage__c> testMiles2 = new List<Mileage__c>();
        for(integer i=0; i<200; i++) {
            testMiles2.add( new Mileage__c(Miles__c = 1, Date__c = System.today()) );
        }
        insert testMiles2;
       
        for(Mileage__c m:[SELECT miles__c FROM Mileage__c
            WHERE CreatedDate = TODAY
            and CreatedById = :u1.Id
            and miles__c != null]) {
                totalMiles += m.miles__c;
            }
        
        System.assertEquals(maxtotalMiles, totalMiles);

        }//end RunAs(u1)


       //Validate additional user:
       totalMiles = 0;
       //Setup RunAs
       User u2 = [SELECT Id FROM User WHERE Alias='UUser'];
       System.RunAs(u2){
        
        Mileage__c testMiles3 = new Mileage__c(Miles__c = 100, Date__c = System.today());
        insert testMiles3;
        
                for(Mileage__c m:[SELECT miles__c FROM Mileage__c
            WHERE CreatedDate = TODAY
            and CreatedById = :u2.Id
            and miles__c != null]) {
                totalMiles += m.miles__c;
            }
        //Validate 
        System.assertEquals(u2Miles, totalMiles);
        
       } //System.RunAs(u2)

      
    } // runPositiveTestCases()
   
    static testMethod void runNegativeTestCases() {

       User u3 = [SELECT Id FROM User WHERE Alias='UUser'];
       System.RunAs(u3){
        
       System.debug('Inserting a record with 501 miles... (negative test case)');
        
       Mileage__c testMiles3 = new Mileage__c( Miles__c = 501, Date__c = System.today() );
        
        try {
            insert testMiles3;
        } catch (DmlException e) {
            //Assert Error Message
            System.assert( e.getMessage().contains('Insert failed. First exception on ' +
                'row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, ' +
                'Mileage request exceeds daily limit(500): [Miles__c]'), 
                e.getMessage() );
                  
            //Assert field
            System.assertEquals(Mileage__c.Miles__c, e.getDmlFields(0)[0]);
            
            //Assert Status Code
            System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                 e.getDmlStatusCode(0) );
        } //catch
       } //RunAs(u3) 
    } // runNegativeTestCases() 
  
    
} // class MileageTrackerTestSuite

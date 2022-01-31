public without sharing class OrderManager {
    
    public static List<Order__c> getOrderSortByName () {        
        List<Order__c> orders = [
            SELECT Name, 
                Master__c, 
                Master__r.Name, 
                Price__c, 
                End_Date__c, 
                Priority__c, 
                Car_Owner__r.Name, 
                Car__c, 
                Car__r.Name,  
                Car__r.Contact__c            
            FROM Order__c
            ORDER BY Name
            LIMIT 50
        ];
        return orders;        
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Order__c> filterByParam (String selectedPrice, String selectedPriority) {
        if(String.isBlank(selectedPrice) || String.isBlank(selectedPriority)) {
            return new List<Order__c>();
        } else if (selectedPrice != 'None' && selectedPriority == 'None') { 
            String query = 'SELECT Name, Master__c, Master__r.Name, Price__c, End_Date__c, Priority__c, Car_Owner__r.Name, Car__c, Car__r.Name,  Car__r.Contact__c ' +
                            + 'FROM Order__c ' +            
                            + 'WHERE Price__c ' + selectedPrice +
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        } else if (selectedPrice != 'None' && selectedPriority != 'None') { 
            String query = 'SELECT Name, Master__c, Master__r.Name, Price__c, End_Date__c, Priority__c, Car_Owner__r.Name, Car__c, Car__r.Name, Car__r.Contact__c ' +
                            + 'FROM Order__c ' +            
                            + 'WHERE Price__c ' + selectedPrice +
                            + 'AND Priority__c =:  selectedPriority' +
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        } else if (selectedPrice == 'None' && selectedPriority != 'None') { 
            String query = 'SELECT Name, Master__c, Master__r.Name, Price__c, End_Date__c, Priority__c, Car_Owner__r.Name, Car__c, Car__r.Name, Car__r.Contact__c ' +
                            + 'FROM Order__c ' +            
                            + 'WHERE Priority__c =:  selectedPriority' +
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        }else  { 
            List<Order__c> sortOrders = getOrderSortByName();
            return sortOrders;
        }
    }

    public static List<Order__c> getByCarOwnerId (Set<Id> orderIds, Id selectedCarOwnerId) {  
        List<Order__c> orders = [
            SELECT Id,
                    Name,
                    Master__c,
                    Price__c,
                    End_Date__c,
                    Priority__c,
                    Car__r.Contact__c, 
                    Car__r.Contact__r.Name
                    
            FROM Order__c
            WHERE Id =: orderIds AND Car__r.Contact__c =: selectedCarOwnerId
            ORDER BY Name
            LIMIT 50
        ];
        return orders;        
    }

    @AuraEnabled(cacheable=true)
    public static List<Order__c> getByCarOwnerId (String selectedCarOwnerId) {
        if (String.isEmpty(selectedCarOwnerId)) {
            return [
                SELECT Id,
                    Name,
                    Master__c,
                    Price__c,
                    End_Date__c,
                    Priority__c,
                    Car__r.Contact__c, 
                    Car__r.Contact__r.Name
                    
            FROM Order__c
            ORDER BY Name
            LIMIT 50
            ];
        } else {
            List<Order__c> orders = [
            SELECT Id,
                    Name,
                    Master__c,
                    Price__c,
                    End_Date__c,
                    Priority__c,
                    Car__r.Contact__c, 
                    Car__r.Contact__r.Name                    
            FROM Order__c
            WHERE Car__r.Contact__c =: selectedCarOwnerId
            ORDER BY Name
            LIMIT 50
            ];
            return orders; 
        }               
    }
    
    @AuraEnabled
    public static List<Order__c> upadateOrders (List<Id> orderIds, String selectedCarOwnerId) {
        System.debug(orderIds);
        System.debug(selectedCarOwnerId);
        List<Order__c> orders = [SELECT Car_Owner__c FROM Order__c WHERE Id IN :orderIds];
        System.debug(orders);
        for(Order__c ord :orders) {            
            ord.Car_Owner__c = selectedCarOwnerId;
        }
        System.debug(orders);
        upsert orders;
        return orders;
    }
}

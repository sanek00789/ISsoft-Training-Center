public without sharing class OrderManager {
    
    public static List<Order__c> getOrderSortByName () {        
        List<Order__c> orders = [
            SELECT Name,
                    Master__c,
                    Price__c,
                    End_Date__c,
                    Priority__c,
                    Car_Owner__r.Name
            FROM Order__c
            ORDER BY Name
            LIMIT 50
        ];
        return orders;        
    }
    
    public static List<Order__c> filterByParam (String sortField1, String sortField2) {
        if(String.isBlank(sortField1) || String.isBlank(sortField2)) {
            return new List<Order__c>();
        } else if (sortField1 != 'None' && sortField2 == 'None') { 
            String query = 'SELECT Name, Master__c, Price__c, End_Date__c, Priority__c, Car_Owner__r.Name ' +
                            + 'FROM Order__c ' +            
                            + 'WHERE Price__c ' + sortField1 +
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        } else if (sortField1 != 'None' && sortField2 != 'None') { 
            String query = 'SELECT Name, Master__c, Price__c, End_Date__c, Priority__c, Car_Owner__r.Name ' +
                            + 'FROM Order__c ' +            
                            + 'WHERE Price__c ' + sortField1 +
                            + 'AND Priority__c =:  sortField2' +
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        } else if (sortField1 == 'None' && sortField2 != 'None') { 
            String query = 'SELECT Name, Master__c, Price__c, End_Date__c, Priority__c, Car_Owner__r.Name ' +
                            + 'FROM Order__c ' +            
                            + 'WHERE Priority__c =:  sortField2' +
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        }else  { 
            List<Order__c> sortOrders = getOrderSortByName();
            return sortOrders;
        }
    }
}

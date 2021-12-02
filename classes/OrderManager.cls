public without sharing class OrderManager {
    
    public static List<Order__c> getOrderSortByName () {        
        List<Order__c> orders = [
            SELECT Name,
                    Master__c,
                    Price__c,
                    End_Date__c
            FROM Order__c
            ORDER BY Name
            LIMIT 50
        ];
        return orders;        
    }
    
    public static List<Order__c> sortByField (List<Order__c> orders, String sortField1, String sortField2) {
        if(orders == null || orders.isEmpty() || String.isBlank(sortField1) || String.isBlank(sortField2)) {
            return new List<Order__c>();
        } else { 
            String query = 'SELECT Name, Master__c, Price__c, End_Date__c ' +
                            + 'FROM Order__c ' +            
                            + 'ORDER BY ' + sortField1 + ', ' + sortField2 + 
                            + ' LIMIT 50';     
            List<Order__c> sortOrders = Database.query(query);
            return sortOrders;
        }
    }
}

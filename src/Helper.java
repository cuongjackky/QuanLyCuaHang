
import java.util.Random;
import java.util.regex.Pattern;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author 84978
 */
public class Helper {
    
    public String generateCustomerId(){
        String id ="KH";
        Random r = new Random();
        int n = new DBUpdater().CountNumberOfCustomer();
        if(n != -1){
            n++;
            String temp = Integer.toString(n);
            for(int i =0;i<6-temp.length();i++){
                id+="0";
            }
            id+=temp;
            for(int i =0;i<4;i++){
                int num = r.nextInt(26);
                char c = (char) ('A'+num);
                id+=c;
            }
        }
        
        
        return id;
               
    }
    public String generateUniqueCustomerId(){
        String id = generateCustomerId();
        while(new DBUpdater().checkUniqueCustomerID(id)){
            id =generateCustomerId();
        }
        return id;
    }
    public String generateOrderId(){
        String id ="DH";
        Random r = new Random();
        int n = new DBUpdater().CountNumberOfOrder();
        if(n != -1){
            n++;
            String temp = Integer.toString(n);
            for(int i =0;i<6-temp.length();i++){
                id+="0";
            }
            id+=temp;
            for(int i =0;i<4;i++){
                int num = r.nextInt(26);
                char c = (char) ('A'+num);
                id+=c;
            }
        }
        
        
        return id;
               
    }
    public String generateUniqueOrderId(){
        String id = generateOrderId();
        while(new DBUpdater().checkUniqueOrderID(id)){
            id =generateOrderId();
        }
        return id;
        
    }
    
        
        
    
  
    
    
}

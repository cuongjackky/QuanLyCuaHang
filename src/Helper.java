
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
    
    public String generateCustomerId(){ // Tạo một MaKH ngẫu nhiên
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
    public String generateUniqueCustomerId(){ // Tạo một MaKH ngẫu nhiên không bị trùng
        String id = generateCustomerId();
        while(new DBUpdater().checkUniqueCustomerID(id)){ // Khi bị trùng thì tạo mới một cái khác
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
    public String generateStaffId(){
        String id ="NV";
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
    public String generateUniqueStaffId(){
        String id = generateStaffId();
        while(new DBUpdater().checkUniqueStaffID(id)){
            id =generateStaffId();
        }
        return id;
        
    }
    public String generateImportWHId(){
        String id ="DN";
        Random r = new Random();
        int n = new DBUpdater().CountNumberOfImportWH();
        if(n != -1){
            n++;
            String temp = Integer.toString(n);
            for(int i =0;i<4-temp.length();i++){
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
    public String generateUniqueImportWHId(){
        String id = generateImportWHId();
        while(new DBUpdater().checkUniqueImportWHID(id)){
            id =generateImportWHId();
        }
        return id;
        
    }
    
        
        
    
  
    
    
}

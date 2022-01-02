
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
    public String TaoMaDanhMucNgauNhien(){
        String id = "DM";
        int n = new DBUpdater().DemSoDanhMuc();
        Random r = new Random();
        if(n != -1&&n<10000){
            n++;
            String temp = Integer.toString(n);
            for(int i =0;i<5-temp.length();i++){
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
    public String TaoMaDanhMucNgauNhienKhongTrungLap(){
        String id = TaoMaDanhMucNgauNhien();
        while(new DBUpdater().KTTrungLapDanhMuc(id)){ // Khi bị trùng thì tạo mới một cái khác
            id =TaoMaDanhMucNgauNhien();
        }
        return id;
    }
    public String TaoMaNhaCungCapNgauNhien(){
        String id = "NCC";
        int n = new DBUpdater().DemSoNhaCungCap();
        Random r = new Random();
        if(n != -1&&n<10000){
            n++;
            String temp = Integer.toString(n);
            for(int i =0;i<5-temp.length();i++){
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
    public String TaoMaNhaCungCapNgauNhienKhongTrungLap(){
        String id = TaoMaNhaCungCapNgauNhien();
        while(new DBUpdater().KTTrungLapNhaCungCap(id)){ // Khi bị trùng thì tạo mới một cái khác
            id =TaoMaNhaCungCapNgauNhien();
        }
        return id;
    }
    public String TaoMaSanPhamNgauNhien(){
        String id = "SP";
        int n = new DBUpdater().DemSoSanPham();
        Random r = new Random();
        if(n != -1&&n<1000000){
            n++;
            String temp = Integer.toString(n);
            for(int i =0;i<7-temp.length();i++){
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
    public String TaoMaSanPhamNgauNhienKhongTrungLap(){
        String id = TaoMaSanPhamNgauNhien();
        while(new DBUpdater().KTTrungLapNhaCungCap(id)){ // Khi bị trùng thì tạo mới một cái khác
            id =TaoMaSanPhamNgauNhien();
        }
        return id;
    }
    
    
    
        
        
    
  
    
    
}

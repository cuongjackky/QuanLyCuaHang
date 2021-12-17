/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author 84978
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import javax.swing.ComboBoxModel;
import javax.swing.DefaultComboBoxModel;
import java.sql.PreparedStatement;

import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class DBUpdater {
    String conString = "jdbc:sqlserver://localhost:1433;databaseName=QuanLyCuaHang";
    String username = "sa";
    String password = "123456";
    public Boolean checkUniqueUserName(String user){
             
        String sql = "SELECT * FROM TAIKHOAN_KH WHERE ID = '"+user + "'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
        
    }
    public int CountNumberOfCustomer(){
        String sql = "SELECT COUNT(*) FROM KHACHHANG";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                
                rs.next();
                int ans = 0;
                ans = Integer.parseInt(rs.getString(1));
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
    }
    public int CountNumberOfOrder(){
        String sql = "SELECT COUNT(*) FROM DONHANG";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                
                rs.next();
                int ans = 0;
                ans = Integer.parseInt(rs.getString(1));
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
    }
    public Boolean checkUniqueCustomerID(String id){
             
        String sql = "SELECT * FROM KHACHHANG WHERE MaKH = '"+id + "'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
        
    }
    public Boolean checkUniqueOrderID(String id){
             
        String sql = "SELECT * FROM DONHANG WHERE MaDH = '"+id + "'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
        
    }
    public Boolean CustomerLogin(String user, String pass){
        String sql = "Select * from TAIKHOAN_KH Where ID = '"+user+"' AND PassWord = '"+pass+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
    public Boolean EmployeeLogin(String user, String pass){
        String sql = "Select * from TAIKHOAN_NV Where ID = '"+user+"' AND PassWord = '"+pass+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
    
    public Boolean StoreOwnerLogin(String user, String pass){
        String sql = "Select * from TAIKHOAN_CCH Where ID = '"+user+"' AND PassWord = '"+pass+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
    
    public String getCustomerId(String user){
        String sql = "SELECT  * FROM TAIKHOAN_KH WHERE id ='"+user+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                
                rs.next();
                String ans = rs.getString(1);
                
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public String getCustomerFullName(String user){
        String sql = "SELECT  * FROM KHACHHANG WHERE MaKH ='"+user+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                
                rs.next();
                String ans = rs.getString(2).replace(" ", "")+" "+ rs.getString(3).replace(" ", "");
                
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public String getStoreId(String SuppliesId){
        String sql = "SELECT  * FROM SP_CH WHERE MaSP ='"+SuppliesId+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                
                rs.next();
                String ans = rs.getString(1);
                
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public DefaultTableModel getOrderHistory(String customerId) {
        //ADD COLUMNS TO TABLE MODEL
        DefaultTableModel dm = new DefaultTableModel();
        dm.addColumn("Mã đơn hàng");
        dm.addColumn("Mã cửa hàng");
        dm.addColumn("Ngày đặt");
        dm.addColumn("Tổng tiền sản phẩm");
        dm.addColumn("Phí vận chuyển");
        dm.addColumn("Tổng tiền");
        dm.addColumn("Trạng thái đơn hàng");

        //SQL STATEMENT
        String sql = "SELECT * FROM DONHANG WHERE MaKH = '"+customerId+"'";

        try {
        
            Connection con = DriverManager.getConnection(conString, username, password);
            
           

            //PREPARED STMT
            Statement s = con.createStatement();
            ResultSet rs = s.executeQuery(sql);
            
            //LOOP THRU GETTING ALL VALUES
            while (rs.next()) {
                //GET VALUES
                
                String MaDH = rs.getString(1);
                String MaCH = rs.getString(3);
                String ngayDat = rs.getString(4);
                String TongTienSP = rs.getString(5);
                String phiVc = rs.getString(6);
                String TongTien = rs.getString(7);
                String TrangThai = rs.getString(14);

                dm.addRow(new String[]{MaDH, MaCH, ngayDat, TongTienSP,phiVc,TongTien,TrangThai});
            }
            

            return dm;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;

      

    }
    
    public DefaultTableModel SearchSupplies(String Item,String StoreId) {
        //ADD COLUMNS TO TABLE MODEL
        DefaultTableModel dm = new DefaultTableModel();
        dm.addColumn("Mã sản phẩm");
        dm.addColumn("Tên sản phẩm");
        dm.addColumn("Giá gốc");
        dm.addColumn("Phầm trăm giá giảm");
        dm.addColumn("Số lượng tồn kho");
        dm.addColumn("Mã nhà cung cấp");
       
        String sql;
        Item=Item+'%';
        if(StoreId.equals("")){
            sql = "SELECT sp.MaSP,sp.TenSP,sp.GiaGoc,sp.PhanTramGiamGia,spch.SoLuongTon,sp.MaNCC\n" +
            "FROM SANPHAM sp,SP_CH spch\n" +
            "WHERE sp.MaSP = spch.MaSP "
                + " AND( sp.MaSP LIKE '"+Item+"' OR sp.TenSP LIKE N'"+Item+"')";
        }
        else{
            sql = "SELECT sp.MaSP,sp.TenSP,sp.GiaGoc,sp.PhanTramGiamGia,spch.SoLuongTon,sp.MaNCC\n" +
            "FROM SANPHAM sp,SP_CH spch\n" +
            "WHERE sp.MaSP = spch.MaSP "
                + " AND( sp.MaSP LIKE '"+Item+"' OR sp.TenSP LIKE N'"+Item+"') AND spch.MaCH= '"+StoreId+"'";
        }

        //SQL STATEMENT
        

        try {
        
            Connection con = DriverManager.getConnection(conString, username, password);
            
           

            //PREPARED STMT
            Statement s = con.createStatement();
            ResultSet rs = s.executeQuery(sql);
            //PREPARED STMT
            
            
            
            while(rs.next()){
                String MaSp = rs.getString(1);
                String TenSp = rs.getString(2);
                String GiaGoc = rs.getString(3);
                String PhanTram = rs.getString(4);
                String SoLuong = rs.getString(5);
                String MaNCC = rs.getString(6);
                dm.addRow(new String[]{MaSp, TenSp, GiaGoc, PhanTram,SoLuong,MaNCC});
                
            }
            return dm;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;

      

    }
    public int getInventoryQuantityofSupplies(String Supply){
        String sql = "SELECT SoLuongTon FROM SP_CH WHERE SP_CH.MaSP = '"+Supply+"'";
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);

                Statement s = con.createStatement();

                ResultSet rs = s.executeQuery(sql);
                
                rs.next();
                int ans = 0;
                ans = Integer.parseInt(rs.getString(1));
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
    }
   public Boolean insertNewCustomerAccount(String CustomerID,String user,String password){
       String sql = "Insert INTO TAIKHOAN_KH VALUES(?,?,?)";
       
       PreparedStatement statement ;
        
        try {
            //GET COONECTION
        	
        	
        	
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,CustomerID);
            statement.setString(2,user);
            statement.setString(3,password);
            statement.execute();
            


            return true;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
   }
   public Boolean insertNewCustomerInformation(String MaKH,String Ho,String Ten,String gioiTinh, String NgSinh, String sdt,String Email,String SoNha,String Duong,String Phuong,String Quan,String ThanhPho ){
       String sql = "Insert INTO KHACHHANG VALUES(?,?,?,?,?,?,?,?,?,?,?,?)";
       
       PreparedStatement statement ;
        
        try {
            //GET COONECTION
        	
        	
        	
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,MaKH);
            statement.setString(2,Ho);
            statement.setString(3,Ten);
            statement.setString(4,gioiTinh);
            statement.setString(5,NgSinh);
            statement.setString(6,sdt);
            statement.setString(7,Email);
            statement.setString(8,SoNha);
            statement.setString(9,Duong);
            statement.setString(10,Phuong);
            statement.setString(11,Quan);
            statement.setString(12,ThanhPho);
            
            statement.execute();
            


            return true;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
   }
   public Boolean insertNewOrder(String OrderId,String CustomerId,String StoreId,String OrderDay,String SoNha,String Duong,String Phuong, String Quan, String ThanhPho,String HinhThucThanhToan, String TrangThai,String MaNV){
       String sql = "Insert INTO DONHANG(MaDH,MaKH,MaCH,NgayDat,PhiVC,SoNha_GH,Duong_GH,Phuong_GH,Quan_GH,TPho_GH,HinhThucThanhToan,TrangThaiDH,MaNV) VALUES(?,?,?,?,30000,?,?,?,?,?,?,?,?)";
       
       PreparedStatement statement ;
        
        try {
            //GET COONECTION
        	
        	
        	
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,OrderId);
            statement.setString(2,CustomerId);
            statement.setString(3,StoreId);
            statement.setString(4,OrderDay);
            statement.setString(5,SoNha);
            statement.setString(6,Duong);
            statement.setString(7,Phuong);
            statement.setString(8,Quan);
            statement.setString(9,ThanhPho);
            statement.setString(10,HinhThucThanhToan);
            statement.setString(11,TrangThai);
            statement.setString(12,MaNV);
            statement.execute();
            


            return true;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
   }
   public String getSaleManId(String StoreId){
       String sql = "SELECT TOP 1 MaNV FROM NHANVIEN WHERE NHANVIEN.MaCH =?"+
       "ORDER BY NEWID()";
       PreparedStatement statement ;
       try {
            
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,StoreId);
            ResultSet rs = statement.executeQuery();
            rs.next();
            String ans = rs.getString(1);
            return ans;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public Boolean insertNewOrderDetail(String OrderId,String SuppliesId,String Quantily){
       String sql = "Insert INTO CT_DONHANG(MaDH,MaSP,SoLuong) VALUES(?,?,?)";
       
       PreparedStatement statement ;
        
        try {
            //GET COONECTION
        	
        	
        	
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,OrderId);
            statement.setString(2,SuppliesId);
            statement.setString(3,Quantily);
          
            statement.execute();
            


            return true;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
   }
}
   


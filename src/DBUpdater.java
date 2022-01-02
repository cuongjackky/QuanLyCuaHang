/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author 84978
 */
import java.math.BigInteger;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import javax.swing.ComboBoxModel;
import javax.swing.DefaultComboBoxModel;
import java.sql.PreparedStatement;
import javax.naming.spi.DirStateFactory;

import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class DBUpdater {
    String conString = "jdbc:sqlserver://localhost:1433;databaseName=QuanLyCuaHang";
    String username = "sa";
    String password = "1";
    public Boolean checkUniqueUserName(String user){
        /* Hàm này dùng để kiểm tra xem id tài khoản có bị trùng không 
        Trả về True nếu trong cơ sở dữ liệu đã có id 
        Trả về False nếu không có.
        */
         
        String sql = "SELECT * FROM TAIKHOAN_KH WHERE ID = ?";
        PreparedStatement statement ;
        try {
        	// Kết nối database      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,user); // Hàm này dùng để thay thế kí tự ? = String user
                
                //Lưu kết quả, Nếu rs.next() trả về true tức là kết quả khác rỗng.
                ResultSet rs = statement.executeQuery();
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        //Trường hợp lỗi không thể thực hiện câu lệnh
        return false;
        
    }
    public int CountNumberOfCustomer(){
        /*
        Hàm này dùng để đến số lượng khách hàng
        */
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
        /*
        Hàm này dùng để đếm số lượng đơn hàng
        */
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
        /*
        Hàm này kiểm tra xem MaKH có bị trùng không
        */     
        String sql = "SELECT * FROM KHACHHANG WHERE MaKH = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,id);
                
                
                ResultSet rs = statement.executeQuery();
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
        /*
        Hàm này kiểm tra xem MaHD có bị trùng không
        */     
        String sql = "SELECT * FROM DONHANG WHERE MaDH = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,id);
                
                
                ResultSet rs = statement.executeQuery();
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
        /*
        Hàm này kiểm tra xem trong Database có ID và Password nào đúng với Id và Password được nhập không
        */
        String sql = "Select * from TAIKHOAN_KH Where ID = ? AND PassWord = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,user); 
                statement.setString(2, pass);
                
                ResultSet rs = statement.executeQuery();
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
        /*
        Tương tự, dùng cho Nhân viên
        */
        String sql = "Select * from TAIKHOAN_NV Where ID = ? AND PassWord = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,user);
                statement.setString(2, pass);
                
                ResultSet rs = statement.executeQuery();
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
        /*
        Tương tự, dùng cho chủ cửa hàng
        */
        String sql = "Select * from TAIKHOAN_CCH Where ID = ? AND PassWord = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,user);
                statement.setString(2, pass);
                
                ResultSet rs = statement.executeQuery();
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
        /*
        Dùng để lấy MaKH
        */
        String sql = "SELECT  * FROM TAIKHOAN_KH WHERE id = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,user);
                
                ResultSet rs = statement.executeQuery();
                
                rs.next();
                String ans = rs.getString(1);
                
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public String getCustomerFullName(String user){
        /*
        Dùng để lấy họ và tên của khách hàng
        */
        String sql = "SELECT  * FROM KHACHHANG WHERE MaKH = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,user);
                
                ResultSet rs = statement.executeQuery();
                
                rs.next();
                String ans = rs.getString(2).strip()+" "+ rs.getString(3).strip(); 
                
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public String getStoreId(String SuppliesId){
        // Lấy MaCH
        String sql = "SELECT  * FROM SP_CH WHERE MaSP = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,SuppliesId);
                
                ResultSet rs = statement.executeQuery();
                
                rs.next();
                String ans = rs.getString(1);
                
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }
    public DefaultTableModel getOrderHistory(String customerId) {
        // Lấy tất cả DonHang có MaKH trùng với MaKH được đưa vào, trả về 1 bảng
        //ADD COLUMNS TO TABLE MODEL
        DefaultTableModel dm = new DefaultTableModel(); //Tạo bảng
        dm.addColumn("Mã đơn hàng"); //Thêm cột tên "Mã đơn hàng"
        dm.addColumn("Mã cửa hàng");
        dm.addColumn("Ngày đặt");
        dm.addColumn("Tổng tiền sản phẩm");
        dm.addColumn("Phí vận chuyển");
        dm.addColumn("Tổng tiền");
        dm.addColumn("Trạng thái đơn hàng");

        //SQL STATEMENT
        String sql = "SELECT * FROM DONHANG WHERE MaKH = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,customerId);
                
                ResultSet rs = statement.executeQuery();
            
            //LOOP THRU GETTING ALL VALUES
            while (rs.next()) { //Lấy dòng tiếp theo, khi rs.next() = false tức là hết dòng 
                //GET VALUES
                
                String MaDH = rs.getString(1); // lấy cột thứ 1.
                String MaCH = rs.getString(3);
                String ngayDat = rs.getString(4);
                String TongTienSP = rs.getString(5);
                String phiVc = rs.getString(6);
                String TongTien = rs.getString(7);
                String TrangThai = rs.getString(14);

                dm.addRow(new String[]{MaDH, MaCH, ngayDat, TongTienSP,phiVc,TongTien,TrangThai}); //thêm 1 dòng vô bảng
            }
            

            return dm;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;

      

    }
    
    public DefaultTableModel SearchSupplies(String Item,String StoreId) {
        //ADD COLUMNS TO TABLE MODEL
        /*
        Hàm này dùng để tìm kiếm Sản phẩm cùng 1 cửa hàng
        */
        DefaultTableModel dm = new DefaultTableModel();
        dm.addColumn("Mã sản phẩm");
        dm.addColumn("Tên sản phẩm");
        dm.addColumn("Giá gốc");
        dm.addColumn("Phầm trăm giá giảm");
        dm.addColumn("Số lượng tồn kho");
        dm.addColumn("Mã nhà cung cấp");
       
        String sql;
        Item=Item+'%'; // thêm % phía sau MaSP hoặc TenSP để so sánh bằng LIKE
        /*
        Nếu MaCH bằng null, tìm tất cả sản phẩm giống MaSP hoặc TenSP
        Nếu MaCH khác null, tìm tất cả sản phẩm giống MaSP hoặc TenSP cùng cửa hàng với MaCH
        */
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
        /*
        Lấy số lượng tồn của SP
        */
        String sql = "SELECT SoLuongTon FROM SP_CH WHERE SP_CH.MaSP = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,Supply);
                
                ResultSet rs = statement.executeQuery();
                
                rs.next();
                int ans = 0;
                ans = Integer.parseInt(rs.getString(1));
                return ans;
                
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
    }
   public Boolean insertNewCustomerAccount(String CustomerID,String user,String pass){
       /*
       Hàm này dùng để thêm một tài khoản, mật khẩu mới vào bảng TAIKHOAN_KH
       */
       String sql = "Insert INTO TAIKHOAN_KH VALUES(?,?,?)";
       
       PreparedStatement statement ;
        
        try {
            //GET COONECTION
        	
        	
        	
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,CustomerID);
            statement.setString(2,user);
            statement.setString(3,pass);
            statement.execute();
            


            return true;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
   }
   public Boolean insertNewCustomerInformation(String MaKH,String Ho,String Ten,String gioiTinh, String NgSinh, String sdt,String Email,String SoNha,String Duong,String Phuong,String Quan,String ThanhPho ){
       /*
       Hàm này dùng để thêm mới 1 thông tin khách hàng vào bảng KHACHHANG
       */
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
       /*
       Hàm này dùng để thêm mới 1 hoá  đơn
       */
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
       /*
       Hàm này dùng để lấy ngẫu nhiên 1 nhân viên thu ngân của CuaHang cho trước
       */
       String sql = "SELECT TOP 1 MaNV FROM NHANVIEN WHERE NHANVIEN.MaCH = ? AND NHANVIEN.MaLoai= 'LOAINV2'"+
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
   public Boolean insertNewOrderDetail(String OrderId,int stt,String SuppliesId,String Quantily){
       /*
       Hàm này dùng để thêm mới 1 CT_DONHANG
       Phải cài 2 store sp_themChiTietDonHang và sp_capNhatDonHang mới chạy được
       */
       String sql = "Insert INTO CT_DONHANG(MaDH,STT,MaSP,SoLuong) VALUES(?,?,?,?)";// thêm vào CT_DONHANG
       String procdure = "exec sp_themChiTietDonHang ?,?,?"; // Cập nhật GiaBan, ThanhTien,MaNCC
       String procdure2 = "exec sp_capNhatDonHang ?";// Cập nhật DonHang
       
       PreparedStatement statement ;
        
        try {
            //GET COONECTION
        	
        	
        	
            Connection con = DriverManager.getConnection(conString, username, password);
            statement = con.prepareStatement(sql);
            statement.setString(1,OrderId);
            statement.setInt(2,stt);
            statement.setString(3,SuppliesId);
            statement.setString(4,Quantily);
          
            statement.execute();
            statement = con.prepareStatement(procdure);
            statement.setString(1, OrderId);
            statement.setInt(2, stt);
            statement.setString(3, SuppliesId);
            statement.execute();
            statement = con.prepareStatement(procdure2);
            statement.setString(1, OrderId);
            statement.execute();
            return true;

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
   }
   public int getNumberofOrder(){
       /*
       Hàm này dùng để đếm số lượng đơn hàng
       */
       String sql = "Select Count(*) From DONHANG";
       PreparedStatement statement ;
       try {
           Connection con = DriverManager.getConnection(conString, username, password);
           statement = con.prepareStatement(sql);
           ResultSet rs = statement.executeQuery();
           rs.next();
           int ans = Integer.parseInt(rs.getString(1));
           return ans;
       }
        catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
   }
   public ResultSet GetStatisticEmployeeByStore(String storeid, int month, int year){
       DefaultTableModel table = new DefaultTableModel();
       String query="exec sp_ThongKeNhanVienThuNgan ?,?,?";
       PreparedStatement statement;
       try{
           Connection con =  DriverManager.getConnection(conString,username,password);
           statement= con.prepareStatement(query);
           statement.setString(1,storeid );
           statement.setInt(2,month);
           statement.setInt(3, year);
           ResultSet rs=statement.executeQuery();
           
          
           return rs;
       }catch(Exception e){
           e.printStackTrace();
       }
       return null;
   }
   public ResultSet GetSaleStaffIDByStore(String storeid){
       String query="select * FROM NHANVIEN WHERE MACH=? and MALOAI=?";
       PreparedStatement s;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           s=c.prepareStatement(query);
           s.setString(1, storeid);
           s.setString(2, "LOAINV2");
           ResultSet r = s.executeQuery();
           return r;
           
       }catch(Exception e){
           e.printStackTrace();
       }
       return null;
   }
   public ResultSet GetSalaryInfoByStaff(String staffID, int thang, int nam){
       String query="exec sp_GetSalaryInfoByStaffID ?, ?, ?";
       PreparedStatement statement;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           statement=c.prepareStatement(query);
           statement.setString(1, staffID);
           statement.setInt(2, thang);
           statement.setInt(3, nam);
           ResultSet rs = statement.executeQuery();
           return rs;
       }catch(Exception e){
               e.printStackTrace();
       }
       return null;
   }
   public ResultSet GetInfoStaff (String staffid){
       String query="select * from NHANVIEN where MANV = ?";
       PreparedStatement statement;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           statement=c.prepareStatement(query);
           statement.setString(1, staffid);
           ResultSet rs = statement.executeQuery();
           return rs;
       }catch(Exception e){
               e.printStackTrace();
       }
       return null;
   }
   public int UpdateSalaryInfo (String staffid, int songaynghi, int luongcd, int thang, int nam){
       String query = "exec sp_UpdateSalaryInfo ?,?,?,?,?";
       PreparedStatement statement;
               
       try{
           Connection con = DriverManager.getConnection(conString, username, password);
           statement=con.prepareStatement(query);
           statement.setString(1, staffid);
           statement.setInt(2, thang);
           statement.setInt(3, nam);
           statement.setInt(4, songaynghi);
           statement.setInt(5, luongcd);
           int n = statement.executeUpdate();
           return n;
           
       }catch(Exception e){
           e.printStackTrace();
       }
       return 0;
            
   }
   public int AddNewQuotaSale (String mach, int month, int year, int quota){
       String query = "exec dbo.sp_AddNewQuotaSale ?,?,?,?";
       PreparedStatement st;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           st=c.prepareStatement(query);
           st.setInt(1, month);
           st.setInt(2, year);
           st.setInt(3, quota);
           st.setString(4, mach);
           int n = st.executeUpdate();
           return n;
       }catch(Exception e){
           e.printStackTrace();
       }
       return 0;
   }
   public ResultSet GetCategory(){
       String query="select * from LOAINHANVIEN";
       Statement statement;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           statement=c.createStatement();
           ResultSet rs = statement.executeQuery(query);
           return rs;
       }catch(Exception e){
               e.printStackTrace();
       }
       return null;
   }
   public ResultSet GetListInfoStaff(String storeid){
       String query="select * from NHANVIEN where MACH = ?";
       PreparedStatement statement;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           statement=c.prepareStatement(query);
           statement.setString(1, storeid);
           ResultSet rs = statement.executeQuery();
           return rs;
       }catch(Exception e){
               e.printStackTrace();
       }
       return null;
   }
   public int CountNumberOfStaff(){
        /*
        Hàm này dùng để đến số lượng khách hàng
        */
        String sql = "SELECT COUNT(*) FROM NHANVIEN";
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
   public Boolean checkUniqueStaffID(String id){
       
        String sql = "SELECT * FROM NHANVIEN WHERE MaNV = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,id);
                
                
                ResultSet rs = statement.executeQuery();
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
        
    }
   public int InsertNewStaff(String mach, String manv , String ho, String ten , String gioitinh ,
                        String date, String sdt, String email, String maloai){
       String query = "exec sp_InsertNewStaff ?,?,?,?,?,?,?,?,?";
       PreparedStatement statement;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           statement=c.prepareStatement(query);
           statement.setString(1, mach);
           statement.setString(2, manv);
           statement.setString(3, ho);
           statement.setString(4, ten); 
           statement.setString(5, gioitinh);
           statement.setString(6, date);
           statement.setString(7, sdt);
           statement.setString(8, email);
           statement.setString(9, maloai);

           int rs = statement.executeUpdate();
           return rs;
       }catch(Exception e){
               e.printStackTrace();
       }
       return -1;
   }
   public int UpdateInfoStaff(String manv , String ho, String ten , String gioitinh ,
                        String date, String sdt, String email, String maloai){
       String query = "exec sp_UpdateInfoStaff ?,?,?,?,?,?,?,?";
       PreparedStatement statement;
       try{
           Connection c = DriverManager.getConnection(conString,username,password);
           statement=c.prepareStatement(query);
           statement.setString(1, manv);
           statement.setString(2, ho);
           statement.setString(3, ten); 
           statement.setString(4, gioitinh);
           statement.setString(5, date);
           statement.setString(6, sdt);
           statement.setString(7, email);
           statement.setString(8, maloai);

           int rs = statement.executeUpdate();
           return rs;
       }catch(Exception e){
               e.printStackTrace();
       }
       return -1;
   }
   public int DeleteStaff(String manv){
       String query= "Delete from NHANVIEN where MANV= ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,manv);
                int result = statement.executeUpdate();
          
               return result;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
   }
   public int UpdateQuotaSale(String mach, int month, int year, int quota){
       String query = "exec sp_UpdateQuotaSale ?,?,?,?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,mach);
                statement.setInt(2,month);
                statement.setInt(3,year);
                statement.setInt(4,quota);
                int result = statement.executeUpdate();
          
               return result;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
   }
   public ResultSet GetDetailInfoStaff(String id){
       String query = "SELECT*FROM dbo.TAIKHOAN_NV, dbo.NHANVIEN WHERE NHANVIEN.MaNV=? AND NHANVIEN.MaNV=TAIKHOAN_NV.MaNV";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,id);
               
                ResultSet rs = statement.executeQuery();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public int UpdatePassStaff (String manv, String pass){
       String query = "exec sp_UpdatePassStaff ?,?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,manv);
               statement.setString(2, pass);
                int rs = statement.executeUpdate();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
   }
   public ResultSet GetOrderListByStaffID(String staffid){
       String query = "select*from DONHANG where manv=?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,staffid);
               
                ResultSet rs = statement.executeQuery();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetOrderListByStaffID_MY(String staffid, int thang, int nam){
       String query = "exec sp_GetOrderListByID_MY ?,?,?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,staffid);
               statement.setInt(2, thang);
               statement.setInt(3, nam);
                ResultSet rs = statement.executeQuery();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetOrderListByStaffID_MY_Status(String staffid, int thang, int nam, String trangthai){
       String query = "sp_GetOrderListByID_MY_Status ?,?,?,?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,staffid);
               statement.setInt(2, thang);
               statement.setInt(3, nam);
               statement.setString(4,trangthai);
                ResultSet rs = statement.executeQuery();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetDetailOrder(String madh){
       String query = " sp_GetDetailOrder ?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,madh);
               
                ResultSet rs = statement.executeQuery();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetCusInfoForDetailOrder(String makh){
       String query = " select*from khachhang where makh= ?";
       PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,makh);
               
                ResultSet rs = statement.executeQuery();
          
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public String GetStoreIDByStaff(String staffid)
   {
       String query="Select MACH FROM NHANVIEN WHERE MANV= ?";
       PreparedStatement statement;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,staffid);
               
                ResultSet rs = statement.executeQuery();
                rs.next();
                String mach = rs.getString(1);
               return mach;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
   }
   public ResultSet GetListProductByStore(String storeid){
       var query = "SELECT sp.*, ch.SoLuongTon FROM dbo.SP_CH ch, dbo.SANPHAM sp WHERE ch.MaSP=sp.MaSP AND ch.MaCH=?";
       PreparedStatement statement;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,storeid);
               
                ResultSet rs = statement.executeQuery();
               
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetListProductByStore_OOS(String storeid){
       var query = "SELECT sp.*, ch.SoLuongTon FROM dbo.SP_CH ch, dbo.SANPHAM sp WHERE ch.MaSP=sp.MaSP AND ch.MaCH=? AND ch.SoLuongTon <=50";
       PreparedStatement statement;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,storeid);
               
                ResultSet rs = statement.executeQuery();
               
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public String GetWareHouseIDByStore(String mach){
       String query="Select MAKHO FROM KHO WHERE MACH= ?";
       PreparedStatement statement;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,mach);
               
                ResultSet rs = statement.executeQuery();
                rs.next();
                String makho = rs.getString(1);
               return makho;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return "";
   }
   public int CountNumberOfImportWH(){
        /*
        Hàm này dùng để đến số lượng khách hàng
        */
        String sql = "SELECT COUNT(*) FROM DONNHAP";
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
   public Boolean checkUniqueImportWHID(String id){
       
        String sql = "SELECT * FROM DONNHAP WHERE MADN = ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(sql);
                statement.setString(1,id);
                
                
                ResultSet rs = statement.executeQuery();
                if(rs.next()){
                    return true;
                }
                return false;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
        
    }
   public ResultSet GetListAllProductID(){
       var query = "SELECT MASP FROM SANPHAM";
       Statement statement;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.createStatement();
                ResultSet rs = statement.executeQuery(query);
               
               return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetInfoProdForImportForm(String masp){
       String query = "exec sp_GetInfoProductForImportForm ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,masp);
                
                
                ResultSet rs = statement.executeQuery();
                return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public int InsertNewImportForm(String madh, String date, String makho, String manv){
       String query="INSERT INTO DONNHAP VALUES (?,?,?,?)";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,madh);
                statement.setString(2, date);
                statement.setString(3, makho);
                statement.setString(4, manv);
                
                int rs = statement.executeUpdate();
                return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
   }
   public int InsertNewDetailImport(String madh, String masp, int sl, String mach){
       String query="sp_InsertDetailImportForm ?,?,?,?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,madh);
                statement.setString(2, masp);
                statement.setInt(3, sl);
               statement.setString(4,mach);
                
                int rs = statement.executeUpdate();
                return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return -1;
   }
   public ResultSet GetAllListImportByStaff(String staffid){
       String query = "SELECT*FROM DONNHAP WHERE MANV= ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,staffid);
                
                
                ResultSet rs = statement.executeQuery();
                return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetAllListImportByStaff_MY(String staffid, int thang, int nam){
       String query = "SELECT*FROM DONNHAP WHERE MANV= ? and YEAR(NGAYNHAP)= ? AND MONTH(NGAYNHAP)=?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,staffid);
                statement.setInt(2, nam);
                statement.setInt(3, thang);
                ResultSet rs = statement.executeQuery();
                return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   public ResultSet GetInfoDI(String madn){
       String query = "SELECT*FROM CT_DONNHAP WHERE MADN= ?";
        PreparedStatement statement ;
        try {
        	      	
        	Connection con=DriverManager.getConnection(conString, username, password);
                statement = con.prepareStatement(query);
                statement.setString(1,madn);
                
                ResultSet rs = statement.executeQuery();
                return rs;
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
   }
   
}
   


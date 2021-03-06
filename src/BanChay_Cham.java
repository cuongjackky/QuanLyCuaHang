
import java.sql.ResultSet;
import javax.swing.table.DefaultTableModel;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JPanel.java to edit this template
 */

/**
 *
 * @author 84978
 */
public class BanChay_Cham extends javax.swing.JPanel {
    private static String MaCH ="";
    private static String Thang ="";
    private static String Nam = "";
    /**
     * Creates new form BanChay_Cham
     */
    public BanChay_Cham(String mach,String thang, String nam) {
        initComponents();
        this.MaCH =mach;
        this.Thang =thang;
        this.Nam=nam;
        LayBangBanChay();
    }
    public void LayBangBanChay(){
        DefaultTableModel dm = new  DefaultTableModel();
        dm.addColumn("Mã sản phẩm"); 
        dm.addColumn("Tên sản phẩm");
        dm.addColumn("Số lượng bán được");
        
        
        try{
            ResultSet rs = new DBUpdater().LayThongKeSanPhamBanChay(MaCH,Thang,Nam);
            while (rs.next()){
                String MaSP = rs.getString(1); // lấy cột thứ 1.
                String TenSP = rs.getString(2);
                String SoLuong = rs.getString(3);
                
                
                dm.addRow(new String[]{MaSP, TenSP, SoLuong});
            }
            jTable1.setModel(dm);
            
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();

        setBackground(new java.awt.Color(31, 34, 46));

        jTable1.setFont(new java.awt.Font("Tahoma", 1, 24)); // NOI18N
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null},
                {null, null, null},
                {null, null, null}
            },
            new String [] {
                "Mã sản phẩm", "Tên sản phẩm", "Số lượng đã bán"
            }
        ));
        jTable1.setRowHeight(40);
        jScrollPane1.setViewportView(jTable1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 822, Short.MAX_VALUE)
                .addGap(18, 18, 18))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(23, Short.MAX_VALUE)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 184, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JTable jTable1;
    // End of variables declaration//GEN-END:variables
}

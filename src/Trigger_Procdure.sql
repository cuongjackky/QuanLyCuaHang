/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  84978
 * Created: Dec 18, 2021
 */

Create trigger trg_datHang ON CT_DONHANG AFTER INSERT AS
BEGIN
	UPDATE SP_CH SET
	SP_CH.SoLuongTon = SP_CH.SoLuongTon -(
	SELECT inserted.SoLuong
	FROM inserted
	WHERE inserted.MaSP =SP_CH.MaSP)
	FROM SP_CH
	JOIN inserted ON SP_CH.MaSP = inserted.MaSP


END
GO
Create --ALTER 
proc [dbo].[sp_capNhatDonHang]
(
	@MaDH char(20)
	
)
AS
BEGIN
	
	DECLARE @TongTienSP bigint SET @TongTienSP = (Select SUM(CT_DONHANG.ThanhTien) FROM CT_DONHANG WHERE MaDH = @MaDH)
	DECLARE @TongTien bigint Set @TongTien = @TongTien+ 30000
	

	Update DONHANG
	SET
		TongTienSP = @TongTienSP, TongTien =@TongTien
		WHERE @MaDH =MaDH 
END
GO
Create --ALTER
proc [dbo].[sp_donHang]
AS
BEGIN
	DECLARE @MaDH char(20)
	
	DECLARE @Tongtien bigint
	

	DECLARE c CURSOR
	FOR
	select DONHANG.MaDH, SUM(CT_DONHANG.ThanhTien)
	FROM DONHANG,CT_DONHANG
	WHERE CT_DONHANG.MaDH = DONHANG.MADH
	GROUP BY DONHANG.MADH
	OPEN c
	FETCH NEXT FROM c INTO
	@MaDH,
	@TongTien
	While @@FETCH_STATUS =0
	BEGIN
		Update DONHANG SET
		DONHANG.TongTienSP= @TongTien , DONHANG.TongTien = @TongTien+ DONHANG.PhiVC
		WHERE DONHANG.MaDH = @MaDH

		Fetch next from c into
		@MaDH,
		@TongTien
	END
	close c
	deallocate c

END
GO
Create--ALTER 
proc [dbo].[sp_thanhTien]
AS
BEGIN
	DECLARE @MaDH char(20)
	DECLARE @MaSP char(20)
	DECLARE @STT smallint
	DECLARE @GiaBan int
	DECLARE @SoLuong int
	DECLARE @NCC varchar(20)

	DECLARE d CURSOR
	FOR
	SELECT MADH,MASP,STT,GiaBan,SoLuong
	FROM CT_DONHANG
	OPEN d
	FETCH NEXT FROM d INTO
	@MaDH,
	@MaSP,
	@STT,
	@GiaBan,
	@SoLuong
	While @@FETCH_STATUS =0
	BEGIN
		SET @NCC = (Select MaNCC FROM SANPHAM WHERE MaSP= @MaSP)
		UPDATE CT_DONHANG
		SET CT_DONHANG.ThanhTien = @GiaBan*@SoLuong,MaNCC = @NCC
		WHERE CT_DONHANG.MASP = @MaSP AND CT_DONHANG.MaDH= @MaDH AND CT_DONHANG.STT =@STT
		Fetch next from d into
		@MaDH,
		@MaSP,
		@STT,
		@GiaBan,
		@SoLuong
	END
	close d
	deallocate d

END
GO
Create --ALTER 
proc [dbo].[sp_thanhTienSP] 
AS
BEGIN
	DECLARE @MaSP char(20)
	DECLARE @cost int
	DECLARE @percentDiscount int

	DECLARE c CURSOR
	FOR
	SELECT MASP, GiaGoc, PhanTramGiamGia
	FROM SANPHAM
	OPEN c
	FETCH NEXT FROM c INTO
	@MaSP,
	@cost,
	@percentDiscount
	While @@FETCH_STATUS =0
	BEGIN
		UPDATE CT_DONHANG
		SET CT_DONHANG.GiaBan = @cost*(100-@percentDiscount)/100
		WHERE CT_DONHANG.MASP = @MaSP
		Fetch next from c into
			@MaSP,
			@cost,
			@percentDiscount
	END
	close c
	deallocate c

END
GO
Create --ALTER 
proc [dbo].[sp_themChiTietDonHang]
(
	@MaDH char(20),
	@stt int,
	@MaSP char(20)
)
AS
BEGIN
	
	DECLARE @Gia bigint SET @Gia = (Select GiaGoc FROM SANPHAM WHERE MaSP = @MaSP)
	DECLARE @PhanTramGiam int Set @PhanTramGiam = (Select PhanTramGiamGia FROM SANPHAM WHERE MaSP =@MaSP)
	DECLARE @SoLuong int Set @SoLuong = (Select SoLuong From CT_DONHANG WHERE @MaDH = MaDH AND @MASP =MaSP AND STT= @stt)
	DECLARE @NCC varchar(20) SET @NCC = (SELECT MaNCC FROM SANPHAM WHERE @MaSP = MaSP)

	Update CT_DONHANG
	SET
		GiaBan = @Gia*(100-@PhanTramGiam)/100, ThanhTien = @Gia*(100-@PhanTramGiam)/100*@SoLuong, MaNCC=@NCC
		WHERE @MaDH =MaDH AND @MaSP =MaSP AND STT= @stt
END
GO
Create--ALTER 
proc [dbo].[TaoCT_DONHANG] 
AS
BEGIN

   -- Lấy từng đơn hàng một
	DECLARE @MaDH char(20)
	DECLARE @MaCH varchar(20)

	DECLARE c CURSOR
	FOR
	SELECT MaDH,MaCH
	FROM DONHANG
	OPEN c
	FETCH NEXT FROM c INTO
	@MaDH,
	@MaCH
	While @@FETCH_STATUS =0
	BEGIN

		-- Lấy ngẫu nhiên 1 số từ 1-5
		Declare @SoDonHang smallint SET @SoDonHang = CAST(RAND()*10+1 AS smallint)
		if @SoDonHang > 5 SET @SoDonHang = @SoDonHang /2
		-- lấy ngẫu nhiên 1 mã cửa hàng
		
		DECLARE @MaSP varchar(20)
		DECLARE @SoLuong smallint
		DECLARE @i int SET @i =0
		WHILE @i < @SoDonHang  -- Them cac Chi tiet don hang
			BEGIN
				SET @MaSP = (Select top 1 MaSP FROM SP_CH WHERE MaCH =@MaCH  -- Lay ngau nhien 1 san pham
							ORDER by NewID())
				SET @SoLuong = CAST(RAND()*200+10 AS smallint)
				insert into CT_DONHANG(MaDH,STT,MaSP,SoLuong) Values (@MaDH,@i+1,@MaSP,@SoLuong)-- co them them @i = STT

				SET @i =@i+1
			END
		Fetch next from c into
			@MaDH,
			@MaCH
	END
	close c
	deallocate c
END
GO
Create --ALTER 
proc [dbo].[themsanpham] 
AS
BEGIN

   -- Lấy từng đơn hàng một
	DECLARE @MaCH char(20)
	DECLARE @MaSP char(20)
	DECLARE @SoLuongTon int
	

	DECLARE c CURSOR
	FOR
	SELECT MaCH,MaSP,SoLuongTon
	FROM SP_CH
	OPEN c
	FETCH NEXT FROM c INTO
	@MaCH,
	@MaSP,
	@SoLuongTon
	While @@FETCH_STATUS =0
	BEGIN
		if @SoLuongTon <=0
			Set @SoLuongTon = -@SoLuongTon +1000
			Update SP_CH SET SoLuongTon =@SoLuongTon WHERE MaCH=@MaCH AND MaSP = @MaSP
		
		Fetch next from c into
			@MaCH,
			@MaSP,
			@SoLuongTon
	END
	close c
	deallocate c
END

------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER TINHDOANHSO_SODONHANG ON dbo.DONHANG AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @doanhso BIGINT
    DECLARE @sodonhang SMALLINT
	SELECT @doanhso = SUM(dh.TongTien), @sodonhang = COUNT(*)
	FROM Inserted i, dbo.DONHANG dh
	WHERE i.MaNV = dh.MaNV AND MONTH(i.NgayDat) = MONTH(dh.NgayDat) AND YEAR(i.NgayDat) = YEAR(dh.NgayDat)
	GROUP BY i.MaNV

	--update bang ct_nhanvien
	--neu ton tai thong tin nhan vien trong bang thong ke
	IF EXISTS(SELECT*FROM dbo.ct_nhanvien ct, Inserted i WHERE ct.MaNV=i.MaNV AND  
				MONTH(i.NgayDat) = ct.Thang_NV AND YEAR(i.NgayDat) = ct.Nam_NV)
	BEGIN --update
		UPDATE dbo.ct_nhanvien
		SET DoanhSo=@doanhso, SoDonHang = @sodonhang
		FROM Inserted i
		WHERE i.manv = ct_nhanvien.MaNV AND MONTH(i.NgayDat) = dbo.ct_nhanvien.Thang_NV AND YEAR(i.NgayDat) = dbo.ct_nhanvien.Nam_NV
    END
	
END
GO


CREATE OR ALTER TRIGGER TinhLuongThuong ON CT_NHANVIEN AFTER INSERT, UPDATE
AS 
BEGIN

	
	DECLARE @DOANHSO BIGINT
	DECLARE @QUOTA  INT
	SELECT @DOANHSO = CT_NHANVIEN.DoanhSo, @QUOTA = dbo.CT_NHANVIEN.QuotaSale
					FROM Inserted I, dbo.CT_NHANVIEN
					WHERE I.MaNV=dbo.CT_NHANVIEN.MANV AND I.Nam_NV=dbo.CT_NHANVIEN.Nam_NV AND I.Thang_NV=dbo.CT_NHANVIEN.Thang_NV

	


	IF (@QUOTA < @DOANHSO)
	begin
		UPDATE dbo.CT_NHANVIEN
		SET LuongThuong = (@DOANHSO - @QUOTA)*0.3
		FROM inserted i
		WHERE i.manv = dbo.CT_NHANVIEN.MaNV AND i.thang_nv=dbo.CT_NHANVIEN.Thang_NV AND i.nam_nv=dbo.CT_NHANVIEN.Nam_NV
	end
	ELSE
    begin
		UPDATE dbo.CT_NHANVIEN
		SET LuongThuong=0
		FROM inserted i
		WHERE i.manv = dbo.CT_NHANVIEN.MaNV AND i.thang_nv=dbo.CT_NHANVIEN.Thang_NV AND i.nam_nv=dbo.CT_NHANVIEN.Nam_NV
	end
	UPDATE dbo.CT_NHANVIEN
	SET HieuSuat = (dbo.CT_NHANVIEN.DoanhSo*1.0/dbo.CT_NHANVIEN.QuotaSale) * 100, 
		dbo.ct_nhanvien.TienBiTru=dbo.ct_nhanvien.SoNgayNghi*100000
		
	FROM Inserted i
	WHERE i.MaNV = dbo.CT_NHANVIEN.MaNV AND i.Nam_NV = dbo.CT_NHANVIEN.Nam_NV AND i.Thang_NV = dbo.CT_NHANVIEN.Thang_NV

	UPDATE dbo.ct_nhanvien
	SET dbo.ct_nhanvien.Luong=dbo.ct_nhanvien.LuongCD+dbo.ct_nhanvien.LuongThuong-dbo.ct_nhanvien.TienBiTru
	FROM Inserted i
	WHERE i.MaNV = dbo.CT_NHANVIEN.MaNV AND i.Nam_NV = dbo.CT_NHANVIEN.Nam_NV AND i.Thang_NV = dbo.CT_NHANVIEN.Thang_NV--update so don hang, doanh so


END
GO

--CREATE OR ALTER TRIGGER TinhHieuSuat ON dbo.CT_NHANVIEN AFTER INSERT, UPDATE
--AS

--	UPDATE dbo.CT_NHANVIEN
--	SET HieuSuat = dbo.CT_NHANVIEN.DoanhSo/dbo.CT_NHANVIEN.QuotaSale*1.0 * 100
--	FROM Inserted i
--	WHERE i.MaNV = dbo.CT_NHANVIEN.MaNV AND i.Nam_NV = dbo.CT_NHANVIEN.Nam_NV AND i.Thang_NV = dbo.CT_NHANVIEN.Thang_NV
--GO

--CREATE OR ALTER PROC tinhsodonhang_doanhso @manv VARCHAR(20), @thang INT, @nam int
--AS
--BEGIN
--	INSERT INTO dbo.ct_nhanvien
--	(
--	    MaNV,
--	    Thang_NV,
--	    Nam_NV,
--	    QuotaSale,
--	    SoDonHang,
--	    DoanhSo,
--	    SoNgayNghi,
--	    LuongCD,
--	    TienBiTru,
--	    LuongThuong,
--	    Luong,
--	    HieuSuat
--	)
--	VALUES
--	(   @manv, -- MaNV - varchar(20)
--	    @thang,  -- Thang_NV - int
--	    @nam,  -- Nam_NV - int
--	    100000000,  -- QuotaSale - bigint
--	    0,  -- SoDonHang - smallint
--	    0,  -- DoanhSo - bigint
--	    2,  -- SoNgayNghi - tinyint
--	    20000000,  -- LuongCD - int
--	    0,  -- TienBiTru - int
--	    0,  -- LuongThuong - int
--	    0,  -- Luong - int
--	    0.0 -- HieuSuat - float
--	    )

--	DECLARE @sodonhang SMALLINT 
--	DECLARE @ds BIGINT 
--	SELECT @ds = SUM(dh.TongTien), @sodonhang=COUNT(*)
--	FROM dbo.DONHANG dh, dbo.CT_NHANVIEN ct
--	WHERE dh.MaNV=ct.MaNV AND ct.Nam_NV= @nam AND ct.Thang_NV= @thang AND MONTH(dh.NgayDat) = @thang AND YEAR(dh.NgayDat) = @nam
--	AND dh.TrangThaiDH=N'Đã giao' AND ct.MaNV=@manv
--	GROUP BY dh.MaNV
	
--	UPDATE dbo.ct_nhanvien
--	SET DoanhSo = @ds, SoDonHang = @sodonhang
--	WHERE MaNV=@manv AND Thang_NV = @thang AND Nam_NV=@nam

--	RETURN
--END
--GO


--CREATE PROC updatedoanhso @manv VARCHAR(20)
--AS
--BEGIN
--	DECLARE @ds BIGINT 
--	SET @ds = (SELECT SUM(dh.TongTien)
--	FROM dbo.DONHANG dh, dbo.CT_NHANVIEN ct
--	WHERE dh.MaNV=ct.MaNV AND ct.Nam_NV='2009' AND ct.Thang_NV='6' AND ct.Thang_NV=MONTH(dh.NgayDat) AND ct.Nam_NV=YEAR(dh.NgayDat)
--	AND dh.TrangThaiDH=N'Đã giao' AND ct.MaNV=@manv
--	GROUP BY dh.MaNV)
--	UPDATE dbo.ct_nhanvien
--	SET DoanhSo = @ds
--	WHERE MaNV=@manv
--END 
--GO




--thống kê danh sách nhân viên theo mã cửa hàng, tháng, năm
CREATE OR ALTER PROC sp_ThongKeNhanVienThuNgan @mach VARCHAR(20), @thang INT, @nam INT
AS
BEGIN
	SELECT ct.Thang_NV, ct.Nam_NV, ct.MaNV, ct.SoDonHang, ct.DoanhSo,ct.QuotaSale,ct.HieuSuat
    FROM dbo.NHANVIEN nv, dbo.ct_nhanvien ct
	WHERE nv.MaNV=ct.MaNV AND ct.Thang_NV = @thang AND ct.Nam_NV=@nam AND nv.MaCH=@mach 
END
go


CREATE PROC sp_GetSalaryInfoByStaffID @manv varchar(20), @thang int, @nam int
AS
BEGIN
	SELECT ct.Thang_NV, ct.Nam_NV, ct.MaNV,ct.LuongCD, ct.LuongThuong,ct.SoNgayNghi, ct.TienBiTru, ct.Luong
	FROM dbo.ct_nhanvien ct
	WHERE ct.MaNV=@manv AND ct.Nam_NV=@nam AND ct.Thang_NV=@thang
END
GO


CREATE OR ALTER PROC sp_AddNewQuotaSale @thang int, @nam int, @quota bigint, @mach varchar(20)
AS
BEGIN
	IF EXISTS(SELECT*FROM dbo.ct_nhanvien WHERE Thang_NV=@thang AND Nam_NV=@nam)
	BEGIN 
		RAISERROR('Thong tin da ton tai',15,1)
		ROLLBACK
		RETURN
	END
	ELSE
	BEGIN
		DECLARE @preMonth INT
		DECLARE @preYear INT
		IF (@thang = 1)
		BEGIN
			SET @preMonth = 12
			SET @preYear = @nam - 1
        END
		ELSE
		BEGIN
			SET @preMonth = @thang - 1
			SET @preYear = @nam
		
		END

		DECLARE @manv VARCHAR(20)
		DECLARE @luongcd int
		DECLARE c CURSOR FOR SELECT manv FROM dbo.NHANVIEN WHERE mach = @mach AND MaLoai='LOAINV2'
		OPEN c
		FETCH NEXT FROM c INTO @manv
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			SELECT @luongcd= LuongCD FROM dbo.ct_nhanvien WHERE MaNV=@manv AND Nam_NV=@preYear AND Thang_NV=@preMonth
			IF EXISTS(SELECT*FROM dbo.ct_nhanvien WHERE Thang_NV=@thang AND Nam_NV=@nam AND manv =@manv)
			BEGIN 
				--RAISERROR('Thong tin da ton tai',15,1)
				FETCH NEXT FROM c INTO @manv
			END
			ELSE
			BEGIN
				INSERT INTO dbo.ct_nhanvien
			(
			    MaNV,
			    Thang_NV,
			    Nam_NV,
			    QuotaSale,
			    SoDonHang,
			    DoanhSo,
			    SoNgayNghi,
			    LuongCD,
			    TienBiTru,
			    LuongThuong,
			    Luong,
			    HieuSuat
			)
			VALUES
			(   @manv, -- MaNV - varchar(20)
			    @thang,  -- Thang_NV - int
			    @nam,  -- Nam_NV - int
			    @quota,  -- QuotaSale - bigint
			    0,  -- SoDonHang - smallint
			    0,  -- DoanhSo - bigint
			    0,  -- SoNgayNghi - tinyint
			    @luongcd,  -- LuongCD - int
			    0,  -- TienBiTru - int
			    0,  -- LuongThuong - int
			    0,  -- Luong - int
			    0.0 -- HieuSuat - float
			    )
			END
			FETCH NEXT FROM c INTO @manv
			--SELECT @luongcd = LuongCD FROM dbo.ct_nhanvien WHERE Thang_NV = @preMonth AND Nam_NV = @preYear AND MaNV = @manv
			
		END
		CLOSE c
		DEALLOCATE c
    END
END

--insert new staff
CREATE OR ALTER PROC sp_InsertNewStaff @mach VARCHAR(20), @manv VARCHAR(20), @ho NVARCHAR(20), @ten NVARCHAR(20),
						@gioitinh NVARCHAR(3), @ngaysinh DATETIME, @sdt VARCHAR(10), @email VARCHAR(30),@maloai VARCHAR(20)
AS 
BEGIN
	INSERT INTO dbo.NHANVIEN
	(
	    MaNV,
	    HoNV,
	    TenNV,
	    GioiTinh_NV,
	    NgaySinh_NV,
	    SDT_NV,
	    Email_NV,
	    MaCH,
	    MaLoai
	)
	VALUES
	(   @manv,        -- MaNV - varchar(20)
	    @ho,       -- HoNV - nvarchar(20)
	    @ten,       -- TenNV - nvarchar(20)
	    @gioitinh,       -- GioiTinh_NV - nvarchar(3)
	    @ngaysinh, -- NgaySinh_NV - datetime
	    @sdt,        -- SDT_NV - varchar(10)
		@email,        -- Email_NV - varchar(40)
	    @mach,        -- MaCH - varchar(20)
	    @maloai         -- MaLoai - varchar(20)
	    )
END
go
CREATE PROC sp_UpdateInfoStaff @manv VARCHAR(20), @ho NVARCHAR(20), @ten NVARCHAR(20),
						@gioitinh NVARCHAR(3), @ngaysinh DATETIME, @sdt VARCHAR(10), @email VARCHAR(30),@maloai VARCHAR(20)
AS
BEGIN
	IF NOT EXISTS (SELECT*FROM dbo.NHANVIEN WHERE MaNV=@manv)
	BEGIN
		RAISERROR('Không tồn tại nhân viên',15,1)
		RETURN
    END
	ELSE
	BEGIN
		UPDATE dbo.NHANVIEN
		SET HoNV=@HO, TenNV=@TEN, GioiTinh_NV=@gioitinh, Email_NV=@email, NgaySinh_NV=@ngaysinh,
			SDT_NV=@SDT, MaLoai=@maloai
		WHERE MaNV=@MANV
	END
END
GO

CREATE OR ALTER PROC sp_UpdateQuotaSale @mach VARCHAR(20),@thang INT, @nam INT, @quota INT
AS
BEGIN
	DECLARE @manv VARCHAR(20)
	DECLARE c CURSOR FOR SELECT ct.manv FROM dbo.ct_nhanvien ct, dbo.NHANVIEN nv	
							WHERE ct.MaNV=nv.MaNV AND nv.MaCH=@mach AND nv.MaLoai='LOAINV2' AND ct.Thang_NV=@thang AND ct.Nam_NV=@nam
	OPEN c
	FETCH NEXT FROM c INTO @manv
	WHILE @@FETCH_STATUS = 0 
	BEGIN
		UPDATE dbo.ct_nhanvien
		SET QuotaSale=@quota
		WHERE MaNV=@manv AND Thang_NV=@thang AND Nam_NV=@nam
		FETCH NEXT FROM c INTO @manv
    END
	CLOSE c
	DEALLOCATE c
END
GO
EXEC dbo.sp_UpdateQuotaSale @mach = 'CH85650', -- varchar(20)
                            @thang = 3, -- int
                            @nam = 2022,   -- int
                            @quota = 20  -- int
CREATE PROC sp_UpdateSalaryInfo @manv varchar(20), @thang int, @nam int, @songaynghi tinyint, @luongcd int
AS
BEGIN
	UPDATE dbo.ct_nhanvien
	SET SoNgayNghi= @songaynghi, LuongCD=@luongcd
	WHERE manv = @manv AND Thang_NV=@thang AND Nam_NV=@nam
END

CREATE PROC sp_UpdatePassStaff @manv varchar(20), @newpass varchar(20)
AS
BEGIN
	UPDATE dbo.TAIKHOAN_NV
	SET PassWord = @newpass
	WHERE MaNV=@manv
END
GO

CREATE PROC sp_GetOrderListByID_MY @manv VARCHAR(20), @thang INT, @nam INT
AS
BEGIN
	SELECT*FROM dbo.DONHANG WHERE MaNV=@manv AND YEAR(NgayDat)=@nam AND MONTH(NgayDat)=@thang
END

CREATE PROC sp_GetOrderListByID_MY_Status @manv VARCHAR(20), @thang INT, @nam INT, @trangthai NVARCHAR(20)
AS
BEGIN
	SELECT*FROM dbo.DONHANG WHERE MaNV=@manv AND YEAR(NgayDat)=@nam AND MONTH(NgayDat)=@thang AND TrangThaiDH=@trangthai
END
GO

CREATE PROC sp_GetDetailOrder @madh VARCHAR(20)
AS
BEGIN
	SELECT ct.MaDH, ct.STT, ct.MaSP, sp.TenSP, ct.GiaBan, ct.SoLuong, ct.ThanhTien, ct.MaNCC, ncc.TenNCC
	FROM dbo.CT_DONHANG ct, dbo.SANPHAM sp, dbo.NHACUNGCAP ncc
	WHERE ct.MaDH=@madh AND ct.MaSP=sp.MaSP AND sp.MaNCC = ncc.MaNCC
END
GO

CREATE PROC sp_GetInfoProductForImportForm @masp VARCHAR(20)
AS
BEGIN
	SELECT sp.TenSP, sp.MaNCC, ncc.TenNCC
	FROM dbo.SANPHAM sp, dbo.NHACUNGCAP ncc
	WHERE sp.MaSP=@masp AND sp.MaNCC=ncc.MaNCC

END
GO

 CREATE OR ALTER PROC sp_InsertDetailImportForm @madn VARCHAR(20), @masp VARCHAR(20), @sl INT, @mach VARCHAR(20)
 AS
 BEGIN

	IF EXISTS(SELECT*FROM dbo.CT_DONNHAP WHERE MADN=@MADN AND MaSP=@MASP)
	BEGIN
		RAISERROR('CHI TIET DON NHAP DA TON TAI',15,1)
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO dbo.CT_DONNHAP
		(
		    MaDN,
		    MaSP,
		    SoLuongNhap
		)
		VALUES
		(   @MADN, -- MaDN - varchar(20)
		    @MASP, -- MaSP - varchar(20)
		    @SL   -- SoLuongNhap - int
		    )
	--	IF EXISTS(SELECT*FROM dbo.SP_CH WHERE MaSP=@masp AND MaCH=@mach)
	--	BEGIN
	--		-- UPDATE SO LUONG
	--		UPDATE dbo.SP_CH
	--		SET SoLuongTon=SoLuongTon+@sl
	--		WHERE MaCH=@MACH AND MaSP=@MASP
	--	END
	--	ELSE
	--	BEGIN
	--		--THEM SAN PHAM MOI VAO CUA HANG
	--		INSERT INTO dbo.SP_CH
	--		(
	--		    MaCH,
	--		    MaSP,
	--		    SoLuongTon
	--		)
	--		VALUES
	--		(   @MACH, -- MaCH - varchar(20)
	--		   @MASP, -- MaSP - varchar(20)
	--		    @SL   -- SoLuongTon - smallint
	--		    )
	--	END
	END
	

 END
 GO
 
 SELECT*FROM dbo.CT_DONNHAP
 SELECT*FROM dbo.DONNHAP
 DN0007JFYW 

 SELECT*FROM dbo.SP_CH WHERE MaCH='CH85650' AND SoLuongTon<50

 EXEC dbo.sp_InsertDetailImportForm @madn = 'DN0006SXZK', -- varchar(20)
                                    @masp = 'SP261013', -- varchar(20)
                                    @sl = 1000,    -- int
                                    @mach = 'CH85650'  -- varchar(20)
									
									SELECT*FROM dbo.SP_CH WHERE MACH = 'CH85650' AND MASP='SP261013'
									SELECT*FROM dbo.CT_DONNHAP WHERE 
									SELECT*FROM dbo.DONNHAP
									SELECT*FROM KHO
									SELECT*FROM dbo.DONNHAP WHERE manv='NV06168'

CREATE PROC sp_GetInfoDI @madn varchar(20)
AS
BEGIN
	
END
GO

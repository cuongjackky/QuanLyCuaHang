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
		UPDATE dbo.CT_NHANVIEN
		SET LuongThuong = (@DOANHSO - @QUOTA)*0.3,dbo.ct_nhanvien.TienBiTru=dbo.ct_nhanvien.SoNgayNghi*100000, 
					ct_nhanvien.Luong=ct_nhanvien.LuongCD+dbo.ct_nhanvien.LuongThuong-ct_nhanvien.TienBiTru
		
		FROM inserted i
		WHERE i.manv = dbo.CT_NHANVIEN.MaNV AND i.thang_nv=dbo.CT_NHANVIEN.Thang_NV AND i.nam_nv=dbo.CT_NHANVIEN.Nam_NV
	ELSE
    
		UPDATE dbo.CT_NHANVIEN
		SET LuongThuong=0, dbo.ct_nhanvien.TienBiTru=dbo.ct_nhanvien.SoNgayNghi*100000, 
			ct_nhanvien.Luong=ct_nhanvien.LuongCD+dbo.ct_nhanvien.LuongThuong-ct_nhanvien.TienBiTru
		FROM inserted i
		WHERE i.manv = dbo.CT_NHANVIEN.MaNV AND i.thang_nv=dbo.CT_NHANVIEN.Thang_NV AND i.nam_nv=dbo.CT_NHANVIEN.Nam_NV

	UPDATE dbo.CT_NHANVIEN
	SET HieuSuat = (dbo.CT_NHANVIEN.DoanhSo*1.0/dbo.CT_NHANVIEN.QuotaSale) * 100 
	FROM Inserted i
	WHERE i.MaNV = dbo.CT_NHANVIEN.MaNV AND i.Nam_NV = dbo.CT_NHANVIEN.Nam_NV AND i.Thang_NV = dbo.CT_NHANVIEN.Thang_NV

	--update so don hang, doanh so


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
			SELECT @luongcd= LuongCD FROM dbo.ct_nhanvien WHERE MaNV=@manv
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

Create or alter proc sp_XoaSanPham @MaCH varchar(20), @MaSP varchar(20) 
AS
BEGIN
	DELETE FROM LICHSUGIA WHERE MaSP = @MaSP

	DELETE CT_DONNHAP FROM CT_DONNHAP,DONNHAP,KHO WHERE [CT_DONNHAP].MaSP = @MaSP AND [CT_DONNHAP].MaDN=DONNHAP.MaDN AND DONNHAP.MaKho= KHO.MaKho AND KHO.MaCH=@MaCH

	DELETE CT_DONXUAT FROM CT_DONXUAT,DONXUAT,KHO WHERE CT_DONXUAT.MaSP = @MaSP AND CT_DONXUAT.MaDX=DONXUAT.MaDX AND DONXUAT.MaKho= KHO.MaKho AND KHO.MaCH=@MaCH

	DELETE CT_DONHANG FROM CT_DONHANG,DONHANG WHERE CT_DONHANG.MaSP= @MaSP AND CT_DONHANG.MaDH =DONHANG.MaDH AND DONHANG.MaCH = @MaCH

	DELETE FROM SP_CH WHERE SP_CH.MaSP= @MaSP AND SP_CH.MaCH = @MaCH

	
END
GO

create TRIGGER CTDH_MaNCC
ON CT_DONHANG AFTER INSERT
AS
BEGIN
	DECLARE @MaNCC varchar(20) SET @MaNCC=(SELECT SANPHAM.MaNCC FROM SANPHAM,inserted WHERE SANPHAM.MaSp =inserted.MaSP)

	UPDATE CT_DONHANG
	SET CT_DONHANG.MaNCC = @MaNCC
	FROM   CT_DONHANG,inserted
	WHERE CT_DONHANG.MaSP =inserted.MaSp AND CT_DONHANG.MaDH =inserted.MaDH
END
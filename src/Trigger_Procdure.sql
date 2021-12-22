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
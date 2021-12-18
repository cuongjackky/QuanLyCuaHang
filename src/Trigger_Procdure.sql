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
create proc sp_thanhTienSP 
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
exec sp_thanhTienSP
go
create proc sp_thanhTien
AS
BEGIN
	DECLARE @MaDH char(20)
	DECLARE @MaSP char(20)
	DECLARE @GiaBan int
	DECLARE @SoLuong int

	DECLARE d CURSOR
	FOR
	SELECT MASP, GiaGoc, PhanTramGiamGia
	FROM SANPHAM
	OPEN d
	FETCH NEXT FROM c INTO
	@MaDH,
	@MaSP,
	@GiaBan,
	@SoLuong
	While @@FETCH_STATUS =0
	BEGIN
		UPDATE CT_DONHANG
		SET CT_DONHANG.ThanhTien = @GiaBan*@SoLuong
		WHERE CT_DONHANG.MASP = @MaSP AND CT_DONHANG.MaDH= @MaDH
		Fetch next from d into
		@MaDH,
		@MaSP,
		@GiaBan,
		@SoLuong
	END
	close d
	deallocate d

END
go
exec sp_thanhTien
GO
create proc sp_donHang
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
Go
exec sp_donHang
GO
Create trigger trg_themChiTietDonHang ON CT_DONHANG AFTER INSERT AS
BEGIN
	UPDATE DONHANG SET
	DONHANG.TongTienSP = DONHANG.TongTienSP +(
	SELECT inserted.ThanhTien
	FROM inserted
	WHERE inserted.MaDH =DONHANG.MaDH)
	FROM DONHANG
	JOIN inserted ON DONHANG.MaDH = inserted.MaDH



END

GO

create proc sp_themChiTietDonHang
(
	@MaDH char(20),
	@MaSP char(20)
)
AS
BEGIN
	
	DECLARE @Gia bigint SET @Gia = (Select GiaGoc FROM SANPHAM WHERE MaSP = @MaSP)
	DECLARE @PhanTramGiam int Set @PhanTramGiam = (Select PhanTramGiamGia FROM SANPHAM WHERE MaSP =@MaSP)
	DECLARE @SoLuong int Set @SoLuong = (Select SoLuong From CT_DONHANG WHERE @MaDH = MaDH AND @MASP =MaSP)
	DECLARE @NCC varchar(20) SET @NCC = (SELECT MaNCC FROM SANPHAM WHERE @MaSP = MaSP)

	Update CT_DONHANG
	SET
		GiaBan = @Gia*(100-@PhanTramGiam)/100, ThanhTien = @Gia*(100-@PhanTramGiam)/100*@SoLuong, MaNCC=@NCC
		WHERE @MaDH =MaDH AND @MaSP =MaSP
END
go


create proc sp_capNhatDonHang
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
go


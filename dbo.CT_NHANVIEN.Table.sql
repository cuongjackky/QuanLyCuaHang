USE [Quanlycuahang]
GO
/****** Object:  Table [dbo].[CT_NHANVIEN]    Script Date: 12/19/2021 22:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CT_NHANVIEN](
	[MaNV] [varchar](20) NOT NULL,
	[Thang_NV] [char](2) NOT NULL,
	[Nam_NV] [char](4) NOT NULL,
	[QuotaSale] [int] NULL,
	[SoDonHang] [smallint] NULL,
	[DoanhSo] [int] NULL,
	[SoNgayNghi] [tinyint] NULL,
	[LuongCD] [int] NULL,
	[TienBiTru] [int] NULL,
	[LuongThuong] [int] NULL,
	[Luong] [int] NULL,
	[HieuSuat] [float] NULL,
 CONSTRAINT [PK_CTNV] PRIMARY KEY CLUSTERED 
(
	[MaNV] ASC,
	[Thang_NV] ASC,
	[Nam_NV] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[CT_NHANVIEN]  WITH CHECK ADD  CONSTRAINT [FK_CTNHANVIEN_NHANVIEN] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NHANVIEN] ([MaNV])
GO
ALTER TABLE [dbo].[CT_NHANVIEN] CHECK CONSTRAINT [FK_CTNHANVIEN_NHANVIEN]
GO

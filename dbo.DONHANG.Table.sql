USE [Quanlycuahang]
GO
/****** Object:  Table [dbo].[DONHANG]    Script Date: 12/19/2021 22:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DONHANG](
	[MaDH] [varchar](20) NOT NULL,
	[MaKH] [varchar](20) NULL,
	[MaCH] [varchar](20) NULL,
	[NgayDat] [datetime] NULL,
	[TongTienSP] [bigint] NULL,
	[PhiVC] [int] NULL,
	[TongTien] [bigint] NULL,
	[SoNha_GH] [nvarchar](5) NULL,
	[Duong_GH] [nvarchar](30) NULL,
	[Phuong_GH] [nvarchar](30) NULL,
	[Quan_GH] [nvarchar](30) NULL,
	[TPho_GH] [nvarchar](30) NULL,
	[HinhThucThanhToan] [nvarchar](30) NULL,
	[TrangThaiDH] [nvarchar](20) NULL,
	[MaNV] [varchar](20) NULL,
 CONSTRAINT [PK_DH] PRIMARY KEY CLUSTERED 
(
	[MaDH] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DONHANG]  WITH CHECK ADD  CONSTRAINT [FK_DONHANG_CUAHANG] FOREIGN KEY([MaCH])
REFERENCES [dbo].[CUAHANG] ([MaCH])
GO
ALTER TABLE [dbo].[DONHANG] CHECK CONSTRAINT [FK_DONHANG_CUAHANG]
GO
ALTER TABLE [dbo].[DONHANG]  WITH CHECK ADD  CONSTRAINT [FK_DONHANG_KHACHHANG] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KHACHHANG] ([MaKH])
GO
ALTER TABLE [dbo].[DONHANG] CHECK CONSTRAINT [FK_DONHANG_KHACHHANG]
GO
ALTER TABLE [dbo].[DONHANG]  WITH CHECK ADD  CONSTRAINT [FK_DONHANG_NHANVIEN] FOREIGN KEY([MaNV])
REFERENCES [dbo].[NHANVIEN] ([MaNV])
GO
ALTER TABLE [dbo].[DONHANG] CHECK CONSTRAINT [FK_DONHANG_NHANVIEN]
GO

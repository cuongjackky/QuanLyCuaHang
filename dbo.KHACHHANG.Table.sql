USE [Quanlycuahang]
GO
/****** Object:  Table [dbo].[KHACHHANG]    Script Date: 12/19/2021 22:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[KHACHHANG](
	[MaKH] [varchar](20) NOT NULL,
	[HoKH] [nvarchar](20) NULL,
	[TenKH] [nvarchar](20) NULL,
	[GioiTinh_KH] [nvarchar](3) NULL,
	[NgaySinh_KH] [datetime] NULL,
	[SDT_KH] [varchar](10) NULL,
	[Email_KH] [varchar](30) NULL,
	[SoNha] [nvarchar](5) NULL,
	[Duong] [nvarchar](30) NULL,
	[Phuong] [nvarchar](30) NULL,
	[Quan] [nvarchar](20) NULL,
	[TPho] [nvarchar](20) NULL,
 CONSTRAINT [PK_KH] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO

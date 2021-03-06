USE [Quanlycuahang]
GO
/****** Object:  Table [dbo].[TAIKHOAN_KH]    Script Date: 12/19/2021 22:13:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TAIKHOAN_KH](
	[MaKH] [varchar](20) NOT NULL,
	[ID] [varchar](20) NULL,
	[PassWord] [varchar](20) NULL,
 CONSTRAINT [PK_TAIKHOANKH] PRIMARY KEY CLUSTERED 
(
	[MaKH] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TAIKHOAN_KH]  WITH CHECK ADD  CONSTRAINT [FK_TAIKHOAN_KHACHHANG] FOREIGN KEY([MaKH])
REFERENCES [dbo].[KHACHHANG] ([MaKH])
GO
ALTER TABLE [dbo].[TAIKHOAN_KH] CHECK CONSTRAINT [FK_TAIKHOAN_KHACHHANG]
GO

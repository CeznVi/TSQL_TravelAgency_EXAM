USE [master]
GO
/****** Object:  Database [TravelAgency]    Script Date: 08.02.2023 23:48:38 ******/
CREATE DATABASE [TravelAgency]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TravelAgency', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\TravelAgency.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TravelAgency_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\TravelAgency_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [TravelAgency] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TravelAgency].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TravelAgency] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TravelAgency] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TravelAgency] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TravelAgency] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TravelAgency] SET ARITHABORT OFF 
GO
ALTER DATABASE [TravelAgency] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TravelAgency] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TravelAgency] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TravelAgency] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TravelAgency] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TravelAgency] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TravelAgency] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TravelAgency] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TravelAgency] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TravelAgency] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TravelAgency] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TravelAgency] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TravelAgency] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TravelAgency] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TravelAgency] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TravelAgency] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TravelAgency] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TravelAgency] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TravelAgency] SET  MULTI_USER 
GO
ALTER DATABASE [TravelAgency] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TravelAgency] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TravelAgency] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TravelAgency] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TravelAgency] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TravelAgency] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [TravelAgency] SET QUERY_STORE = OFF
GO
USE [TravelAgency]
GO
/****** Object:  Table [dbo].[City]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cityName] [nvarchar](70) NOT NULL,
 CONSTRAINT [PK_City] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_City_cityName] UNIQUE NONCLUSTERED 
(
	[cityName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[countryName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Table_countryName] UNIQUE NONCLUSTERED 
(
	[countryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CountryCode]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CountryCode](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](4) NOT NULL,
 CONSTRAINT [PK_CountryCode] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_CountryCode_code] UNIQUE NONCLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [nvarchar](50) NOT NULL,
	[surName] [nvarchar](50) NOT NULL,
	[lastName] [nvarchar](50) NOT NULL,
	[email] [nvarchar](30) NOT NULL,
	[telephoneId] [int] NOT NULL,
	[birthDay] [date] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Customers_email] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerTourPayedList]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerTourPayedList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tourId] [int] NULL,
	[tourArchiveId] [int] NULL,
	[customerId] [int] NOT NULL,
 CONSTRAINT [PK_CustomerTourPayedList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomerTourPotentialList]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerTourPotentialList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tourId] [int] NOT NULL,
	[customerId] [int] NOT NULL,
 CONSTRAINT [PK_CustomerTourPotentialList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FutureTourList]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FutureTourList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customerId] [int] NOT NULL,
	[tourId] [int] NOT NULL,
 CONSTRAINT [PK_FutureTourList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Hotel]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Hotel](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](70) NOT NULL,
	[description] [nvarchar](160) NOT NULL,
	[starCount] [int] NOT NULL,
	[image] [image] NULL,
	[countryId] [int] NOT NULL,
	[cityId] [int] NOT NULL,
	[telephoneId] [int] NOT NULL,
 CONSTRAINT [PK_Hotel] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LastTourList]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LastTourList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customerId] [int] NOT NULL,
	[tourId] [int] NULL,
	[tourArchiveId] [int] NULL,
 CONSTRAINT [PK_LastTourList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemorablePlaces]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemorablePlaces](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tourId] [int] NULL,
	[tourArchiveId] [int] NULL,
	[placeId] [int] NOT NULL,
	[isFree] [bit] NOT NULL,
	[coast] [money] NOT NULL,
 CONSTRAINT [PK_MemorablePlaces] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Number]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Number](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[number] [varchar](10) NOT NULL,
 CONSTRAINT [PK_Number] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Number] UNIQUE NONCLUSTERED 
(
	[number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Place]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Place](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](70) NOT NULL,
	[description] [nvarchar](200) NOT NULL,
	[img] [image] NULL,
	[countryId] [int] NOT NULL,
	[cityId] [int] NOT NULL,
 CONSTRAINT [PK_Place] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[employPosition] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Table_employPosition] UNIQUE NONCLUSTERED 
(
	[employPosition] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Telephone]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telephone](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[countryCodeId] [int] NOT NULL,
	[numberId] [int] NOT NULL,
 CONSTRAINT [PK_Telephone] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tour]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tour](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](120) NOT NULL,
	[price] [money] NOT NULL,
	[startDate] [date] NOT NULL,
	[finishDate] [date] NOT NULL,
	[responsibleWorkerId] [int] NOT NULL,
	[maxTouristCount] [int] NOT NULL,
 CONSTRAINT [PK_Tour] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TourArhive]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TourArhive](
	[id] [int] NOT NULL,
	[name] [nvarchar](120) NOT NULL,
	[price] [money] NOT NULL,
	[startDate] [date] NOT NULL,
	[finishDate] [date] NOT NULL,
	[responsibleWorkerId] [int] NOT NULL,
	[maxTouristCount] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TourHotel]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TourHotel](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tourId] [int] NULL,
	[tourArchiveId] [int] NULL,
	[hotelId] [int] NULL,
 CONSTRAINT [PK_TourHotel] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transport]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transport](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[typeOfTransport] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Transport] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Transport_typeOfTransport] UNIQUE NONCLUSTERED 
(
	[typeOfTransport] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TransportModeList]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransportModeList](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tourId] [int] NULL,
	[tourArchiveId] [int] NULL,
	[transportId] [int] NOT NULL,
 CONSTRAINT [PK_TransportModeList] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VisitCountryCity]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VisitCountryCity](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tourId] [int] NULL,
	[tourArchiveId] [int] NULL,
	[visitDate] [date] NOT NULL,
	[countryId] [int] NOT NULL,
	[cityId] [int] NOT NULL,
 CONSTRAINT [PK_VisitCountryCity] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Worker]    Script Date: 08.02.2023 23:48:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Worker](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[firstName] [nvarchar](50) NOT NULL,
	[surName] [nvarchar](50) NOT NULL,
	[lastName] [nvarchar](50) NOT NULL,
	[positionId] [int] NOT NULL,
	[email] [nvarchar](30) NOT NULL,
	[telephoneId] [int] NOT NULL,
	[dateEmployment] [date] NOT NULL,
 CONSTRAINT [PK_Worker] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Worker_email] UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Hotel] ADD  CONSTRAINT [DF_Hotel_starCount]  DEFAULT ((1)) FOR [starCount]
GO
ALTER TABLE [dbo].[MemorablePlaces] ADD  CONSTRAINT [DF_MemorablePlaces_isFree]  DEFAULT ((1)) FOR [isFree]
GO
ALTER TABLE [dbo].[MemorablePlaces] ADD  CONSTRAINT [DF_MemorablePlaces_coast]  DEFAULT ((0)) FOR [coast]
GO
ALTER TABLE [dbo].[Place] ADD  CONSTRAINT [DF_Place_description]  DEFAULT (N'(опис не додано)') FOR [description]
GO
ALTER TABLE [dbo].[Tour] ADD  CONSTRAINT [DF_Tour_price]  DEFAULT ((0)) FOR [price]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Telephone] FOREIGN KEY([telephoneId])
REFERENCES [dbo].[Telephone] ([id])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Telephone]
GO
ALTER TABLE [dbo].[CustomerTourPayedList]  WITH CHECK ADD  CONSTRAINT [FK_CustomerTourPayedList_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([id])
GO
ALTER TABLE [dbo].[CustomerTourPayedList] CHECK CONSTRAINT [FK_CustomerTourPayedList_Customers]
GO
ALTER TABLE [dbo].[CustomerTourPayedList]  WITH CHECK ADD  CONSTRAINT [FK_CustomerTourPayedList_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[CustomerTourPayedList] CHECK CONSTRAINT [FK_CustomerTourPayedList_Tour]
GO
ALTER TABLE [dbo].[CustomerTourPayedList]  WITH CHECK ADD  CONSTRAINT [FK_CustomerTourPayedList_TourArhive] FOREIGN KEY([tourArchiveId])
REFERENCES [dbo].[TourArhive] ([id])
GO
ALTER TABLE [dbo].[CustomerTourPayedList] CHECK CONSTRAINT [FK_CustomerTourPayedList_TourArhive]
GO
ALTER TABLE [dbo].[CustomerTourPotentialList]  WITH CHECK ADD  CONSTRAINT [FK_CustomerTourPotentialList_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([id])
GO
ALTER TABLE [dbo].[CustomerTourPotentialList] CHECK CONSTRAINT [FK_CustomerTourPotentialList_Customers]
GO
ALTER TABLE [dbo].[CustomerTourPotentialList]  WITH CHECK ADD  CONSTRAINT [FK_CustomerTourPotentialList_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CustomerTourPotentialList] CHECK CONSTRAINT [FK_CustomerTourPotentialList_Tour]
GO
ALTER TABLE [dbo].[FutureTourList]  WITH CHECK ADD  CONSTRAINT [FK_FutureTourList_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([id])
GO
ALTER TABLE [dbo].[FutureTourList] CHECK CONSTRAINT [FK_FutureTourList_Customers]
GO
ALTER TABLE [dbo].[FutureTourList]  WITH CHECK ADD  CONSTRAINT [FK_FutureTourList_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[FutureTourList] CHECK CONSTRAINT [FK_FutureTourList_Tour]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [FK_Hotel_City] FOREIGN KEY([cityId])
REFERENCES [dbo].[City] ([id])
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [FK_Hotel_City]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [FK_Hotel_Country] FOREIGN KEY([countryId])
REFERENCES [dbo].[Country] ([id])
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [FK_Hotel_Country]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [FK_Hotel_Telephone] FOREIGN KEY([telephoneId])
REFERENCES [dbo].[Telephone] ([id])
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [FK_Hotel_Telephone]
GO
ALTER TABLE [dbo].[LastTourList]  WITH CHECK ADD  CONSTRAINT [FK_LastTourList_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([id])
GO
ALTER TABLE [dbo].[LastTourList] CHECK CONSTRAINT [FK_LastTourList_Customers]
GO
ALTER TABLE [dbo].[LastTourList]  WITH CHECK ADD  CONSTRAINT [FK_LastTourList_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[LastTourList] CHECK CONSTRAINT [FK_LastTourList_Tour]
GO
ALTER TABLE [dbo].[LastTourList]  WITH CHECK ADD  CONSTRAINT [FK_LastTourList_TourArhive] FOREIGN KEY([tourArchiveId])
REFERENCES [dbo].[TourArhive] ([id])
GO
ALTER TABLE [dbo].[LastTourList] CHECK CONSTRAINT [FK_LastTourList_TourArhive]
GO
ALTER TABLE [dbo].[MemorablePlaces]  WITH CHECK ADD  CONSTRAINT [FK_MemorablePlaces_Place] FOREIGN KEY([placeId])
REFERENCES [dbo].[Place] ([id])
GO
ALTER TABLE [dbo].[MemorablePlaces] CHECK CONSTRAINT [FK_MemorablePlaces_Place]
GO
ALTER TABLE [dbo].[MemorablePlaces]  WITH CHECK ADD  CONSTRAINT [FK_MemorablePlaces_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[MemorablePlaces] CHECK CONSTRAINT [FK_MemorablePlaces_Tour]
GO
ALTER TABLE [dbo].[MemorablePlaces]  WITH CHECK ADD  CONSTRAINT [FK_MemorablePlaces_TourArhive] FOREIGN KEY([tourArchiveId])
REFERENCES [dbo].[TourArhive] ([id])
GO
ALTER TABLE [dbo].[MemorablePlaces] CHECK CONSTRAINT [FK_MemorablePlaces_TourArhive]
GO
ALTER TABLE [dbo].[Place]  WITH CHECK ADD  CONSTRAINT [FK_Place_City] FOREIGN KEY([cityId])
REFERENCES [dbo].[City] ([id])
GO
ALTER TABLE [dbo].[Place] CHECK CONSTRAINT [FK_Place_City]
GO
ALTER TABLE [dbo].[Place]  WITH CHECK ADD  CONSTRAINT [FK_Place_Country] FOREIGN KEY([countryId])
REFERENCES [dbo].[Country] ([id])
GO
ALTER TABLE [dbo].[Place] CHECK CONSTRAINT [FK_Place_Country]
GO
ALTER TABLE [dbo].[Telephone]  WITH CHECK ADD  CONSTRAINT [FK_Telephone_CountryCode] FOREIGN KEY([countryCodeId])
REFERENCES [dbo].[CountryCode] ([id])
GO
ALTER TABLE [dbo].[Telephone] CHECK CONSTRAINT [FK_Telephone_CountryCode]
GO
ALTER TABLE [dbo].[Telephone]  WITH CHECK ADD  CONSTRAINT [FK_Telephone_Number] FOREIGN KEY([numberId])
REFERENCES [dbo].[Number] ([id])
GO
ALTER TABLE [dbo].[Telephone] CHECK CONSTRAINT [FK_Telephone_Number]
GO
ALTER TABLE [dbo].[Tour]  WITH CHECK ADD  CONSTRAINT [FK_Tour_Worker] FOREIGN KEY([responsibleWorkerId])
REFERENCES [dbo].[Worker] ([id])
GO
ALTER TABLE [dbo].[Tour] CHECK CONSTRAINT [FK_Tour_Worker]
GO
ALTER TABLE [dbo].[TourArhive]  WITH CHECK ADD  CONSTRAINT [FK_TourArhive_Worker] FOREIGN KEY([responsibleWorkerId])
REFERENCES [dbo].[Worker] ([id])
GO
ALTER TABLE [dbo].[TourArhive] CHECK CONSTRAINT [FK_TourArhive_Worker]
GO
ALTER TABLE [dbo].[TourHotel]  WITH CHECK ADD  CONSTRAINT [FK_TourHotel_Hotel] FOREIGN KEY([hotelId])
REFERENCES [dbo].[Hotel] ([id])
GO
ALTER TABLE [dbo].[TourHotel] CHECK CONSTRAINT [FK_TourHotel_Hotel]
GO
ALTER TABLE [dbo].[TourHotel]  WITH CHECK ADD  CONSTRAINT [FK_TourHotel_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[TourHotel] CHECK CONSTRAINT [FK_TourHotel_Tour]
GO
ALTER TABLE [dbo].[TourHotel]  WITH CHECK ADD  CONSTRAINT [FK_TourHotel_TourArhive] FOREIGN KEY([tourArchiveId])
REFERENCES [dbo].[TourArhive] ([id])
GO
ALTER TABLE [dbo].[TourHotel] CHECK CONSTRAINT [FK_TourHotel_TourArhive]
GO
ALTER TABLE [dbo].[TransportModeList]  WITH CHECK ADD  CONSTRAINT [FK_TransportModeList_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[TransportModeList] CHECK CONSTRAINT [FK_TransportModeList_Tour]
GO
ALTER TABLE [dbo].[TransportModeList]  WITH CHECK ADD  CONSTRAINT [FK_TransportModeList_TourArhive] FOREIGN KEY([tourArchiveId])
REFERENCES [dbo].[TourArhive] ([id])
GO
ALTER TABLE [dbo].[TransportModeList] CHECK CONSTRAINT [FK_TransportModeList_TourArhive]
GO
ALTER TABLE [dbo].[TransportModeList]  WITH CHECK ADD  CONSTRAINT [FK_TransportModeList_Transport] FOREIGN KEY([transportId])
REFERENCES [dbo].[Transport] ([id])
GO
ALTER TABLE [dbo].[TransportModeList] CHECK CONSTRAINT [FK_TransportModeList_Transport]
GO
ALTER TABLE [dbo].[VisitCountryCity]  WITH CHECK ADD  CONSTRAINT [FK_VisitCountryCity_City] FOREIGN KEY([cityId])
REFERENCES [dbo].[City] ([id])
GO
ALTER TABLE [dbo].[VisitCountryCity] CHECK CONSTRAINT [FK_VisitCountryCity_City]
GO
ALTER TABLE [dbo].[VisitCountryCity]  WITH CHECK ADD  CONSTRAINT [FK_VisitCountryCity_Country] FOREIGN KEY([countryId])
REFERENCES [dbo].[Country] ([id])
GO
ALTER TABLE [dbo].[VisitCountryCity] CHECK CONSTRAINT [FK_VisitCountryCity_Country]
GO
ALTER TABLE [dbo].[VisitCountryCity]  WITH CHECK ADD  CONSTRAINT [FK_VisitCountryCity_Tour] FOREIGN KEY([tourId])
REFERENCES [dbo].[Tour] ([id])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[VisitCountryCity] CHECK CONSTRAINT [FK_VisitCountryCity_Tour]
GO
ALTER TABLE [dbo].[VisitCountryCity]  WITH CHECK ADD  CONSTRAINT [FK_VisitCountryCity_TourArhive] FOREIGN KEY([tourArchiveId])
REFERENCES [dbo].[TourArhive] ([id])
GO
ALTER TABLE [dbo].[VisitCountryCity] CHECK CONSTRAINT [FK_VisitCountryCity_TourArhive]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [FK_Worker_Position] FOREIGN KEY([positionId])
REFERENCES [dbo].[Position] ([id])
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [FK_Worker_Position]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [FK_Worker_Telephone] FOREIGN KEY([telephoneId])
REFERENCES [dbo].[Telephone] ([id])
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [FK_Worker_Telephone]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [CK_City_cityName] CHECK  (([cityName]<>''))
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [CK_City_cityName]
GO
ALTER TABLE [dbo].[Country]  WITH CHECK ADD  CONSTRAINT [CK_Table_coutryName] CHECK  (([countryName]<>''))
GO
ALTER TABLE [dbo].[Country] CHECK CONSTRAINT [CK_Table_coutryName]
GO
ALTER TABLE [dbo].[CountryCode]  WITH CHECK ADD  CONSTRAINT [CK_CountryCode_code] CHECK  (([code] like '[0-9][0-9]' OR [code] like '[0-9][0-9][0-9]' OR [code] like '[0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[CountryCode] CHECK CONSTRAINT [CK_CountryCode_code]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [CK_Customers_birthDay] CHECK  (([birthDay]<=getdate()))
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [CK_Customers_birthDay]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [CK_Customers_firstName] CHECK  (([firstName]<>''))
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [CK_Customers_firstName]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [CK_Customers_lastName] CHECK  (([lastName]<>''))
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [CK_Customers_lastName]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [CK_Customers_surName] CHECK  (([surName]<>''))
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [CK_Customers_surName]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [CK_Hotel_description] CHECK  (([description]<>''))
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [CK_Hotel_description]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [CK_Hotel_name] CHECK  (([name]<>''))
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [CK_Hotel_name]
GO
ALTER TABLE [dbo].[Hotel]  WITH CHECK ADD  CONSTRAINT [CK_Hotel_starCount] CHECK  (([starCount]>=(0) AND [starCount]<=(5)))
GO
ALTER TABLE [dbo].[Hotel] CHECK CONSTRAINT [CK_Hotel_starCount]
GO
ALTER TABLE [dbo].[Number]  WITH CHECK ADD  CONSTRAINT [CK_Number_number] CHECK  (([number] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Number] CHECK CONSTRAINT [CK_Number_number]
GO
ALTER TABLE [dbo].[Place]  WITH CHECK ADD  CONSTRAINT [CK_Place_description] CHECK  (([description]<>''))
GO
ALTER TABLE [dbo].[Place] CHECK CONSTRAINT [CK_Place_description]
GO
ALTER TABLE [dbo].[Place]  WITH CHECK ADD  CONSTRAINT [CK_Place_name] CHECK  (([name]<>''))
GO
ALTER TABLE [dbo].[Place] CHECK CONSTRAINT [CK_Place_name]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [CK_Position_employPosition] CHECK  (([employPosition]<>''))
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [CK_Position_employPosition]
GO
ALTER TABLE [dbo].[Tour]  WITH CHECK ADD  CONSTRAINT [CK_Tour_finishDate] CHECK  (([finishDate]>=[startDate]))
GO
ALTER TABLE [dbo].[Tour] CHECK CONSTRAINT [CK_Tour_finishDate]
GO
ALTER TABLE [dbo].[Tour]  WITH CHECK ADD  CONSTRAINT [CK_Tour_name] CHECK  (([name]<>''))
GO
ALTER TABLE [dbo].[Tour] CHECK CONSTRAINT [CK_Tour_name]
GO
ALTER TABLE [dbo].[TourArhive]  WITH CHECK ADD CHECK  (([name]<>''))
GO
ALTER TABLE [dbo].[Transport]  WITH CHECK ADD  CONSTRAINT [CK_Transport_typeOfTransport] CHECK  (([typeOfTransport]<>''))
GO
ALTER TABLE [dbo].[Transport] CHECK CONSTRAINT [CK_Transport_typeOfTransport]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [CK_Worker_dateEmployment] CHECK  (([dateEmployment]<=getdate()))
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [CK_Worker_dateEmployment]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [CK_Worker_firstName] CHECK  (([firstName]<>''))
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [CK_Worker_firstName]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [CK_Worker_lastName] CHECK  (([lastName]<>''))
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [CK_Worker_lastName]
GO
ALTER TABLE [dbo].[Worker]  WITH CHECK ADD  CONSTRAINT [CK_Worker_surName] CHECK  (([surName]<>''))
GO
ALTER TABLE [dbo].[Worker] CHECK CONSTRAINT [CK_Worker_surName]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be uniq' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'City', @level2type=N'CONSTRAINT',@level2name=N'IX_City_cityName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'не має бути порожнім' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'City', @level2type=N'CONSTRAINT',@level2name=N'CK_City_cityName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be uniq' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Country', @level2type=N'CONSTRAINT',@level2name=N'IX_Table_countryName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Перевірка на вірній код країни' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CountryCode', @level2type=N'CONSTRAINT',@level2name=N'CK_CountryCode_code'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be unique' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customers', @level2type=N'CONSTRAINT',@level2name=N'IX_Customers_email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customers', @level2type=N'CONSTRAINT',@level2name=N'CK_Customers_firstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customers', @level2type=N'CONSTRAINT',@level2name=N'CK_Customers_lastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customers', @level2type=N'CONSTRAINT',@level2name=N'CK_Customers_surName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'must be not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hotel', @level2type=N'CONSTRAINT',@level2name=N'CK_Hotel_description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'not null string' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hotel', @level2type=N'CONSTRAINT',@level2name=N'CK_Hotel_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be <=5 AND >= 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Hotel', @level2type=N'CONSTRAINT',@level2name=N'CK_Hotel_starCount'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description must be not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Place', @level2type=N'CONSTRAINT',@level2name=N'CK_Place_description'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name must be not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Place', @level2type=N'CONSTRAINT',@level2name=N'CK_Place_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Перевірка поля на унікальність' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Position', @level2type=N'CONSTRAINT',@level2name=N'IX_Table_employPosition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'перевірка поля посади' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Position', @level2type=N'CONSTRAINT',@level2name=N'CK_Position_employPosition'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'finishDate >= startDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tour', @level2type=N'CONSTRAINT',@level2name=N'CK_Tour_finishDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'must be not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Tour', @level2type=N'CONSTRAINT',@level2name=N'CK_Tour_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'may be uniq' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transport', @level2type=N'CONSTRAINT',@level2name=N'IX_Transport_typeOfTransport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'not null' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Transport', @level2type=N'CONSTRAINT',@level2name=N'CK_Transport_typeOfTransport'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Перевірка на унікальність емейлу' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Worker', @level2type=N'CONSTRAINT',@level2name=N'IX_Worker_email'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Не може бути порожнім' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Worker', @level2type=N'CONSTRAINT',@level2name=N'CK_Worker_firstName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'не може бути порожнім рядком' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Worker', @level2type=N'CONSTRAINT',@level2name=N'CK_Worker_lastName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'не може бути порожнім рядком' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Worker', @level2type=N'CONSTRAINT',@level2name=N'CK_Worker_surName'
GO
USE [master]
GO
ALTER DATABASE [TravelAgency] SET  READ_WRITE 
GO

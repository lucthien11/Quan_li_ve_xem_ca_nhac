create database KPOPTOUR
drop database KPOPTOUR
create table DIADIEM
( 
	MADIADIEM char(10) primary key not null, 
    TENDIADIEM nvarchar(100) not null, 
    DIACHI nvarchar(50) unique not null, 
    SODIENTHOAI varchar(12) check(SODIENTHOAI not like '%[^0-9]%') not null, 
	SOLUONGGHE int check (SOLUONGGHE >=0)
); 

create table GHE
( 
	MAGHE int primary key not null,
	GHE char(10) not null,	
	HANG char(10) not null, 
	VITRI char(10) not null,
	MADIADIEM char(10),
	LOAIGHE nvarchar(50) check (LOAIGHE in (N'THƯỜNG',N'VIP')),
	constraint GHE_DD unique (GHE,MADIADIEM),	
	constraint FK_GHE_DIADIEM foreign key (MADIADIEM) references DIADIEM (MADIADIEM)
	on delete cascade
	on update cascade
);


insert into DIADIEM values  
('DD01', N'Trường đại học Kinh tế Quốc dân', N'207 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'   , '02436280280', 15),  
('DD02', N'Trường đại học Bách Khoa Hà Nội', N'1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội'   , '02436231732', 15),  
('DD03', N'Trường đại học Xây Dựng'        , N'55 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'    , '02438630001', 15),  
('DD04', N'Trường đại học Mở Hà Nội'       , N'B101 Nguyễn Hiền, Bách Khoa, Hai Bà Trưng, Hà Nội', '02438682321', 15),  
('DD05', N'Học viện Tài chính'             , N'56 Văn Hiến, Đông Ngạc, Bắc Từ Liêm, Hà Nội'      , '02438362161', 15)  
select * from DIADIEM

insert into GHE values
(1,'1A', 'A', '1', 'DD01',N'VIP'),
(2,'2A', 'A', '2', 'DD01',N'VIP'),
(3,'3A', 'A', '3', 'DD01',N'VIP'),
(4,'4A', 'A', '4', 'DD01',N'VIP'),
(5,'5A', 'A', '5', 'DD01',N'VIP'),
(6,'1B', 'B', '1', 'DD01',N'THƯỜNG'),
(7,'2B', 'B', '2', 'DD01',N'THƯỜNG'),
(8,'3B', 'B', '3', 'DD01',N'THƯỜNG'),
(9,'4B', 'B', '4', 'DD01',N'THƯỜNG'),
(10,'5B', 'B', '5', 'DD01',N'THƯỜNG'),
(11,'1C', 'C', '1', 'DD01',N'THƯỜNG'),
(12,'2C', 'C', '2', 'DD01',N'THƯỜNG'),
(13,'3C', 'C', '3', 'DD01',N'THƯỜNG'),
(14,'4C', 'C', '4', 'DD01',N'THƯỜNG'),
(15,'5C', 'C', '5', 'DD01',N'THƯỜNG'),
(16,'1A', 'A', '1', 'DD02',N'VIP'),
(17,'2A', 'A', '2', 'DD02',N'VIP'),
(18,'3A', 'A', '3', 'DD02',N'VIP'),
(19,'4A', 'A', '4', 'DD02',N'VIP'),
(20,'5A', 'A', '5', 'DD02',N'VIP'),
(21,'1B', 'B', '1', 'DD02',N'THƯỜNG'),
(22,'2B', 'B', '2', 'DD02',N'THƯỜNG'),
(23,'3B', 'B', '3', 'DD02',N'THƯỜNG'),
(24,'4B', 'B', '4', 'DD02',N'THƯỜNG'),
(25,'5B', 'B', '5', 'DD02',N'THƯỜNG'),
(26,'1C', 'C', '1', 'DD02',N'THƯỜNG'),
(27,'2C', 'C', '2', 'DD02',N'THƯỜNG'),
(28,'3C', 'C', '3', 'DD02',N'THƯỜNG'),
(29,'4C', 'C', '4', 'DD02',N'THƯỜNG'),
(30,'5C', 'C', '5', 'DD02',N'THƯỜNG'),
(31,'1A', 'A', '1', 'DD03',N'VIP'),
(32,'2A', 'A', '2', 'DD03',N'VIP'),
(33,'3A', 'A', '3', 'DD03',N'VIP'),
(34,'4A', 'A', '4', 'DD03',N'VIP'),
(35,'5A', 'A', '5', 'DD03',N'VIP'),
(36,'1B', 'B', '1', 'DD03',N'THƯỜNG'),
(37,'2B', 'B', '2', 'DD03',N'THƯỜNG'),
(38,'3B', 'B', '3', 'DD03',N'THƯỜNG'),
(39,'4B', 'B', '4', 'DD03',N'THƯỜNG'),
(40,'5B', 'B', '5', 'DD03',N'THƯỜNG'),
(41,'1C', 'C', '1', 'DD03',N'THƯỜNG'),
(42,'2C', 'C', '2', 'DD03',N'THƯỜNG'),
(43,'3C', 'C', '3', 'DD03',N'THƯỜNG'),
(44,'4C', 'C', '4', 'DD03',N'THƯỜNG'),
(45,'5C', 'C', '5', 'DD03',N'THƯỜNG'),
(46,'1A', 'A', '1', 'DD04',N'VIP'),
(47,'2A', 'A', '2', 'DD04',N'VIP'),
(48,'3A', 'A', '3', 'DD04',N'VIP'),
(49,'4A', 'A', '4', 'DD04',N'VIP'),
(50,'5A', 'A', '5', 'DD04',N'VIP'),
(51,'1B', 'B', '1', 'DD04',N'THƯỜNG'),
(52,'2B', 'B', '2', 'DD04',N'THƯỜNG'),
(53,'3B', 'B', '3', 'DD04',N'THƯỜNG'),
(54,'4B', 'B', '4', 'DD04',N'THƯỜNG'),
(55,'5B', 'B', '5', 'DD04',N'THƯỜNG'),
(56,'1C', 'C', '1', 'DD04',N'THƯỜNG'),
(57,'2C', 'C', '2', 'DD04',N'THƯỜNG'),
(58,'3C', 'C', '3', 'DD04',N'THƯỜNG'),
(59,'4C', 'C', '4', 'DD04',N'THƯỜNG'),
(60,'5C', 'C', '5', 'DD04',N'THƯỜNG'),
(61,'1A', 'A', '1', 'DD05',N'VIP'),
(62,'2A', 'A', '2', 'DD05',N'VIP'),
(63,'3A', 'A', '3', 'DD05',N'VIP'),
(64,'4A', 'A', '4', 'DD05',N'VIP'),
(65,'5A', 'A', '5', 'DD05',N'VIP'),
(66,'1B', 'B', '1', 'DD05',N'THƯỜNG'),
(67,'2B', 'B', '2', 'DD05',N'THƯỜNG'),
(68,'3B', 'B', '3', 'DD05',N'THƯỜNG'),
(69,'4B', 'B', '4', 'DD05',N'THƯỜNG'),
(70,'5B', 'B', '5', 'DD05',N'THƯỜNG'),
(71,'1C', 'C', '1', 'DD05',N'THƯỜNG'),
(72,'2C', 'C', '2', 'DD05',N'THƯỜNG'),
(73,'3C', 'C', '3', 'DD05',N'THƯỜNG'),
(74,'4C', 'C', '4', 'DD05',N'THƯỜNG'),
(75,'5C', 'C', '5', 'DD05',N'THƯỜNG')

--delete from DIADIEM where  MADIADIEM='DD06'
--update DIADIEM set MADIADIEM='DD06' where MADIADIEM='DD02'
select * from GHE

create table NHANVIENTHUNGAN
( 
    MANHANVIEN char(10) primary key not null, 
    TEN nvarchar(100) not null, 
    SODIENTHOAI varchar(12) check(SODIENTHOAI not like '%[^0-9]%') not null, 
    NGAYSINH date not null 
); 

create table DAMNHIEM 
( 
	MANHANVIEN char(10) references NHANVIENTHUNGAN(MANHANVIEN) not null, 
	CATRUC int not null,
	constraint PK_DAMNHIEM primary key (MANHANVIEN,CATRUC)
);

insert into NHANVIENTHUNGAN values 
('NV01', N'Nguyễn Ngọc Ngạn', '0339784890', '1999-02-13'),													   
('NV02', N'Nguyễn Ngọc Minh', '0347747847', '1996-05-30'),													   
('NV03', N'Mèo Simmy'       , '0973865473', '1989-06-30'),													  
('NV04', N'Trần Khánh Ly'   , '0837468374', '1995-08-21'),													   
('NV05', N'Đàm Vĩnh Biệt'   , '0334745637', '2000-09-22'),													 
('NV06', N'Lũ Thủy Tiên'    , '0835274857', '1986-10-11'),													
('NV07', N'Lụt Công Vinh'   , '0935746837', '1997-09-12'),
('NV08', N'Trần My'         , '0384658269', '1994-07-13'),
('NV09', N'Mai Kim Trí'     , '0384624862', '1998-08-14')

select * from NHANVIENTHUNGAN

insert into DAMNHIEM values 
('NV01', 1), 
('NV02', 2), 
('NV03', 3), 
('NV04', 1), 
('NV05', 2), 
('NV06', 3), 
('NV07', 2), 
('NV08', 3), 
('NV09', 2) 

select * from DAMNHIEM 

create table KHACHHANG 
( 
    MAKHACHHANG  char(10) primary key not null,
    TENKHACHHANG nvarchar(50) not null, 
    SODIENTHOAI varchar(12) check(SODIENTHOAI not like '%[^0-9]%') not null, 
    NGAYSINH date not null, 
    EMAIL nvarchar (50) 
);

insert into KHACHHANG values 
('KH01', N'Trần Văn An'    , '027856427', '2002-08-12', 'vanan2002@gmail.com'    ), 
('KH02', N'Đỗ Mạnh Thiên'  , '073682747', '2001-04-03', 'manhthien2001@gmail.com'), 
('KH03', N'Lục Cao Bằng'   , '024592957', '1996-01-05', 'caobang1996@gmail.com'  ), 
('KH04', N'Trần Thái Hà'   , '089759275', '1998-07-02', 'thaiha1998@gmail.com'   ), 
('KH05', N'Trần Thanh Tâm' , '045724647', '2000-01-19', 'thanhtam2000@gmail.com' ), 
('KH06', N'Trịnh Quốc Nam' , '097854990', '2001-03-03', 'quocnam2001@gmail.com'  ), 
('KH07', N'Nguyễn Thanh Hà', '012365672', '2002-09-12', 'thanhha2002@gmail.com'  ), 
('KH08', N'Phạm Vân Anh'   , '009562745', '2005-10-18', 'vananh2005@gmail.com'   ), 
('KH09', N'Lê Ngọc Yến'    , '014575775', '2005-12-30', 'ngocyen2005@gmail.com'  ), 
('KH10', N'Lee Kwang Soo'  , '084527456', '1999-11-11', 'kwangsoo1999@gmail.com' ) 

select * from KHACHHANG 

create table NGHESI 
( 
	MANGHESI char(10) primary key not null, 
	TENNGHESI nvarchar(100) not null, 
	CONGTY nvarchar(100), 
	SOLUONGBAIHAT int check (SOLUONGBAIHAT between 1 and 20)
); 


insert into NGHESI values  
('BP' , N'BLACK PINK'        , N'YG Entertainment'    , 15), 
('BTS', N'BANGTANSONYEONDAN' , N'HYPE Entertainment'  , 20), 
('TW' , N'TWICE'             , N'JYP Entertainment'   , 17), 
('IU' , N'LEE JIEUN'         , N'KAKAO Entertainment' , 18), 
('AE' , N'AESPA'             , N'SM Entertainment'    , 18) 

select * from NGHESI 

create table BUOIDIEN 
( 
	MABUOIDIEN char(10) PRIMARY KEY not null, 
	MANGHESI char(10) REFERENCES NGHESI(MANGHESI), 
	MADIADIEM char(10) not null,
	THOIGIANBD smalldatetime not null, 
	DOANHTHU money,
	constraint BD1 unique (MADIADIEM, THOIGIANBD),
	constraint BD2 unique (THOIGIANBD, MANGHESI),
	constraint FK_BD_DD foreign key (MADIADIEM) references DIADIEM (MADIADIEM)
	on update cascade
);

insert into BUOIDIEN values 
('BD01', 'BP' , 'DD01', '2022-07-10 07:00:00',0),  
('BD02', 'BTS', 'DD02', '2022-07-10 13:00:00',0), 
('BD03', 'TW' , 'DD03', '2022-07-10 18:00:00',0), 
('BD04', 'IU' , 'DD04', '2022-07-11 07:00:00',0), 
('BD05', 'AE' , 'DD05', '2022-07-12 18:00:00',0) 
select * from BUOIDIEN 
create table KIEUDAT 
( 
	MAKIEUDAT char(10) primary key not null,
	TENKIEUDAT nvarchar(50) not null 
);

insert into KIEUDAT values 
('KD01', N'Trên web'),
('KD02', N'Tại quầy')

select * from KIEUDAT

create table GHEDADAT
( 
    STT int primary key not null, 
    MAGHE int references GHE(MAGHE) not null,
    MABUOIDIEN char(10) references BUOIDIEN(MABUOIDIEN) not null,
	MAKHACHHANG char(10) references KHACHHANG(MAKHACHHANG) not null,
	MAKIEUDAT char(10) references KIEUDAT(MAKIEUDAT) not null,
	THOIGIANDAT smalldatetime not null,
	TRANGTHAI nvarchar(50) not null check (TRANGTHAI in (N'Chưa thanh toán', N'Đã thanh toán')),
	constraint GDD unique (MABUOIDIEN,MAKHACHHANG,MAGHE)
); 

--Insert dữ liệu khách mua online 

--Chưa thanh toán
insert into GHEDADAT values  
(1 , '1' , 'BD01', 'KH01', 'KD01', '2022-04-12 22:27:20', N'Chưa thanh toán'), 			   		   					   					   					 	 			  		   		 			   
(5 , '15', 'BD01', 'KH09', 'KD01', '2022-04-13 11:33:00', N'Chưa thanh toán'), 	 			 		   		 			
(12, '21', 'BD02', 'KH10', 'KD01', '2022-04-12 22:40:00', N'Chưa thanh toán'),	 			   		   					    
(16, '35', 'BD03', 'KH08', 'KD01', '2022-04-12 21:30:00', N'Chưa thanh toán'),				    	   		 			    
(20, '71', 'BD05', 'KH07', 'KD01', '2022-04-12 19:10:50', N'Chưa thanh toán')
--select * from GHEDADAT 

--Đã thanh toán
insert into GHEDADAT values 
(6 , '7' , 'BD01', 'KH02', 'KD01', '2022-04-07 15:07:20', N'Đã thanh toán'), 				   		   		 			    
(11, '19', 'BD02', 'KH08', 'KD01', '2022-04-07 16:40:00', N'Đã thanh toán'), 	 			  		   					    
(15, '31', 'BD03', 'KH07', 'KD01', '2022-04-08 20:00:17', N'Đã thanh toán'), 				    	   		  			    
(19, '70', 'BD05', 'KH03', 'KD01', '2022-04-07  8:10:00', N'Đã thanh toán'), 				  		   		  			    
(2 , '2' , 'BD01', 'KH03', 'KD01', '2022-04-07 12:01:00', N'Đã thanh toán')
--select * from GHEDADAT 

--Insert dữ liệu khách mua offline 
insert into GHEDADAT values  
(3 , '3' , 'BD01', 'KH05', 'KD02', '2022-04-08 15:10:00', N'Đã thanh toán'),		  		 					 
(4 , '9' , 'BD01', 'KH07', 'KD02', '2022-04-08  9:09:00', N'Đã thanh toán'),
(7 , '13', 'BD01', 'KH04', 'KD02', '2022-04-08 14:30:00', N'Đã thanh toán'),			   		   					    
(8 , '10', 'BD01', 'KH06', 'KD02', '2022-04-08 14:30:44', N'Đã thanh toán'),			   		   					    
(9 , '17', 'BD02', 'KH01', 'KD02', '2022-04-08 16:05:30', N'Đã thanh toán'),			   		   					    
(10, '20', 'BD02', 'KH06', 'KD02', '2022-04-08 10:22:20', N'Đã thanh toán'),					   					    
(13, '23', 'BD02', 'KH03', 'KD02', '2022-04-08  8:00:09', N'Đã thanh toán'), 			  		   		  			    
(14, '42', 'BD03', 'KH05', 'KD02', '2022-04-08 13:09:00', N'Đã thanh toán'), 
(17, '51', 'BD04', 'KH06', 'KD02', '2022-04-08 20:23:00', N'Đã thanh toán'),			    	   		  			    
(18, '54', 'BD04', 'KH10', 'KD02', '2022-04-08 13:05:00', N'Đã thanh toán')	   		   		  			    
--delete GHEDADAT
select * from GHEDADAT 

create table VE
( 
	MAVE char (10) primary key not null, 
	MANVTHUNGAN char (10) references NHANVIENTHUNGAN(MANHANVIEN) , 
	MAKHACHHANG char (10) references KHACHHANG(MAKHACHHANG) not null,
	STTDATGHE int,
	THOIGIANXUATVE smalldatetime not null,
	TINHTRANG nvarchar(50) check (TINHTRANG in (null,N'Hoàn Thành',N'Đã hủy',N'Lỗi')),
	GIAVE money,
	constraint FK_VE_STTDATGHE foreign key (STTDATGHE) references GHEDADAT(STT)
	on delete set null
);

insert into VE values
('V00001', 'NV02','KH03',2 ,'2022-04-08 15:01:00',N'Hoàn Thành',0 ),
('V00002', 'NV03','KH05',3 ,'2022-04-08 15:10:00',N'Hoàn Thành',0 ),
('V00003', 'NV04','KH07',4 ,'2022-04-08  9:09:00',N'Hoàn Thành',0 ),
('V00004', 'NV06','KH02',6 ,'2022-04-08 20:07:20',N'Hoàn Thành',0 ),
('V00005', 'NV07','KH04',7 ,'2022-04-08 14:30:00',N'Hoàn Thành',0 ),
('V00006', 'NV05','KH06',8 ,'2022-04-08 14:30:44',N'Hoàn Thành',0 ),
('V00007', 'NV09','KH01',9 ,'2022-04-08 16:05:30',N'Hoàn Thành',0 ),
('V00008', 'NV01','KH06',10,'2022-04-08 10:22:20',N'Hoàn Thành',0 ),
('V00009', 'NV06','KH08',11,'2022-04-08 21:40:00',N'Hoàn Thành',0 ),
('V00010', 'NV04','KH03',13,'2022-04-08  8:00:09',N'Hoàn Thành',0 ),
('V00011', 'NV05','KH05',14,'2022-04-08 13:09:00',N'Hoàn Thành',0 ),
('V00012', 'NV06','KH07',15,'2022-04-08 22:00:17',N'Hoàn Thành',0 ),
('V00013', 'NV08','KH06',17,'2022-04-08 20:23:00',N'Hoàn Thành',0 ),
('V00014', 'NV09','KH10',18,'2022-04-08 13:05:00',N'Hoàn Thành',0 ),
('V00015', 'NV01','KH03',19,'2022-04-08 10:10:00',N'null',0)


--select * from VE
--delete from VE
--delete from GHEDADAT where  STT=2

UPDATE VE
    SET GIAVE = 1000000
FROM 
 dbo.GHE INNER JOIN
                  dbo.GHEDADAT ON dbo.GHE.MAGHE = dbo.GHEDADAT.MAGHE INNER JOIN
                  dbo.VE ON dbo.GHEDADAT.STT = dbo.VE.STTDATGHE
WHERE LOAIGHE=N'THƯỜNG'
UPDATE VE
    SET GIAVE = 2000000
FROM 
 dbo.GHE INNER JOIN
                  dbo.GHEDADAT ON dbo.GHE.MAGHE = dbo.GHEDADAT.MAGHE INNER JOIN
                  dbo.VE ON dbo.GHEDADAT.STT = dbo.VE.STTDATGHE
WHERE LOAIGHE=N'VIP'
select * from VE

-- Tạo database 

create database KPOPTOUR; 
drop database KPOPTOUR 
use KPOPTOUR 


-- Tạo các bảng 
create table DIADIEM
( 
	MADIADIEM char(10) primary key not null, 
    TENDIADIEM nvarchar(100) not null, 
    DIACHI nvarchar(50) not null, 
    SODIENTHOAI varchar(12) check(SODIENTHOAI not like '%[^0-9]%') not null, 
	SOLUONGGHE int
); 

 

create table GHE  
( 
	MAGHE char (10) primary key not null,
	GHE char(10) not null, 		
	HANG char(10) not null, 
	VITRI char(10) not null, 	
	MADIADIEM char(10) references DIADIEM(MADIADIEM) not null, 
	LOAIGHE nvarchar(50) not null,
);

--DROP TABLE GHE 

create table NHANVIENTHUNGAN 
( 
    MANHANVIEN char(10) primary key not null, 
    TEN nvarchar(100) not null, 
    SODIENTHOAI varchar(12) check(SODIENTHOAI not like '%[^0-9]%') not null, 
    NGAYSINH smalldatetime  not null 
); 

 

create table DAMNHIEM 
( 
	MANHANVIEN char(10) references NHANVIENTHUNGAN(MANHANVIEN) not null, 
	CATRUC int not null 
);

 

create table KHACHHANG 
( 
    MAKHACHHANG  char(10) primary key not null,
    TENKHACHHANG nvarchar(50) not null, 
    SODIENTHOAI varchar(12) check(SODIENTHOAI not like '%[^0-9]%') not null, 
    NGAYSINH smalldatetime not null, 
    EMAIL nvarchar (50) not null, 
); 

 

create table NGHESI 
( 
	MANGHESI char(10) primary key not null, 
	TENNGHESI nvarchar(100) not null, 
	CONGTY nvarchar(100), 
	SOLUONGBAIHAT int 
); 

 

create table BUOIDIEN 
( 
	MABUOIDIEN char(10) PRIMARY KEY not null, 
	MANGHESI char(10) REFERENCES NGHESI(MANGHESI), 
	MADIADIEM char(10) REFERENCES DIADIEM(MADIADIEM), 
	THOIGIANBD time not null, 
	SOLUONGVEDABAN int 
) 


create table KIEUDAT 
( 
	MAKIEUDAT char(10) primary key not null, 
	TENKIEUDAT nvarchar(50) not null 
);




create table GHEDADAT
( 
    STT int primary key not null, 
    MAGHE char (10) references GHE(MAGHE) not null, 
    MABUOIDIEN char(10) references BUOIDIEN(MABUOIDIEN) not null,
	MAKHACHHANG char(10) references KHACHHANG(MAKHACHHANG) not null,
	MAKIEUDAT char(10) references KIEUDAT(MAKIEUDAT) not null,
	THOIGIANDAT smalldatetime not null,
	TRANGTHAI nvarchar(50) default (N'Chưa thanh toán') not null
); 

create table VE
( 
	MAVE char (10) primary key not null, 
	MANVTHUNGAN char (10) references NHANVIENTHUNGAN(MANHANVIEN) not null, 
	MAKHACHHANG char (10) references KHACHHANG(MAKHACHHANG) not null,
	STTDATGHE int references GHEDADAT(STT),
	THOIGIANXUATVE smalldatetime not null,
	TINHTRANG nvarchar(50) default (N'Hoàn thành'),
	GIAVE money
);
--drop VE
-- Insert dữ liệu

insert into KIEUDAT values 
('KD01', N'Trên web'),
('KD02', N'Tại quầy')
select * from KIEUDAT


insert into DIADIEM values  
('DD01', N'Trường đại học Kinh tế Quốc dân', N'207 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'   , '02436280280', 9400),  
('DD02', N'Trường đại học Bách Khoa Hà Nội', N'1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội'   , '02436231732', 8500),  
('DD03', N'Trường đại học Xây Dựng'        , N'55 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'    , '02438630001', 9000),  
('DD04', N'Trường đại học Mở Hà Nội'       , N'B101 Nguyễn Hiền, Bách Khoa, Hai Bà Trưng, Hà Nội', '02438682321', 7800),  
('DD05', N'Học viện Tài chính'             , N'56 Văn Hiến, Đông Ngạc, Bắc Từ Liêm, Hà Nội'      , '02438362161', 8900)  
select * from DIADIEM 


insert into GHE values
('1' ,'1A', 'A', '1', 'DD01',N'VIP'),
('2' ,'2A', 'A', '2', 'DD01',N'VIP'),
('3' ,'3A', 'A', '3', 'DD01',N'VIP'),
('4' ,'4A', 'A', '4', 'DD01',N'VIP'),
('5' ,'5A', 'A', '5', 'DD01',N'VIP'),
('6' ,'1B', 'B', '1', 'DD01',N'THƯỜNG'),
('7' ,'2B', 'B', '2', 'DD01',N'THƯỜNG'),
('8' ,'3B', 'B', '3', 'DD01',N'THƯỜNG'),
('9' ,'4B', 'B', '4', 'DD01',N'THƯỜNG'),
('10','5B', 'B', '5', 'DD01',N'THƯỜNG'),
('11','1C', 'C', '1', 'DD01',N'THƯỜNG'),
('12','2C', 'C', '2', 'DD01',N'THƯỜNG'),
('13','3C', 'C', '3', 'DD01',N'THƯỜNG'),
('14','4C', 'C', '4', 'DD01',N'THƯỜNG'),
('15','5C', 'C', '5', 'DD01',N'THƯỜNG'),
('16','1A', 'A', '1', 'DD02',N'VIP'),
('17','2A', 'A', '2', 'DD02',N'VIP'),
('18','3A', 'A', '3', 'DD02',N'VIP'),
('19','4A', 'A', '4', 'DD02',N'VIP'),
('20','5A', 'A', '5', 'DD02',N'VIP'),
('21','1B', 'B', '1', 'DD02',N'THƯỜNG'),
('22','2B', 'B', '2', 'DD02',N'THƯỜNG'),
('23','3B', 'B', '3', 'DD02',N'THƯỜNG'),
('24','4B', 'B', '4', 'DD02',N'THƯỜNG'),
('25','5B', 'B', '5', 'DD02',N'THƯỜNG'),
('26','1C', 'C', '1', 'DD02',N'THƯỜNG'),
('27','2C', 'C', '2', 'DD02',N'THƯỜNG'),
('28','3C', 'C', '3', 'DD02',N'THƯỜNG'),
('29','4C', 'C', '4', 'DD02',N'THƯỜNG'),
('30','5C', 'C', '5', 'DD02',N'THƯỜNG'),
('31','1A', 'A', '1', 'DD03',N'VIP'),
('32','2A', 'A', '2', 'DD03',N'VIP'),
('33','3A', 'A', '3', 'DD03',N'VIP'),
('34','4A', 'A', '4', 'DD03',N'VIP'),
('35','5A', 'A', '5', 'DD03',N'VIP'),
('36','1B', 'B', '1', 'DD03',N'THƯỜNG'),
('37','2B', 'B', '2', 'DD03',N'THƯỜNG'),
('38','3B', 'B', '3', 'DD03',N'THƯỜNG'),
('39','4B', 'B', '4', 'DD03',N'THƯỜNG'),
('40','5B', 'B', '5', 'DD03',N'THƯỜNG'),
('41','1C', 'C', '1', 'DD03',N'THƯỜNG'),
('42','2C', 'C', '2', 'DD03',N'THƯỜNG'),
('43','3C', 'C', '3', 'DD03',N'THƯỜNG'),
('44','4C', 'C', '4', 'DD03',N'THƯỜNG'),
('45','5C', 'C', '5', 'DD03',N'THƯỜNG'),
('46','1A', 'A', '1', 'DD04',N'VIP'),
('47','2A', 'A', '2', 'DD04',N'VIP'),
('48','3A', 'A', '3', 'DD04',N'VIP'),
('49','4A', 'A', '4', 'DD04',N'VIP'),
('50','5A', 'A', '5', 'DD04',N'VIP'),
('51','1B', 'B', '1', 'DD04',N'THƯỜNG'),
('52','2B', 'B', '2', 'DD04',N'THƯỜNG'),
('53','3B', 'B', '3', 'DD04',N'THƯỜNG'),
('54','4B', 'B', '4', 'DD04',N'THƯỜNG'),
('55','5B', 'B', '5', 'DD04',N'THƯỜNG'),
('56','1C', 'C', '1', 'DD04',N'THƯỜNG'),
('57','2C', 'C', '2', 'DD04',N'THƯỜNG'),
('58','3C', 'C', '3', 'DD04',N'THƯỜNG'),
('59','4C', 'C', '4', 'DD04',N'THƯỜNG'),
('60','5C', 'C', '5', 'DD04',N'THƯỜNG'),
('61','1A', 'A', '1', 'DD05',N'VIP'),
('62','2A', 'A', '2', 'DD05',N'VIP'),
('63','3A', 'A', '3', 'DD05',N'VIP'),
('64','4A', 'A', '4', 'DD05',N'VIP'),
('65','5A', 'A', '5', 'DD05',N'VIP'),
('66','1B', 'B', '1', 'DD05',N'THƯỜNG'),
('67','2B', 'B', '2', 'DD05',N'THƯỜNG'),
('68','3B', 'B', '3', 'DD05',N'THƯỜNG'),
('69','4B', 'B', '4', 'DD05',N'THƯỜNG'),
('70','5B', 'B', '5', 'DD05',N'THƯỜNG'),
('71','1C', 'C', '1', 'DD05',N'THƯỜNG'),
('72','2C', 'C', '2', 'DD05',N'THƯỜNG'),
('73','3C', 'C', '3', 'DD05',N'THƯỜNG'),
('74','4C', 'C', '4', 'DD05',N'THƯỜNG'),
('75','5C', 'C', '5', 'DD05',N'THƯỜNG')

select * from GHE 


 

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

 

insert into NGHESI values  
('BP' , N'BLACK PINK'        , N'YG Entertainment'    , 15), 
('BTS', N'BANGTANSONYEONDAN' , N'HYPE Entertainment'  , 20), 
('TW' , N'TWICE'             , N'JYP Entertainment'   , 17), 
('IU' , N'LEE JIEUN'         , N'KAKAO Entertainment' , 18), 
('AE' , N'AESPA'             , N'SM Entertainment'    , 18) 
select * from NGHESI 

 

 

insert into BUOIDIEN values 
('BD01', 'BP' , 'DD01', '2022-06-10 07:00:00', 0),  
('BD02', 'BTS', 'DD02', '2022-06-10 13:00:00', 0), 
('BD03', 'TW' , 'DD03', '2022-06-10 18:00:00', 0), 
('BD04', 'IU' , 'DD04', '2022-06-11 07:00:00', 0), 
('BD05', 'AE' , 'DD05', '2022-06-12 18:00:00', 0) 
select * from BUOIDIEN 

 

 

 

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



insert into GHEDADAT values  
(1 , '1' , 'BD01', 'KH01', 'KD01', '2022-06-01', N'Chưa thanh toán'), 			   		   					   
(2 , '2' , 'BD01', 'KH03', 'KD01', '2022-06-02', N'Đã thanh toán'), 					   					
(3 , '3' , 'BD01', 'KH05', 'KD02', '2022-06-04', N'Đã thanh toán'), 			  		 					 
(4 , '9' , 'BD01', 'KH07', 'KD02', '2022-06-01', N'Chưa thanh toán'), 	 			  		   		 			   
(5 , '15', 'BD01', 'KH09', 'KD01', '2022-06-06', N'Chưa thanh toán'), 	 			 		   		 			
(6 , '7' , 'BD01', 'KH02', 'KD01', '2022-06-01', N'Đã thanh toán'), 				   		   		 			    
(7 , '13', 'BD01', 'KH04', 'KD02', '2022-06-01', N'Đã thanh toán'), 				   		   					    
(8 , '10', 'BD01', 'KH06', 'KD02', '2022-06-01', N'Chưa thanh toán'), 				   		   					    
(9 , '17', 'BD02', 'KH01', 'KD02', '2022-06-02', N'Chưa thanh toán'),				   		   					    
(10, '20', 'BD02', 'KH06', 'KD02', '2022-06-04', N'Đã thanh toán'), 						   					    
(11, '19', 'BD02', 'KH08', 'KD01', '2022-06-01', N'Đã thanh toán'), 	 			  		   					    
(12, '21', 'BD02', 'KH10', 'KD01', '2022-06-06', N'Chưa thanh toán'),	 			   		   					    
(13, '23', 'BD02', 'KH03', 'KD02', '2022-06-01', N'Chưa thanh toán'),	 			  		   		  			    
(14, '42', 'BD03', 'KH05', 'KD02', '2022-06-01', N'Đã thanh toán'), 	 			    	   		 			    
(15, '31', 'BD03', 'KH07', 'KD01', '2022-06-02', N'Đã thanh toán'), 				    	   		  			    
(16, '35', 'BD03', 'KH08', 'KD01', '2022-06-04', N'Chưa thanh toán'),				    	   		 			    
(17, '51', 'BD04', 'KH06', 'KD02', '2022-06-01', N'Chưa thanh toán'),				    	   		  			    
(18, '54', 'BD04', 'KH10', 'KD02', '2022-06-06', N'Đã thanh toán'), 				   		   		  			    
(19, '70', 'BD05', 'KH03', 'KD01', '2022-06-01', N'Đã thanh toán'), 				  		   		  			    
(20, '71', 'BD05', 'KH07', 'KD01', '2022-06-01', N'Chưa thanh toán')
select * from GHEDADAT 



insert into VE values
('V01', 'NV01','KH03',2 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V02', 'NV02','KH05',3 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V03', 'NV03','KH02',6 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V04', 'NV04','KH04',7 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V05', 'NV05','KH06',10 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V06', 'NV06','KH08',11 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V07', 'NV07','KH05',14 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V08', 'NV08','KH07',15 ,'2022-06-08 20:00:00',N'Hoàn Thành',0),
('V09', 'NV09','KH10',18 ,'2022-06-08 20:00:00',N'Hoàn Thành',0)
select * from VE
delete VE

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
 
-- Hiển thị thông tin buổi diễn
-- "Tên địa điểm, địa điểm, mã buổi diễn, tên nghệ sĩ, slg bài hát, thời gian bắt đầu
-- Select view nghệ sĩ tự chọn"
create view V_TONGHOPBUOIDIEN
as
	select TENDIADIEM as [Tên địa điểm],
		   DIACHI as [Địa chỉ],
		   BUOIDIEN.MABUOIDIEN as [Mã buổi diễn],
		   TENNGHESI as [Tên nghệ sĩ],
		   SOLUONGBAIHAT as [Số lượng bài hát],
		   THOIGIANBD as [Thời gian bắt đầu]
	from BUOIDIEN,DIADIEM,NGHESI
	where DIADIEM.MADIADIEM = BUOIDIEN.MADIADIEM
	  and BUOIDIEN.MANGHESI = NGHESI.MANGHESI

select * from V_TONGHOPBUOIDIEN
select * from V_TONGHOPBUOIDIEN where [Tên nghệ sĩ] = 'BLACK PINK'

--drop view V_TONGHOPBUOIDIEN


-- Tổng hợp nhân viên
-- Hiện thị thông tin mã nhân viên, tên nhân viên, mã chức vụ, tên chức vụ
create view V_TONGHOPNHANVIEN
as
	select NHANVIENTHUNGAN.MANHANVIEN as [Mã nhân viên],
		   TEN as [Tên],
		   SODIENTHOAI as [Số điện thoại],
		   NGAYSINH as [ Ngày sinh ],
		   CATRUC as [ Ca Trực ]
	from NHANVIENTHUNGAN, DAMNHIEM
	where NHANVIENTHUNGAN.MANHANVIEN = DAMNHIEM.MANHANVIEN

select * from V_TONGHOPNHANVIEN
select * from V_TONGHOPNHANVIEN where [Mã nhân viên] = 'NV06'




-- TH Vé buổi diễn (KH, vé, BD)
-- Tên khách hàng, SDT, mã vé, mã BD, thời gian bắt đầu. Select khách hàng buổi biểu diễn 1 
create view V_TONGHOPKHACHHANGCUABUOIDIEN  
as  
	select KHACHHANG.MAKHACHHANG as [Mã khách hàng], 
		   TENKHACHHANG as [Tên khách hàng], 
		   SODIENTHOAI as [Số điện thoại],
		   VE.MAVE as [Mã vé], 
		   GHEDADAT.MABUOIDIEN as [Mã buổi diễn], 
		   THOIGIANBD as [Thời gian bắt đầu] 
	from KHACHHANG, VE, BUOIDIEN, GHEDADAT
	where VE.STTDATGHE = GHEDADAT.STT
	  and KHACHHANG.MAKHACHHANG = GHEDADAT.MAKHACHHANG
	  and GHEDADAT.MABUOIDIEN = BUOIDIEN.MABUOIDIEN

select * from V_TONGHOPKHACHHANGCUABUOIDIEN
select * from V_TONGHOPKHACHHANGCUABUOIDIEN where [Mã buổi diễn] = 'BD01' 

--drop view V_TONGHOPKHACHHANGCUABUOIDIEN

--View Vé 
create view V_THVEGHEKHACHHANG
as 
    select VE.MAVE as [Mã Vé],
           KHACHHANG.MAKHACHHANG as [Mã Khách Hàng],
           KHACHHANG.TENKHACHHANG as [Tên Khách Hàng],
           GHE.GHE as [Ghế],
           KHACHHANG.SODIENTHOAI as [Số Điện Thoại],
           DIADIEM.TENDIADIEM as [Tên Địa Điểm],
           GHE.LOAIGHE as [Loại Ghế]

    from KHACHHANG, VE, DIADIEM, GHE, GHEDADAT
    where KHACHHANG.MAKHACHHANG = VE.MAKHACHHANG  
	and GHEDADAT.MAGHE = GHE.MAGHE 
	and VE.STTDATGHE = GHEDADAT.STT 
	and DIADIEM.MADIADIEM = GHE.MADIADIEM ;

select * from V_THVEGHEKHACHHANG
select * from V_THVEGHEKHACHHANG where [Loại Ghế] = 'Vip'
--drop view V_THVEGHEKHACHHANG

 -- Thông tin địa điểm

create view V_ThongTinDiaDiem ([DiaDiem],[Ghe],[GheDaDat],[GheConTrong])
as
select DIADIEM.TENDIADIEM,DIADIEM.SOLUONGGHE,COUNT(GHE.MAGHE),DIADIEM.SOLUONGGHE-COUNT(GHE.MAGHE)
from DIADIEM,BUOIDIEN,GHEDADAT,GHE
where GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN and (GHEDADAT.MAGHE=GHE.MAGHE and GHE.MADIADIEM=DIADIEM.MADIADIEM)
group by TENDIADIEM,SOLUONGGHE
select * from V_ThongTinDiaDiem
 

create view V_ThongTinBuoiDien([DiaDiem],[Ghe],[GheDaDat],[GheConTrong],[MaBuoiDien])
as
select DiaDiem,Ghe,GheDaDat,GheConTrong,MABUOIDIEN
from V_ThongTinDiaDiem,BUOIDIEN,DIADIEM
where V_ThongTinDiaDiem.DiaDiem=DIADIEM.TENDIADIEM and BUOIDIEN.MADIADIEM=DIADIEM.MADIADIEM

select * from V_ThongTinBuoiDien;

 

create view V_ThongTinGheChuaDat 
as
select BUOIDIEN.MABUOIDIEN,GHE.MAGHE,GHE.GHE,HANG,VITRI,GHE.MADIADIEM,LOAIGHE
from GHE,BUOIDIEN,GHEDADAT
where (GHE.MAGHE not in (select MAGHE from GHEDADAT) and GHE.MADIADIEM=BUOIDIEN.MADIADIEM)
group by BUOIDIEN.MABUOIDIEN,GHE.MAGHE,GHE.GHE,HANG,VITRI,GHE.MADIADIEM,LOAIGHE
select *from V_ThongTinGheChuaDat

create proc P_SOVEDABAN @mabuoidien char(10)
as
    begin
        select count(*) as [Số vé đã bán]
        from GHEDADAT
        where @mabuoidien = MABUOIDIEN
    end
exec P_SOVEDABAN 'BD01'
exec P_SOVEDABAN 'BD02'
exec P_SOVEDABAN 'BD03'
exec P_SOVEDABAN 'BD04'
exec P_SOVEDABAN 'BD05'
create proc p_NS @maNS char(10)
as
begin
    Select *
    from NGHESI
    where NGHESI.MANGHESI like @maNS
end;

exec p_NS '%T%';
exec p_NS '%b%';

create proc sp_TinhSoKhachChuaThanhToan @mabuoidien char(10)
as    
	begin 
        select COUNT(*) as [Số khách hàng chưa thanh toán]
		from GHEDADAT 
		where @mabuoidien = MABUOIDIEN and TRANGTHAI=N'Chưa thanh toán'
	end
go
exec sp_TinhSoKhachChuaThanhToan 'BD04'
drop proc sp_TinhSoKhachChuaThanhToan 
create proc sp_dsghedd @madiadiem char (10)
as 
	begin 
		select *
		from GHE
		where @madiadiem = MADIADIEM
	end 
go
exec sp_dsghedd 'DD01'
alter proc sp_timkhachhang @mabuoidien char(10), @ghe char(10)
as 
	select TENKHACHHANG
	from GHEDADAT,KHACHHANG,GHE
	where
	@ghe=GHE.GHE and GHE.MAGHE=GHEDADAT.MAGHE and
	@mabuoidien=GHEDADAT.MABUOIDIEN
	and GHEDADAT.MAKHACHHANG=KHACHHANG.MAKHACHHANG
exec sp_timkhachhang 'BD04','4B'
select * from V_THVEGHEKHACHHANG
select * from V_TONGHOPKHACHHANGCUABUOIDIEN



 








 

 

 

 

 

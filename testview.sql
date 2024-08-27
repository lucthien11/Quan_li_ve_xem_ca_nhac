-- Tạo view hiển thị danh sách ghế trong buổi diễn
create view V_TONGHOPGHEBUOIDIEN
as
select BUOIDIEN.MABUOIDIEN,GHE.MAGHE,GHE.GHE,HANG,VITRI,GHE.MADIADIEM,LOAIGHE
from BUOIDIEN, GHE, DIADIEM
where BUOIDIEN.MADIADIEM = DIADIEM.MADIADIEM and DIADIEM.MADIADIEM = GHE.MADIADIEM
group by BUOIDIEN.MABUOIDIEN,GHE.MAGHE,GHE.GHE,HANG,VITRI,GHE.MADIADIEM,LOAIGHE
insert into BUOIDIEN values ('BD07', 'TW' , 'DD05', '2022-06-11 07:00:00',0)
select * from V_TONGHOPGHEBUOIDIEN
select * from V_TONGHOPGHEBUOIDIEN where MABUOIDIEN='BD07'

-- Tạo view hiển thị danh ghế chưa đặt trong buổi diễn

create view V_ThongTinGheChuaDat 
as
select V_TONGHOPGHEBUOIDIEN.MABUOIDIEN,V_TONGHOPGHEBUOIDIEN.MAGHE,GHE,HANG,VITRI,MADIADIEM,LOAIGHE
from V_TONGHOPGHEBUOIDIEN, GHEDADAT
where (V_TONGHOPGHEBUOIDIEN.MAGHE not in (select MAGHE from GHEDADAT where V_TONGHOPGHEBUOIDIEN.MABUOIDIEN = GHEDADAT.MABUOIDIEN and V_TONGHOPGHEBUOIDIEN.MAGHE = GHEDADAT.MAGHE))
group by V_TONGHOPGHEBUOIDIEN.MABUOIDIEN,V_TONGHOPGHEBUOIDIEN.MAGHE,GHE,HANG,VITRI,V_TONGHOPGHEBUOIDIEN.MADIADIEM,LOAIGHE

select * from GHEDADAT
select * from V_ThongTinGheChuaDat
select * from V_ThongTinGheChuaDat where MABUOIDIEN='BD07'
select * from GHE where MADIADIEM='DD05' 
-- Hiển thị thông tin buổi diễn
-- "Tên địa điểm, địa điểm, mã buổi diễn, tên nghệ sĩ, slg bài hát, thời gian bắt đầu
-- Select view nghệ sĩ tự chọn"
create view V_TONGHOPBUOIDIEN
as
	select BUOIDIEN.MABUOIDIEN as [Mã buổi diễn],
		   TENDIADIEM as [Tên địa điểm],
		   DIACHI as [Địa chỉ],
		   TENNGHESI as [Tên nghệ sĩ],
		   SOLUONGBAIHAT as [Số lượng bài hát],
		   THOIGIANBD as [Thời gian bắt đầu]
from BUOIDIEN,DIADIEM,NGHESI
where DIADIEM.MADIADIEM = BUOIDIEN.MADIADIEM
	  and BUOIDIEN.MANGHESI = NGHESI.MANGHESI
insert into BUOIDIEN values ('BD06', 'IU' , 'DD03', '2022-06-11 07:00:00')

select * from V_TONGHOPBUOIDIEN
select * from V_TONGHOPBUOIDIEN where [Tên nghệ sĩ] = 'LEE JIEUN'

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
SELECT name FROM SYS.VIEWS

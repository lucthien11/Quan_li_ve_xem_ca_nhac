--Đưa ra các thông tin về nghệ sĩ với đầu vào dữ liệu là mã nghệ sĩ 
create proc p_NS @maNS char(10)
as
begin
    Select *
    from NGHESI
    where NGHESI.MANGHESI like @maNS
end;

exec p_NS '%T%';
exec p_NS '%b%';

--Tính số KH chưa thanh toán với đầu vào dữ lệu là mã BD
create proc sp_TinhSoKhachChuaThanhToan @mabuoidien char(10)
as    
	begin 
        select count (*) as [Số khách hàng chưa thanh toán]
		from GHEDADAT 
		where @mabuoidien = MABUOIDIEN and TRANGTHAI=N'Chưa thanh toán'
	end
go
exec sp_TinhSoKhachChuaThanhToan 'BD05'
--drop proc sp_TinhSoKhachChuaThanhToan 
--select * from GHEDADAT

--Lập thủ tục đưa ra danh sách ghế với các thông tin mã ghế, tên ghế, loại ghế với tham số đầu vào là mã địa điểm
create proc sp_dsghedd @madiadiem char (10)
as 
	begin 
		select *
		from GHE
		where @madiadiem = MADIADIEM
	end 
go
exec sp_dsghedd 'DD01'

--Đưa ra thông tin khách hàng với tham số đầu vào là MBD và Ghế
create proc sp_Timkhachhang
@MABUOIDIEN char(10),
@GHE char(10)
as
begin
    select
       KHACHHANG.MAKHACHHANG as [Mã Khách Hàng], KHACHHANG.TENKHACHHANG as [Tên Khách Hàng], KHACHHANG.SODIENTHOAI as [Số điện Thoại], KHACHHANG.NGAYSINH as [Ngày Sinh], KHACHHANG.EMAIL
    from
       KHACHHANG,GHEDADAT,GHE
    where
		@ghe=GHE.GHE and GHE.MAGHE=GHEDADAT.MAGHE and @mabuoidien=GHEDADAT.MABUOIDIEN and GHEDADAT.MAKHACHHANG=KHACHHANG.MAKHACHHANG
end
exec sp_Timkhachhang 'BD04','4B'
select * from V_THVEGHEKHACHHANG
select * from V_TONGHOPKHACHHANGCUABUOIDIEN
drop proc sp_Timkhachhang

--Lập thủ tục tính số vé thực bán (số vé ở tình trạng đã hoàn thành)
create proc P_SOVEDABAN @mabuoidien char(10)
as
    begin
        select count(*) as [Số vé đã bán]
        from VE, GHEDADAT
        where @mabuoidien = GHEDADAT.MABUOIDIEN and VE.TINHTRANG = N'Hoàn thành' and GHEDADAT.STT=VE.STTDATGHE
		group by GHEDADAT.MABUOIDIEN
    end
exec P_SOVEDABAN 'BD01'
exec P_SOVEDABAN 'BD02'
exec P_SOVEDABAN 'BD03'
exec P_SOVEDABAN 'BD04'
exec P_SOVEDABAN 'BD05'
exec P_SOVEDABAN 'BD06'

--Lập thủ tục xếp loại khách hàng. Đầu vào là mã khách hàng đầu ra là xếp loại theo quy định: <3tr Hạng đồng, [3;5]tr Hạng bạc, >5 Hạng vàng
create proc sp_Ranking @makhachhang char(10)
as
begin
	declare @TONGTHANHTOAN money
	set @TONGTHANHTOAN= (select sum(GIAVE) from VE,KHACHHANG where VE.MAKHACHHANG=KHACHHANG.MAKHACHHANG and KHACHHANG.MAKHACHHANG=@makhachhang)
	if (@TONGTHANHTOAN<3000000)
		print N'Khách hàng xếp hạng đồng'
	else if(@TONGTHANHTOAN<5000000)
		print N'Khách hàng xếp hạng bạc'
	else if(@TONGTHANHTOAN>=5000000)
		print N'Khách hàng xếp hạn vàng'
	else
		print N'Không tìm thấy khách hàng'
end
exec sp_Ranking N'KH06'
exec sp_Ranking N'KH01'

select * from VE
--THỦ TỤC THÊM, SỬA, XÓA
----THÊM ĐỊA ĐIỂM----
create proc sp_ThemDiaDiem @madiadiem char(10), @tendiadiem nvarchar(100), @diachi nvarchar(50), @sodienthoai varchar(12), @soluongghe int
as
begin
    if(exists(select MADIADIEM,DIACHI from DIADIEM where @madiadiem=MADIADIEM or @diachi=DIACHI))
    print N'Không thể thêm địa điểm này'
    else if(@soluongghe<0)
        print N'Số lượng ghế không hợp lệ'
	else insert into DIADIEM values (@madiadiem,@tendiadiem,@diachi,@sodienthoai,@soluongghe)
end

exec sp_ThemDiaDiem 'DD06', N'Trường đại học Kinh tế Quốc dân', N'209 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'   , '02436280280', 0
delete from DIADIEM where MADIADIEM='DD06'
select * from DIADIEM

----SỬA ĐỊA ĐIỂM----
create proc sp_SuaDiaDiem @madiadiem char(10), @tendiadiem nvarchar(100), @diachi nvarchar(50), @sodienthoai varchar(12), @soluongghe int
as 
begin
    if (not exists(select MADIADIEM FROM DIADIEM WHERE MADIADIEM=@madiadiem ))
		print N'Không tồn tại địa điểm này để chỉnh sửa'
	else if(exists(select DIACHI from DIADIEM where @diachi=DIACHI and MADIADIEM<>@madiadiem))
		print N'Địa chỉ đã tồn tại'
    else if(@soluongghe<0)
        print N'Số lượng ghế không hợp lệ'
    else 
        update DIADIEM
        set TENDIADIEM=@tendiadiem, DIACHI=@diachi,SODIENTHOAI=@sodienthoai,SOLUONGGHE=@soluongghe
        where MADIADIEM=@madiadiem
end

select * from DIADIEM
exec sp_SuaDiaDiem 'DD02', N'Trường đại học Bách Khoa Hà Nội', N'1 Đại Cồ Việt, Bách Khoa, Hai Bà Trưng, Hà Nội'   , '02436231732', 15 
exec sp_SuaDiaDiem 'DD06', N'Trường đại học Kinh tế Quốc dân', N'207 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'   , '02436280280', 15 
exec sp_SuaDiaDiem 'DD06', N'Trường đại học Kinh tế Quốc dân', N'20 Giải Phóng, Đồng Tâm, Hai Bà Trưng, Hà Nội'   , '02436280280', 15 

----XÓA ĐỊA ĐIỂM----
create proc sp_XoaDiaDiem @madiadiem char(10)
as 
begin
    if (not exists(select MADIADIEM FROM DIADIEM WHERE MADIADIEM=@madiadiem))
    print N'Không tồn tại địa điểm này để xóa'
    else if(exists(select MADIADIEM from BUOIDIEN where MADIADIEM=@madiadiem))
        print N'Không thể xóa địa điểm này'
	else
		begin 
			if(exists(select MADIADIEM from GHE where MADIADIEM=@madiadiem))
				print N'Đã xóa địa điểm và ghế'
			delete from DIADIEM
			where MADIADIEM=@madiadiem
		end
end

insert into GHE values (80,'1A', 'A', '1', 'DD06',N'VIP')
exec sp_XoaDiaDiem 'DD06'

------ THêm khách hàng -------
create proc SP_THEMKHACHHANG (@MAKHACHHANG char(10) ,@TENKHACHHANG nvarchar(50), @SODIENTHOAI varchar(12),  @NGAYSINH date , @EMAIL nvarchar (50) )
as
   if exists ( select * from KHACHHANG where MAKHACHHANG = @MAKHACHHANG)
		print N'Khách hàng này đã có'
   else
		insert into KHACHHANG(MAKHACHHANG,TENKHACHHANG,SODIENTHOAI,NGAYSINH,EMAIL)
		values (@MAKHACHHANG ,@TENKHACHHANG,@SODIENTHOAI,@NGAYSINH,@EMAIL)
go
exec  SP_THEMKHACHHANG 'KH01', N'Trần Văn An'    , '027856427', '2002-08-12', 'vanan2002@gmail.com'  
exec  SP_THEMKHACHHANG 'KH11', N'Thien dep trai'    , '027856427', '2002-08-12', 'iu2002@gmail.com'  

---- Sửa khách hàng ------------
create proc SP_SUAKHACHHANG (@MAKHACHHANG char(10) ,@TENKHACHHANG nvarchar(50), @SODIENTHOAI varchar(12),  @NGAYSINH date , @EMAIL nvarchar (50) )
as
	if not exists ( select * from KHACHHANG where MAKHACHHANG = @MAKHACHHANG)  
		print N'Không có khách hàng này'
	else
		update KHACHHANG
		set TENKHACHHANG = @TENKHACHHANG , SODIENTHOAI = @SODIENTHOAI,NGAYSINH= @NGAYSINH, EMAIL=@EMAIL
		where MAKHACHHANG=@MAKHACHHANG
go
exec SP_SUAKHACHHANG  'KH01', N'Trần Văn An hehe'    , '027856427', '2002-08-12', 'vanan2002@gmail.com' 
exec SP_SUAKHACHHANG  'KH01', N'Trần Văn An'    , '027856427', '2002-08-12', 'vanan2002@gmail.com' 

--Lập thủ tục xoá khách hàng
create  proc SP_XOAKHACHHANG
 @MAKHACHHANG char(10)
as
begin
 if (exists (select GHEDADAT.MAKHACHHANG, VE.MAKHACHHANG from GHEDADAT, VE where @MAKHACHHANG=GHEDADAT.MAKHACHHANG or @MAKHACHHANG=VE.MAKHACHHANG))
             print N' Khách hàng này đã sử dụng dịch vụ không thể xóa được '
else 
 if ( not exists (select MAKHACHHANG from KHACHHANG where @MAKHACHHANG=MAKHACHHANG))
             print N' Khách hàng này không tồn tại trong bảng dữ liêu '
else delete from KHACHHANG 
      where MAKHACHHANG= @MAKHACHHANG
end
exec SP_XOAKHACHHANG 'KH10'
exec SP_XOAKHACHHANG 'KH12'
insert into KHACHHANG values
('KH12', N'Trần Ngọc Hồng'    , '025556427', '2000-08-12', 'ngochong2000@gmail.com'    ) 
select * from KHACHHANG
select * from VE
select * from GHEDADAT

---- Thêm nhân viên thu ngân
create proc SP_THEMNHIENVIEN ( @MANHANVIEN char(10) , @TEN nvarchar(100), @SODIENTHOAI varchar(12),  @NGAYSINH date  )
as
	if exists ( select * from NHANVIENTHUNGAN where MANHANVIEN = @MANHANVIEN)
	            print N'Đã có nhân viên này'
	else
		insert into NHANVIENTHUNGAN(MANHANVIEN,TEN,SODIENTHOAI,NGAYSINH)
		values (@MANHANVIEN ,@TEN,@SODIENTHOAI,@NGAYSINH)
go
exec SP_THEMNHIENVIEN 'NV01', N'Nguyễn Ngọc Ngạn', '0339784890', '1999-02-13'
exec SP_THEMNHIENVIEN 'NV11', N'Thin đẹp troai', '0339784890', '1999-02-13'
select * from NHANVIENTHUNGAN
-- SỬA NHÂN VIÊN THU NGÂN
create proc SP_SUANHANVIENTHUNGAN ( @MANHANVIEN char(10) , @TEN nvarchar(100), @SODIENTHOAI varchar(12),  @NGAYSINH date  )
as
	if not exists ( select * from NHANVIENTHUNGAN where MANHANVIEN = @MANHANVIEN)
		print N'Không có nhân viên này'
	else
		update NHANVIENTHUNGAN
		set TEN = @TEN ,SODIENTHOAI = @SODIENTHOAI, NGAYSINH= @NGAYSINH
		where MANHANVIEN = @MANHANVIEN
go
   exec SP_SUANHANVIENTHUNGAN 'NV01', N'Nguyễn Ngọc Ngạn đã sửa', '0339784890', '1999-02-13'
   exec SP_SUANHANVIENTHUNGAN 'NV19', N'Nguyễn Ngọc Ngạn nhiên viên để thử', '0339784890', '1999-02-13'

------Xóa nhân viên thu ngân --------
create proc SP_XOANHANVIENTHUNGAN @MANHANVIEN char(10)
as
begin
	if  ( not exists ( select MANHANVIEN  from NHANVIENTHUNGAN where MANHANVIEN= @MANHANVIEN))
		print N'Không tồn tại nhân viên để xóa!'
	else
		delete from NHANVIENTHUNGAN
		where MANHANVIEN = @MANHANVIEN 
end
exec SP_XOANHANVIENTHUNGAN 'NV012'

---Lập thủ tục thêm nghệ sĩ---
create proc sp_THEMNGHESI @MANGHESI char(10),
 @TENNGHESI nvarchar(100), 
 @CONGTY nvarchar(100), 
 @SOLUONGBAIHAT int
as
begin
if exists (select * from NGHESI where MANGHESI=@MANGHESI)
print N'Mã nghệ sĩ đã có!'
else
if exists (select * from NGHESI where  TENNGHESI= @TENNGHESI)
print N'Tên Nghệ sĩ đã có!'
else
if @soluongbaihat <0 or @soluongbaihat>20
print N'Số lượng bài hát không hợp lệ!'
else insert into NGHESI values (@MANGHESI, @TENNGHESI, @CONGTY, @SOLUONGBAIHAT)
end
 
drop proc SP_THEMNGHESI
 
exec SP_THEMNGHESI 'BP' , N'BLACK PINK', N'YG Entertainment', 15
exec SP_THEMNGHESI 'HI' , N'BLACK PINK', N'YG Entertainment', 15
exec SP_THEMNGHESI 'HA' , N'HIA', N'YG Entertainment', 15
select * from NGHESI 
delete from NGHESI where MANGHESI='HA'
 
---Lập thủ tục sửa nghệ sĩ---
create proc sp_SUANGHESI @MANGHESI char(10),
 @TENNGHESI nvarchar(100), 
 @CONGTY nvarchar(100), 
 @SOLUONGBAIHAT int
as
begin
if not exists (select * from NGHESI where @MANGHESI=MANGHESI)
print N'Mã nghệ sĩ chưa có'
 
update NGHESI set TENNGHESI= @TENNGHESI, CONGTY=@CONGTY, SOLUONGBAIHAT=@SOLUONGBAIHAT
where MANGHESI=@MANGHESI
end
go
 
exec sp_SUANGHESI 'HA' , N'HIAA', N'YG Entertainment', 15
 
---Lập thủ tục xóa nghệ sĩ---
create proc sp_XOANGHESI (@MANGHESI char(10))
as
begin
if not exists (select * from NGHESI where @MANGHESI=MANGHESI)
print N'Mã nghệ sĩ chưa có!'
else 
if exists(select MANGHESI from BUOIDIEN where @MANGHESI=MANGHESI)
print N'Nghệ sĩ này đã có lịch diễn!'
else
delete from NGHESI 
where MANGHESI=@MANGHESI
end
 
exec sp_XOANGHESI 'BP'
select * from NGHESI 

---Lập thủ tục thêm kiểu đặt---
create proc sp_THEMKIEUDAT @MAKIEUDAT char(10), 
    @TENKIEUDAT nvarchar(50)
as
begin
if exists (select * from KIEUDAT where MAKIEUDAT=@MAKIEUDAT)
print N'Mã kiểu đặt đã có !'
else
if exists (select * from KIEUDAT where TENKIEUDAT=@TENKIEUDAT)
print N'Tên kiểu đặt đã có !'
else insert into KIEUDAT values (@MAKIEUDAT, @TENKIEUDAT)
end

exec sp_THEMKIEUDAT 'KD03', N'Trên facebook'
select * from KIEUDAT

---Lập thủ tục sửa kiểu đặt---
create proc sp_SUAKIEUDAT @MAKIEUDAT char(10), 
    @TENKIEUDAT nvarchar(50)
as
begin
if not exists (select * from KIEUDAT where MAKIEUDAT=@MAKIEUDAT)
print N'Mã kiểu đặt chưa có !'
update KIEUDAT set TENKIEUDAT=@TENKIEUDAT
where MAKIEUDAT=@MAKIEUDAT
end

exec sp_SUAKIEUDAT 'KD03', N'Trên zalo'
select * from KIEUDAT

---Lập thủ tục xóa kiểu đặt---
create proc sp_XOAKIEUDAT (@MAKIEUDAT char(10))
as
begin
if not exists (select * from KIEUDAT where MAKIEUDAT=@MAKIEUDAT)
print N'Mã kiểu đặt chưa có'

delete from KIEUDAT 
where MAKIEUDAT=@MAKIEUDAT
end

exec sp_XOAKIEUDAT 'KD03'
select * from KIEUDAT

--Lập thủ tục thêm dữ liệu cho bảng ghế đã đặt
--Thêm ghế đã đặt
create proc sp_ThemGheDaDat @stt int, @maghe char(10), @mabuoidien char(10), @makhachhang char(10), @makieudat char(10), @thoigiandat smalldatetime, @trangthai nvarchar(50)
as                                                                   
begin
	if(exists(select STT from GHEDADAT where STT=@stt ))
		print N'Số thứ tự đã tồn tại'
	else if(not exists(select MABUOIDIEN from BUOIDIEN where MABUOIDIEN=@mabuoidien))
	  print N'Buổi diễn này không tồn tại'
    else if(not exists(select MAKHACHHANG from KHACHHANG where MAKHACHHANG=@makhachhang))
		print N'Chưa có thông tin của khách hàng này'
	else if(not exists(select MAKIEUDAT from KIEUDAT where MAKIEUDAT=@makieudat))
		print N'Chưa có kiểu đặt này trong hệ thống'
	else if(exists(select MABUOIDIEN,MAKHACHHANG from GHEDADAT where MABUOIDIEN=@mabuoidien and MAKHACHHANG=@makhachhang))
		print N'Một người chỉ đươc mua một vé tại một buổi diễn'
	else if(not exists(select MAGHE, MABUOIDIEN from V_TONGHOPGHEBUOIDIEN where MAGHE=@maghe and MABUOIDIEN = @mabuoidien))
		print N'Ghế này không tồn tại trong buổi diễn hoặc đã được đặt'
	else
		insert into GHEDADAT values(@stt, @maghe, @mabuoidien, @makhachhang, @makieudat, @thoigiandat, @trangthai)
end

drop proc sp_ThemGheDaDat
delete from GHEDADAT where STT='30'
exec sp_ThemGheDaDat 32 , '35' , 'BD05', 'KH01', 'KD01', '2022-06-01', N'Chưa thanh toán'
exec sp_ThemGheDaDat 23 , '41' , 'BD03', 'KH10', 'KD02', '2022-06-01', N'Chưa thanh toán'
DELETE from GHEDADAT where STT=24
exec sp_ThemGheDaDat 27, '65' , 'BD06', 'KH02', 'KD02', '2022-06-01', N'Chưa thanh toán'
exec sp_ThemGheDaDat 24 , '41' , 'BD03', 'KH09', 'KD02', '2022-06-01', N'Chưa thanh toán'
select * from GHEDADAT
select * from BUOIDIEN

-- Lập thủ tục xoá ghế đã đặt. 
-- Điều kiện chưa xuất vé ( chưa có mã gdd ở bảng vé), 
-- hoặc vé ở trạng thái đã hủy

create proc P_XOAGHEDADAT @stt int
as 
    begin
        if (not exists (select * from GHEDADAT where STT = @stt))
            print N'Mã ghế này chưa được đặt'
        else if (exists (select * from VE where STTDATGHE = @stt and VE.TINHTRANG <> N'Đã hủy'))
            print N'Ghế này đã xuất vé'
        else
            delete from GHEDADAT where STT = @stt
    end
go

drop proc P_XOAGHEDADAT
exec P_XOAGHEDADAT 4
exec P_XOAGHEDADAT 30
exec P_XOAGHEDADAT 25
select * from GHEDADAT
select * from VE
insert into GHEDADAT values (25, '35' , 'BD06', 'KH11', 'KD01', '2022-04-12 22:27:20', N'Chưa thanh toán')
insert into GHEDADAT values (25, '36' , 'BD03', 'KH11', 'KD01', '2022-04-12 22:27:20', N'Đã thanh toán')
insert into VE values ('V16', 'NV03', 'KH11', 25, '2022-06-08 20:00:00', N'Đã hủy', 0)
exec sp_dsghedd 'DD03'
delete from  VE where MAVE='V16'

select * from GHEDADAT
--Thủ tục sửa ghế
create proc sp_altGHEDADAT @stt int, @maGhe int, @maBD char(10), @maKH char(10), @maKD char(10), @tg smalldatetime, @st nvarchar(50)
as
begin
    if not exists (select * from GHEDADAT where GHEDADAT.STT=@stt)
        print N'Số thứ tự này không tồn tại!'
            else  if not exists  (select * from GHEDADAT where GHEDADAT.MAGHE=@maGhe and GHEDADAT.STT=@stt)
                print N'Mã ghế này chưa được đặt hoặc không tồn tại'
                    else UPDATE GHEDADAT set GHEDADAT.MABUOIDIEN=@maBD,GHEDADAT.MAKHACHHANG=@maKH,GHEDADAT.MAKIEUDAT=@maKD,GHEDADAT.THOIGIANDAT=@tg,GHEDADAT.TRANGTHAI=@st where GHEDADAT.STT=@stt
end

exec sp_altGHEDADAT '1','2','BD02','KH02','KD02','2022-07-01','Đã thanh toán'
exec sp_altGHEDADAT '21','2','BD02','KH02','KD02','2022-07-01','Đã thanh toán'
exec sp_altGHEDADAT '1','1','BD02','KH02','KD02','2022-07-01','Đã thanh toán'


-- Update MANVTHUNGAN, TINHTRANG, GIAVE cho bảng VÉ
create proc SP_SUAVE @mave char(10), @manvthungan char(10), @tinhtrang nvarchar(50), @giave money
as
begin
    if not exists (select MAVE from VE where MAVE = @mave) 
        print N'Vé này không tồn tại!'
    else if not exists (select MANHANVIEN from NHANVIENTHUNGAN where MANHANVIEN = @manvthungan) 
        print N'Nhân viên này không tồn tại!'
    else 
        begin
			update VE
			set MANVTHUNGAN = @manvthungan, TINHTRANG = @tinhtrang, GIAVE = @giave
			where MAVE = @mave
        end
end

drop proc SP_SUAVE
select * from GHEDADAT
select * from VE

exec SP_SUAVE 'V00017', 'NV02', N'Hoàn thành', 2000000 -- print: Vé này không tồn tại! 
exec SP_SUAVE 'V00001', 'NV04', N'Hoàn thành', 2000000 -- print: Vé này không tồn tại! 
exec SP_SUAVE 'V00001', 'NV04', N'Hoàn thành', 2000000 -- print: Vé này không tồn tại!
exec SP_SUAVE 'V00001', 'NV10', N'Hoàn thành', 2000000 -- print: Nhân viên ko tồn tại!
exec SP_SUAVE 'V00001', 'NV04', N'Hoàn thành', 2000000 -- DONE

-- Xóa VE sai thông tin
create proc SP_XOAVE @mave char(10) 
as 
begin
    if not exists (select MAVE from VE where MAVE = @mave)
        print N'Vé này không tồn tại!'
    else if exists (select * from VE where MAVE = @mave and TINHTRANG not in  (N'Lỗi',N'Đã hủy'))
		print N'Vé đã xuất không thể xóa'
	else delete from VE where MAVE = @mave
end
insert into VE values
('V00020', 'NV02','KH03',20 ,'2022-04-08 15:01:00',N'Lỗi',0 )
select * from VE
exec SP_XOAVE 'V00050' -- print: Vé ko tồn tại
exec SP_XOAVE 'V00020'

--Thủ tục thêm ghế
create proc sp_Themghe @maghe int, @ghe char(10), @hang char(10), @vitri char(10), @madiadiem char(10), @loaighe nvarchar(50) 
as
begin 
    declare @l char(10)
    declare @r char(10)
    set @l = (select left(@ghe, 1))
    set @r = (select right(@ghe, 1))
	if(exists(select MAGHE from GHE where MAGHE=@maghe))
		print N'Mã ghế này đã tồn tại'
	else if(not exists(select MADIADIEM from DIADIEM where MADIADIEM=@madiadiem))
		print N'Địa điểm này không tồn tại'
	else if(exists(select GHE from GHE where GHE=@ghe and MADIADIEM=@madiadiem))
		print N'Ghế này đã tồn tại'
	else if(@loaighe not in (N'Thường',N'VIP'))
		print N'Loại ghế không hợp lệ'
	else if (@ghe not like '[1-9][A-Z]') 
		print N'Nhập sai cú pháp mã ghế, hàng, vị trí.'
	else if (@vitri <> @l and @hang <> @r)
		print N'Nhập sai cú pháp mã ghế, hàng, vị trí!'
	else insert into GHE values(@maghe, @ghe, @hang, @vitri, @madiadiem, @loaighe)
end

select * from GHE
exec sp_Themghe 77, '6A','A','6','DD05', N'VIP'

-- PROC sửa ghế
create proc SP_SUAGHE @maghe int, @ghe char(10), @hang char(10), @vitri char(10), @madiadiem char(10), @loaighe nvarchar(50)
as
begin
    declare @l char(10)
    declare @r char(10)
    set @l = (select left(@ghe, 1))
    set @r = (select right(@ghe, 1))
    if not exists (select MAGHE from GHE where MAGHE = @maghe)
        print N'Mã ghế không tồn tại'
    else if not exists (select MADIADIEM from DIADIEM where MADIADIEM = @madiadiem)
		print N'Mã địa điểm không tồn tại'
	else if (@ghe not like '[1-9][A-Z]') 
		print N'Nhập sai cú pháp mã ghế, hàng, vị trí.'
	else if (@vitri <> @l and @hang <> @r)-- check xem GHE có bằng VITRI + HANG ko?
		print N'Nhập sai cú pháp mã ghế, hàng, vị trí!'
	else if(exists(select MAGHE from GHE where MAGHE<> @maghe and GHE=@ghe and MADIADIEM=@madiadiem))
		print N'Trùng dữ liệu ghế và địa điểm'
	else if(@loaighe not in (N'Thường',N'VIP'))
		print N'Loại ghế không hợp lệ'
	else
		update GHE
		set GHE = @ghe, HANG = @hang, VITRI = @vitri, MADIADIEM = @madiadiem, LOAIGHE = @loaighe
		where MAGHE = @maghe
end

drop proc SP_SUAGHE
select * from GHE

exec SP_SUAGHE 76, '5C', 'C', '5', 'DD05', N'THƯỜNG' -- print: Mã ghế ko tồn tại
exec SP_SUAGHE 75, '5C', 'C', '5', 'DD09', N'THƯỜNG' -- print: Mã địa điểm ko tồn tại
exec SP_SUAGHE 75, '0C', 'C', '5', 'DD05', N'THƯỜNG' -- print: Nhập sai cú pháp mã ghế, hàng, vị trí
exec SP_SUAGHE 75, '5-', 'C', '5', 'DD05', N'THƯỜNG' -- print: Nhập sai cú pháp mã ghế, hàng, vị trí
exec SP_SUAGHE 75, '5C', 'D', '7', 'DD05', N'THƯỜNG' -- print: Nhập sai cú pháp mã ghế, hàng, vị trí
exec SP_SUAGHE 75, '4C', 'C', '4', 'DD05', N'VIP'    -- print: Trùng dữ liệu
exec SP_SUAGHE 75, '6C', 'C', '6', 'DD05', N'Thường' -- DONE
exec SP_SUAGHE 75, '5A', 'A', '5', 'DD05', N'VIP'    -- DONE
exec SP_SUAGHE 71, '1C', 'C', '1', 'DD05', N'VIP'    -- DONE

-- PROC xóa ghế
create proc SP_XOAGHE @maghe int
as
begin
    if not exists (select MAGHE from GHE where MAGHE = @maghe)
        print N'Mã ghế không tồn tại!'
    else if exists (select MAGHE from GHEDADAT where MAGHE = @maghe)
		print N'Ghế này đã được sử dụng, không xóa được!'
	else delete from GHE where MAGHE = @maghe
end

drop proc SP_XOAGHE
select * from GHE
exec SP_XOAGHE 76 -- print: Mã ghế không tồn tại
exec SP_XOAGHE 1  -- print: Ghế này đã được đặt, không xóa được
exec SP_XOAGHE 75  -- DONE

----THÊM BUỔI DIỄN----
create proc sp_ThemBuoiDien @mabuoidien char(10), @manghesi char(10), @madiadiem char(10), @thoigianbd smalldatetime, @doanhthu money
as 
begin
    if (exists(select MABUOIDIEN FROM BUOIDIEN WHERE MABUOIDIEN=@mabuoidien))
		print N'Buổi diễn này đã có'
	else if (not exists(select MADIADIEM FROM DIADIEM WHERE MADIADIEM=@madiadiem))
		print N'Địa điểm không tồn tại'
	else if (not exists(select MANGHESI FROM NGHESI WHERE MANGHESI=@manghesi))
		print N'Nghệ sĩ không tồn tại'
    else if (@thoigianbd in (select THOIGIANBD from BUOIDIEN where @madiadiem=MADIADIEM))
        print N'Địa điểm này đã có buổi diễn vào thời điểm này'
	else if (@thoigianbd in (select THOIGIANBD from BUOIDIEN where @manghesi=MANGHESI))
        print N'Nghệ sĩ đã có buổi diễn vào thời điểm này'
    else
		insert into BUOIDIEN values(@mabuoidien,@manghesi,@madiadiem,@thoigianbd, @doanhthu)
end

select * from BUOIDIEN
exec sp_ThemBuoiDien 'BD08', 'BP' , 'DD06', '2022-07-10 7:00:00',0
exec sp_ThemBuoiDien 'BD09', 'BP' , 'DD01', '2022-07-10 7:00:00',0
exec sp_ThemBuoiDien 'BD09', 'BP' , 'DD02', '2022-07-10 7:00:00',0
exec sp_ThemBuoiDien 'BD09', 'AE' , 'DD02', '2022-07-10 7:00:00',0

----SỬA BUỔI DIỄN----
create proc sp_SuaBuoiDien @mabuoidien char(10), @manghesi char(10), @madiadiem char(10), @thoigianbd smalldatetime
as 
begin
    if (not exists(select MABUOIDIEN FROM BUOIDIEN WHERE MABUOIDIEN=@mabuoidien))
		print N'Không tồn tại buổi diễn này để chỉnh sửa'
	else if (not exists(select MADIADIEM FROM DIADIEM WHERE MADIADIEM=@madiadiem))
		print N'Địa điểm không tồn tại'
	else if (not exists(select MANGHESI FROM NGHESI WHERE MANGHESI=@manghesi))
		print N'Nghệ sĩ không tồn tại'
	else if (@thoigianbd in (select THOIGIANBD from BUOIDIEN where @madiadiem=MADIADIEM or  @manghesi=MANGHESI))
        print N'Trùng lặp dữ liệu không thể sửa!'
    else 
        update BUOIDIEN
        set MANGHESI=@manghesi, MADIADIEM=@madiadiem,THOIGIANBD=@thoigianbd
        where MABUOIDIEN=@mabuoidien
end

select * from BUOIDIEN
exec sp_SuaBuoiDien 'BD15', 'BTS' , 'DD01', '2022-07-10 13:00:00'
exec sp_SuaBuoiDien 'BD09', 'BTS' , 'DD01', '2022-07-10 13:00:00'
exec sp_SuaBuoiDien 'BD09', 'BTS' , 'DD01', '2022-07-10 07:00:00'
exec sp_SuaBuoiDien 'BD09', 'BTS' , 'DD05', '2022-07-10 07:00:00'

--Cập nhật doanh thu cho buổi diễn đã tồn tại
create proc sp_ThemDTBuoiDien @mabuoidien char(10)
as 
begin
	if (not exists(select MABUOIDIEN FROM BUOIDIEN WHERE MABUOIDIEN=@mabuoidien))
	print N'Không tồn tại buổi diễn này để chỉnh sửa'
	else
	update BUOIDIEN set DOANHTHU= (select sum(GIAVE) 
	from VE,GHEDADAT 
	where  GHEDADAT.MABUOIDIEN=@mabuoidien and GHEDADAT.STT=VE.STTDATGHE)
	where  MABUOIDIEN=@mabuoidien
end
exec sp_ThemDTBuoiDien 'BD01'
exec sp_ThemDTBuoiDien 'BD02'
exec sp_ThemDTBuoiDien 'BD03'
exec sp_ThemDTBuoiDien 'BD04'
exec sp_ThemDTBuoiDien 'BD05'
select * from BUOIDIEN
select sum(GIAVE) 
	from VE,GHEDADAT 
	where  GHEDADAT.MABUOIDIEN='BD02' and GHEDADAT.STT=VE.STTDATGHE
----XÓA BUỔI DIỄN----
create proc sp_XoaBuoiDien @mabuoidien char(10)
as 
begin
    if (not exists(select MABUOIDIEN FROM BUOIDIEN WHERE MABUOIDIEN=@mabuoidien))
		print N'Không tồn tại buổi diễn này để xóa'
	else if exists (select MABUOIDIEN from GHEDADAT where MABUOIDIEN = @mabuoidien)
		print N'Buổi diễn này đang sử dụng, không xóa được!'
    else 
        delete from BUOIDIEN
        where MABUOIDIEN=@mabuoidien
end

exec sp_XoaBuoiDien 'BD06'
exec sp_XoaBuoiDien 'BD09'

--Thêm đảm nhiệm
create proc sp_addDAMNHIEM @ma char(10),@ca int
as
begin
    if exists (select * from DAMNHIEM where DAMNHIEM.MANHANVIEN=@ma and DAMNHIEM.CATRUC=@ca)
        print N'nhân viên này đã làm ca trực này rồi'
            else if not exists (select * from NHANVIENTHUNGAN where NHANVIENTHUNGAN.MANHANVIEN=@ma )
                print N'Nhân viên này không tồn tại'
                    else insert into DAMNHIEM values(@ma,@ca)
end
exec sp_addDAMNHIEM 'NV01',2
select * from DAMNHIEM
 --Cập nhật đảm nhiệm

create proc sp_altDAMNHIEM @ma char(10),@ca1 int,@ca2 int
as
begin
    if exists (select * from DAMNHIEM where DAMNHIEM.MANHANVIEN=@ma and DAMNHIEM.CATRUC=@ca2)
        print N'nhân viên này đã làm ca trực này rồi'
            else if not exists (select * from NHANVIENTHUNGAN where NHANVIENTHUNGAN.MANHANVIEN=@ma )
                print N'Nhân viên này không tồn tại'
                    else update DAMNHIEM set CATRUC=@ca2 where  DAMNHIEM.MANHANVIEN=@ma and DAMNHIEM.CATRUC=@ca1
end

exec sp_altDAMNHIEM 'NV10','02','03'
--Xóa đảm nhiệm

create proc sp_delDAMNHIEM @ma char(10),@ca int
as
begin
    if not exists (select * from NHANVIENTHUNGAN where NHANVIENTHUNGAN.MANHANVIEN=@ma )
        print N'Nhân viên này không tồn tại'
            else if not exists (select * from DAMNHIEM where DAMNHIEM.MANHANVIEN=@ma and DAMNHIEM.CATRUC=@ca)
                print N'Nhân viên không làm ca trực này!'
                    else delete from DAMNHIEM where DAMNHIEM.MANHANVIEN=@ma and DAMNHIEM.CATRUC=@ca
end

exec sp_delDAMNHIEM 'NV01','3'
SELECT name FROM SYS.PROCEDURES





 


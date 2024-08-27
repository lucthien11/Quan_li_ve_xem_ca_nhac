--Trigger cập nhật giá vé, doanh thu sau khi thêm vé trong bảng vé với vé  vip là 2000k, vé thường là 1000k
alter trigger CAPNHATGIAVE on VE after insert 
as
begin
UPDATE VE
    SET GIAVE = 1000000
FROM
 dbo.GHE INNER JOIN
                  dbo.GHEDADAT ON dbo.GHE.MAGHE = dbo.GHEDADAT.MAGHE INNER JOIN
                  dbo.VE ON dbo.GHEDADAT.STT = dbo.VE.STTDATGHE,INSERTED
WHERE LOAIGHE=N'THƯỜNG' and INSERTED.MAVE=VE.MAVE
UPDATE VE
    SET GIAVE = 2000000
FROM
 dbo.GHE INNER JOIN
                  dbo.GHEDADAT ON dbo.GHE.MAGHE = dbo.GHEDADAT.MAGHE INNER JOIN
                  dbo.VE ON dbo.GHEDADAT.STT = dbo.VE.STTDATGHE,INSERTED
WHERE LOAIGHE=N'VIP' and INSERTED.MAVE=VE.MAVE
end
go
insert into VE values ('V00020', 'NV02','KH03',20 ,'2022-04-08 15:01:00',N'Lỗi',0 )
select * from VE
--Cập nhật số lượng ghế của địa điểm khi chỉnh thêm hoặc xóa ghế
CREATE TRIGGER trg_CapNhatSLGheThemghe on GHE AFTER INSERT
AS
BEGIN
    DECLARE    @Soluongghe int;
    SELECT  @Soluongghe=DIADIEM.SOLUONGGHE FROM GHE,DIADIEM,inserted WHERE inserted.MADIADIEM = GHE.MADIADIEM AND GHE.MADIADIEM = DIADIEM.MADIADIEM;
        BEGIN 
            UPDATE DIADIEM SET DIADIEM.SOLUONGGHE = DIADIEM.SOLUONGGHE + 1 FROM inserted, DIADIEM, GHE where inserted.MADIADIEM = GHE.MADIADIEM and GHE.MADIADIEM = DIADIEM.MADIADIEM ;
        end
END
GO
CREATE TRIGGER trg_CapNhatSLGheXoaghe on GHE AFTER DELETE
AS
BEGIN
    DECLARE    @Soluongghe int;
    SELECT  @Soluongghe=DIADIEM.SOLUONGGHE FROM GHE,DIADIEM,deleted WHERE deleted.MADIADIEM = GHE.MADIADIEM AND GHE.MADIADIEM = DIADIEM.MADIADIEM;
        BEGIN 
            UPDATE DIADIEM SET DIADIEM.SOLUONGGHE = DIADIEM.SOLUONGGHE - 1 FROM deleted, DIADIEM, GHE where deleted.MADIADIEM = GHE.MADIADIEM and GHE.MADIADIEM = DIADIEM.MADIADIEM ;
        end
END
GO
INSERT INTO GHE(MAGHE,GHE,HANG,VITRI,MADIADIEM,LOAIGHE) VALUES ('76','2D', 'D', '2', 'DD02',N'THƯỜNG')
SELECT * FROM DIADIEM
delete from GHE where MAGHE='76'
SELECT * FROM GHE

---- Tạo vé KH Offline
-- Khi có dữ liệu mới trong bảng ghế đã đặt với trạng thái đã thanh toán thì tạo vé với mã ghế đã đặt, mã vé mới, mã kh tham chiếu tới bảng ghế đã đặt, thời gian đặt vé là thời điểm hiện tại còn lại để trống
create trigger TRG_XUATVEOFFLINE on  GHEDADAT after insert 
as    
    begin 
        declare @mavemoi char(10) = 'V00001'
        declare @makhachhang char(10)
        declare @sttdatghe int
        declare @thoigiandatve smalldatetime
        if (exists (select TRANGTHAI from inserted where TRANGTHAI = N'Đã thanh toán') )
        begin
            declare @index int = 1
            while exists (select MAVE from VE where MAVE = @mavemoi)
            begin
                set @index = @index + 1
                set @mavemoi = 'V' + REPLICATE('0', 5 - len(cast(@index as varchar))) + cast(@index as varchar)
            end
			set @makhachhang = (select MAKHACHHANG from inserted)
            set @sttdatghe = (select STT from inserted)
            set @thoigiandatve = sysdatetime()
            insert into VE values (@mavemoi, null, @makhachhang, @sttdatghe, @thoigiandatve, nulL,0)
        end
    end

drop trigger TRG_XUATVEOFFLINE

insert into GHEDADAT values (21, '72', 'BD05', 'KH06', 'KD01', '2022-06-01', N'Đã thanh toán')
delete from VE where STTDATGHE = 17
delete from GHEDADAT where STT = 21
select * from GHEDADAT
select * from VE

-- Tạo vé KH Online
-- Sau khi trạng thái ghế đã đặt đươc cập nhật là đã thanh toán thì tạo vé với mã ghế đã đặt, mã vé mới, mã kh tham chiếu tới bảng ghế đã đặt thời gian đặt vé là thời điểm hiện tại còn lại để trống
create trigger TRG_XUATVEONLINE on  GHEDADAT after update
as    
    begin 
        declare @mavemoi char(10) = 'V00001'
        declare @makhachhang char(10)
        declare @sttdatghe int
        declare @thoigiandatve smalldatetime
        if (exists (select TRANGTHAI from inserted where TRANGTHAI = N'Đã thanh toán') )
        begin
            declare @index int = 1
            while exists (select MAVE from VE where MAVE = @mavemoi)
            begin
                set @index = @index + 1
                set @mavemoi = 'V' + REPLICATE('0', 5 - len(cast(@index as varchar))) + cast(@index as varchar)
            end
            set @makhachhang = (select MAKHACHHANG from inserted)
            set @sttdatghe = (select STT from inserted)
            set @thoigiandatve = sysdatetime()
            insert into VE values (@mavemoi, null, @makhachhang, @sttdatghe, @thoigiandatve, null, 0)
        end
    end

drop trigger TRG_XUATVEONLINE
 
update GHEDADAT
    set TRANGTHAI = N'Đã thanh toán'
    where STT = 20
delete from VE where STTDATGHE = 21
delete from GHEDADAT where STT = 21
select * from GHEDADAT
select * from VE
--
create trigger KiemTraThoiGianDatVe on VE for insert,update
as
begin
    if ((select(INSERTED.THOIGIANXUATVE) from INSERTED)>DATEADD(day,-2,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,inserted,GHEDADAT where inserted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)))
    Begin
      
        ROLLBACK TRAN ;print 'Abort';
    ENd
end
insert into VE values ('V16','NV01','KH04','12','2022-07-10 08:00:00 ',N'NULL',0);
delete from VE where VE.MAVE='V16'
select * from BUOIDIEN

--

create trigger update_DOANHTHU on VE after update
as
begin				
        declare @time smalldatetime select @time=sysdatetime();
        declare @exp float;
		if exists (select inserted.GIAVE from inserted,deleted where inserted.GIAVE<>deleted.GIAVE)
			update BUOIDIEN set BUOIDIEN.DOANHTHU+=inserted.GIAVE from inserted,BUOIDIEN,GHEDADAT,VE where inserted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN
		if exists ((select TINHTRANG from inserted where inserted.TINHTRANG=N'Đã hủy'))
			begin	
					select @exp=
					case
					when @time>DATEADD(day,-6,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,deleted,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)) then 1.0
					when @time<=DATEADD(day,-6,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,deleted,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)) then 0.9
					when @time<=DATEADD(day,-5,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,deleted,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)) then 0.8
					when @time<=DATEADD(day,-4,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,deleted,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)) then 0.7
					when @time<=DATEADD(day,-3,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,deleted,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)) then 0.6
					when @time<=DATEADD(day,-2,(select BUOIDIEN.THOIGIANBD from BUOIDIEN,deleted,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN)) then 0.5
					else 0
					end
			update BUOIDIEN set BUOIDIEN.DOANHTHU-=deleted.GIAVE*(@exp) from deleted,BUOIDIEN,GHEDADAT where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN
			end
		if exists (select TINHTRANG from inserted where inserted.TINHTRANG=N'Lỗi')
		update BUOIDIEN set BUOIDIEN.DOANHTHU-=deleted.GIAVE from deleted,BUOIDIEN,GHEDADAT,VE where deleted.STTDATGHE=GHEDADAT.STT and GHEDADAT.MABUOIDIEN=BUOIDIEN.MABUOIDIEN
end
select * from BUOIDIEN
update GHEDADAT
    set TRANGTHAI = N'Đã thanh toán'
    where STT = 22
update VE
    set TINHTRANG = N'Đã hủy'
    where MAVE='V00018'
insert into GHEDADAT values  
(22, 1, 'BD07', 'KH10', 'KD01', '2022-04-12 22:40:00', N'Chưa thanh toán')

insert into BUOIDIEN values 
('BD07', 'BP' , 'DD01', '2022-04-18 07:00:00',0)
--Kiểm tra xóa vé. Không cho phép xóa khi vé không bị lỗi hoặc chưa hủy
create trigger KiemTraXoave on VE for delete
as
begin
    if not exists(select(TINHTRANG) from deleted where TINHTRANG in (N'Lỗi',N'Đã hủy'))
    Begin
      
        ROLLBACK TRAN ;print 'Abort';
    ENd
end
SELECT * FROM SYS.TRIGGERS

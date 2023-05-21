package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "ve_xe")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class VeXe extends BaseEntity{
    @Column(name = "idNv")
    private Long idNv;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="idNv",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private NguoiDung nhanVien;
    @Column(name = "code")
    private String code;
    @Column(name = "type")
    private Short type;//0: ve thang    1:ve free
    @Column(name = "duration")
    private Timestamp duration;
    @Column(name = "full_name")
    private String fullName;
    @Column(name = "chuc_vu")
    private String chucVu;
    @Column(name = "don_vi")
    private String donVi;
    @Column(name = "sdt")
    private String sdt;
    @Column(name = "dia_chi")
    private String diaChi;
    @Column(name = "xe")
    private Short xe;
    @Column(name = "hang_xe")
    private Short hangXe;
    @Column(name = "bien_so")
    private String bienSo;
    @Column(name = "mo_ta")
    private String moTa;
    @Column(name = "point")
    private String point;
    @Column(name = "loai_hinh_tt")
    private Short loaiHinhTt;
    @Column(name = "status_tt")
    private Short statusTt;
    @Column(name = "status")
    private Short status;
}
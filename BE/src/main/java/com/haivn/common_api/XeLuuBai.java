package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;

@Entity
@Table(name = "xe_luu_bai")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class XeLuuBai extends BaseEntity{
    @Column(name = "idNvT")
    private Long idNvT;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="idNvT",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private NguoiDung nhanVienThem;
    @Column(name = "xe")
    private Short xe;
    @Column(name = "bien_so")
    private String bienSo;
    @Column(name = "mo_ta")
    private String moTa;
    @Column(name = "idNvXN")
    private Long idNvXN;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="idNvXN",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private NguoiDung nhanVienXacNhan;
    @Column(name = "ly_do")
    private String lyDo;
    @Column(name = "idBx")
    private Long idBx;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="idBx",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private BaiXe baiXe;
    @Column(name = "status")
    private Short status;
}

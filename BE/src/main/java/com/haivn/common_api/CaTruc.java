package com.haivn.common_api;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "ca_truc")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class CaTruc  extends BaseEntity{
    @Column(name = "idNv")
    private Long idNv;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="idNv",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private NguoiDung nhanVien;
    @Column(name = "idBx")
    private Long idBx;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="idBx",referencedColumnName="id", nullable = false, insertable = false, updatable = false)
    private BaiXe baiXe;
    @Column(name = "noi_dung")
    private String noiDung;
    @Column(name = "ca")
    private Short ca;
    @Column(name = "start_time")
    private Timestamp startTime;
    @Column(name = "end_time")
    private Timestamp endTime;
    @Column(name = "start_click")
    private Timestamp startClick;
    @Column(name = "end_click")
    private Timestamp endClick;
    @Column(name = "so_lg_ve")
    private Long soLgVe;
    @Column(name = "tien_ve")
    private Long tienVe;
    @Column(name = "status")
    private Short status;
}

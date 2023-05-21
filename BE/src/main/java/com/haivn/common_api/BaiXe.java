package com.haivn.common_api;

import lombok.*;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
@Entity
@Table(name = "bai_xe")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class BaiXe extends BaseEntity{
    @Column(name = "name")
    private String name;
    @Column(name = "code")
    private String code;
    @Column(name = "dien_tich")
    private String dienTich;
    @Column(name = "vi_tri")
    private String viTri;
    @Column(name = "slot_max")
    private String slotMax;
    @Column(name = "status")
    private Short status;

}

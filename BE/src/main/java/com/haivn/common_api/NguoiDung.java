package com.haivn.common_api;

import lombok.*;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Where;

import javax.persistence.*;
import java.sql.Timestamp;

@Entity
@Table(name = "nguoi_dung")
@Getter
@Setter
@DynamicUpdate
@Where(clause = "deleted=false")
public class NguoiDung extends BaseEntity{
    @Column(name = "user_name")
    private String userName;
    @Column(name = "password")
    private String password;
    @Column(name = "role")
    private Short role;
    @Column(name = "user_code")
    private String userCode;
    @Column(name = "full_name")
    private String fullName;
    @Column(name = "avatar")
    private String avatar;
    @Column(name = "email")
    private String email;
    @Column(name = "sdt")
    private String sdt;
    @Column(name = "dia_chi")
    private String diaChi;
    @Column(name = "gioi_tinh")
    private Short gioiTinh;
    @Column(name = "cccd")
    private String cccd;
    @Column(name = "ngay_sinh")
    private Timestamp ngaySinh;
    @Column(name = "ngay_vao")
    private Timestamp ngayVao;
    @Column(name = "status")
    private Short status;

}

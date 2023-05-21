package com.haivn.dto;

import com.haivn.annotation.CheckEmail;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class NguoiDungDto extends BaseDto {
    @Size(max = 255)
    private String userName;
    @Size(max = 255)
    private String password;
    private Short role;
    @Size(max = 255)
    private String userCode;
    @Size(max = 255)
    private String fullName;
    @Size(max = 255)
    private String avatar;
    @CheckEmail
    @Size(max = 255)
    private String email;
    @Size(max = 255)
    private String sdt;
    @Size(max = 255)
    private String diaChi;
    private Short gioiTinh;
    @Size(max = 255)
    private String cccd;
    private Timestamp ngaySinh;
    private Timestamp ngayVao;
    private Short status;

    public NguoiDungDto() {
    }
}
package com.haivn.dto;

import com.haivn.common_api.NguoiDung;
import io.swagger.annotations.ApiModel;
import lombok.*;

import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class VeXeDto extends BaseDto {
    private Long idNv;
    private NguoiDung nhanVien;
    private String code;
    private Short type;
    private Timestamp duration;
    @Size(max = 255)
    private String fullName;
    @Size(max = 255)
    private String chucVu;
    @Size(max = 255)
    private String donVi;
    @Size(max = 255)
    private String sdt;
    @Size(max = 255)
    private String diaChi;
    private Short xe;
    private Short hangXe;
    private String bienSo;
    @Size(max = 255)
    private String moTa;
    @Size(max = 255)
    private String point;
    private Short loaiHinhTt;
    private Short statusTt;
    private Short status;

    public VeXeDto() {
    }
}
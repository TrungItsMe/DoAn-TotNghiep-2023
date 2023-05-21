package com.haivn.dto;

import com.haivn.common_api.BaiXe;
import com.haivn.common_api.NguoiDung;
import io.swagger.annotations.ApiModel;
import lombok.*;

import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class XeLuuBaiDto extends BaseDto {
    private Long idNvT;
    private NguoiDung nhanVienThem;
    private Short xe;
    @Size(max = 255)
    private String bienSo;
    @Size(max = 255)
    private String moTa;
    private Long idNvXN;
    private NguoiDung nhanVienXacNhan;
    private String lyDo;
    private Long idBx;
    private BaiXe baiXe;
    private Short status;

    public XeLuuBaiDto() {
    }
}
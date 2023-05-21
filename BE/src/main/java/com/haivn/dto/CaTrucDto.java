package com.haivn.dto;

import com.haivn.common_api.BaiXe;
import com.haivn.common_api.NguoiDung;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.Column;
import javax.validation.constraints.Size;
import java.sql.Timestamp;

@ApiModel()
@Getter
@Setter
public class CaTrucDto extends BaseDto {
    private Long idNv;
    private NguoiDung nhanVien;
    private Long idBx;
    private BaiXe baiXe;
    private String noiDung;
    private Short ca;
    private Timestamp startTime;
    private Timestamp endTime;
    private Timestamp startClick;
    private Timestamp endClick;
    private Long soLgVe;
    private Long tienVe;
    private Short status;

    public CaTrucDto() {
    }
}
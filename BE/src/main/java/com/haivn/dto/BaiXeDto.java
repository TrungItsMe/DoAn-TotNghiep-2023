package com.haivn.dto;

import com.haivn.common_api.BaiXe;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.validation.constraints.Size;

@ApiModel()
@Getter
@Setter
public class BaiXeDto extends BaseDto {
    @Size(max = 255)
    private String name;
    @Size(max = 255)
    private String code;
    @Size(max = 255)
    private String dienTich;
    @Size(max = 255)
    private String viTri;
    @Size(max = 255)
    private String slotMax;
    private Short status;

    public BaiXeDto() {
    }
}
package com.haivn.mapper;

import com.haivn.common_api.BaiXe;
import com.haivn.dto.BaiXeDto;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface BaiXeMapper extends EntityMapper<BaiXeDto, BaiXe> {
}
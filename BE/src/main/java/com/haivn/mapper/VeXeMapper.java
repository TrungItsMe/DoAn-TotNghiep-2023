package com.haivn.mapper;

import com.haivn.common_api.VeXe;
import com.haivn.dto.VeXeDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface VeXeMapper extends EntityMapper<VeXeDto, VeXe> {
}
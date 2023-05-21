package com.haivn.mapper;

import com.haivn.common_api.XeLuuBai;
import com.haivn.dto.XeLuuBaiDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface XeLuuBaiMapper extends EntityMapper<XeLuuBaiDto, XeLuuBai> {
}
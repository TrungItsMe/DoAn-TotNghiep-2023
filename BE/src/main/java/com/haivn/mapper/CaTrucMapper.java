package com.haivn.mapper;

import com.haivn.common_api.CaTruc;
import com.haivn.dto.CaTrucDto;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface CaTrucMapper extends EntityMapper<CaTrucDto, CaTruc> {
}
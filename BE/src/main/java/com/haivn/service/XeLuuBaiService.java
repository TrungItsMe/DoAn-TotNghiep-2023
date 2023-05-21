package com.haivn.service;

import com.haivn.common_api.XeLuuBai;
import com.haivn.dto.BaiXeDto;
import com.haivn.dto.XeLuuBaiDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.XeLuuBaiMapper;
import com.haivn.repository.XeLuuBaiRepository;
import com.turkraft.springfilter.boot.Filter;
import lombok.extern.slf4j.Slf4j;
import org.mapstruct.factory.Mappers;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional
public class XeLuuBaiService {
    private final XeLuuBaiRepository repository;
    private final XeLuuBaiMapper xeLuuBaiMapper;

    public XeLuuBaiService(XeLuuBaiRepository repository, XeLuuBaiMapper xeLuuBaiMapper) {
        this.repository = repository;
        this.xeLuuBaiMapper = xeLuuBaiMapper;
    }

    public XeLuuBaiDto save(XeLuuBaiDto xeLuuBaiDto) {
        XeLuuBai entity = xeLuuBaiMapper.toEntity(xeLuuBaiDto);
        return xeLuuBaiMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public XeLuuBaiDto findById(Long id) {
        return xeLuuBaiMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<XeLuuBaiDto> findByCondition(@Filter Specification<XeLuuBai> spec, Pageable pageable) {
        Page<XeLuuBai> entityPage = repository.findAll(spec,pageable);
        List<XeLuuBai> entities = entityPage.getContent();
        return new PageImpl<>(xeLuuBaiMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public XeLuuBaiDto update(XeLuuBaiDto xeLuuBaiDto, Long id) {
        XeLuuBaiDto data = findById(id);
        XeLuuBai entity = xeLuuBaiMapper.toEntity(xeLuuBaiDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(xeLuuBaiMapper.toDto(entity));
    }
}
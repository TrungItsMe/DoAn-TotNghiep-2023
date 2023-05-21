package com.haivn.service;

import com.haivn.common_api.VeXe;
import com.haivn.dto.VeXeDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.VeXeMapper;
import com.haivn.repository.VeXeRepository;
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
public class VeXeService {
    private final VeXeRepository repository;
    private final VeXeMapper veXeMapper;

    public VeXeService(VeXeRepository repository, VeXeMapper veXeMapper) {
        this.repository = repository;
        this.veXeMapper = veXeMapper;
    }

    public VeXeDto save(VeXeDto veXeDto) {
        VeXe entity = veXeMapper.toEntity(veXeDto);
        return veXeMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public VeXeDto findById(Long id) {
        return veXeMapper.toDto(repository.findById(id).orElseThrow(()
                        -> new EntityNotFoundException("Item Not Found! ID: " + id)
                ));
    }

    public Page<VeXeDto> findByCondition(@Filter Specification<VeXe> spec, Pageable pageable) {
        Page<VeXe> entityPage = repository.findAll(spec,pageable);
        List<VeXe> entities = entityPage.getContent();
        return new PageImpl<>(veXeMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public VeXeDto update(VeXeDto veXeDto, Long id) {
        VeXeDto data = findById(id);
        VeXe entity = veXeMapper.toEntity(veXeDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(veXeMapper.toDto(entity));
    }
}
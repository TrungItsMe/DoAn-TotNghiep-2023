package com.haivn.service;

import com.haivn.common_api.CaTruc;
import com.haivn.dto.CaTrucDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.CaTrucMapper;
import com.haivn.repository.CaTrucRepository;
import com.turkraft.springfilter.boot.Filter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityNotFoundException;
import java.util.List;

@Slf4j
@Service
@Transactional
public class CaTrucService {
    private final CaTrucRepository repository;
    private final CaTrucMapper caTrucMapper;

    public CaTrucService(CaTrucRepository repository, CaTrucMapper caTrucMapper) {
        this.repository = repository;
        this.caTrucMapper = caTrucMapper;
    }

    public CaTrucDto save(CaTrucDto caTrucDto) {
        CaTruc entity = caTrucMapper.toEntity(caTrucDto);
        return caTrucMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public CaTrucDto findById(Long id) {
        return caTrucMapper.toDto(repository.findById(id).orElseThrow(()->new EntityNotFoundException("")));
    }

    public Page<CaTrucDto> findByCondition(@Filter Specification<CaTruc> spec, Pageable pageable) {
        Page<CaTruc> entityPage = repository.findAll(spec,pageable);
        List<CaTruc> entities = entityPage.getContent();
        return new PageImpl<>(caTrucMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public CaTrucDto update(CaTrucDto caTrucDto, Long id) {
        CaTrucDto data = findById(id);
        CaTruc entity = caTrucMapper.toEntity(caTrucDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(caTrucMapper.toDto(entity));
    }
}
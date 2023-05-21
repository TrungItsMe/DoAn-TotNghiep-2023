package com.haivn.service;

import com.haivn.common_api.BaiXe;
import com.haivn.dto.BaiXeDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.BaiXeMapper;
import com.haivn.repository.BaiXeRepository;
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
public class BaiXeService {
    private final BaiXeRepository repository;
    private final BaiXeMapper baiXeMapper;

    public BaiXeService(BaiXeRepository repository, BaiXeMapper baiXeMapper) {
        this.repository = repository;
        this.baiXeMapper = baiXeMapper;
    }

    public BaiXeDto save(BaiXeDto baiXeDto) {
        BaiXe entity = baiXeMapper.toEntity(baiXeDto);
        return baiXeMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public BaiXeDto findById(Long id) {
        return baiXeMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<BaiXeDto> findByCondition(@Filter Specification<BaiXe> spec, Pageable pageable) {
        Page<BaiXe> entityPage = repository.findAll(spec,pageable);
        List<BaiXe> entities = entityPage.getContent();
        return new PageImpl<>(baiXeMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public BaiXeDto update(BaiXeDto baiXeDto, Long id) {
        BaiXeDto data = findById(id);
        BaiXe entity = baiXeMapper.toEntity(baiXeDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(baiXeMapper.toDto(entity));
    }
}
package com.haivn.service;

import com.haivn.common_api.NguoiDung;
import com.haivn.dto.NguoiDungDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.NguoiDungMapper;
import com.haivn.repository.NguoiDungRepository;
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
public class NguoiDungService {
    private final NguoiDungRepository repository;
    private final NguoiDungMapper nguoiDungMapper;

    public NguoiDungService(NguoiDungRepository repository, NguoiDungMapper nguoiDungMapper) {
        this.repository = repository;
        this.nguoiDungMapper = nguoiDungMapper;
    }

    public NguoiDungDto save(NguoiDungDto nguoiDungDto) {
        NguoiDung entity = nguoiDungMapper.toEntity(nguoiDungDto);
        return nguoiDungMapper.toDto(repository.save(entity));
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }

    public NguoiDungDto findById(Long id) {
        return nguoiDungMapper.toDto(repository.findById(id).orElseThrow(()
                -> new EntityNotFoundException("Item Not Found! ID: " + id)
        ));
    }

    public Page<NguoiDungDto> findByCondition(@Filter Specification<NguoiDung> spec, Pageable pageable) {
        Page<NguoiDung> entityPage = repository.findAll(spec,pageable);
        List<NguoiDung> entities = entityPage.getContent();
        return new PageImpl<>(nguoiDungMapper.toDto(entities), pageable, entityPage.getTotalElements());
    }

    public NguoiDungDto update(NguoiDungDto nguoiDungDto, Long id) {
        NguoiDungDto data = findById(id);
        NguoiDung entity = nguoiDungMapper.toEntity(nguoiDungDto);
        BeanUtils.copyProperties(data, entity, Utils.getNullPropertyNames(entity));
        return save(nguoiDungMapper.toDto(entity));
    }

    public NguoiDungDto findByEmail(String email) {
        NguoiDung entity = repository.findByEmail(email);
        return nguoiDungMapper.toDto(entity);
    }
    public NguoiDungDto findByUserCode(String userCode) {
        NguoiDung entity = repository.findByUserCode(userCode);
        return nguoiDungMapper.toDto(entity);
    }


}
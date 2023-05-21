package com.haivn.controller;

import com.haivn.common_api.CaTruc;
import com.haivn.dto.CaTrucDto;
import com.haivn.mapper.CaTrucMapper;
import com.haivn.repository.CaTrucRepository;
import com.haivn.service.CaTrucService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityNotFoundException;
import java.util.HashMap;
import java.util.Map;

@RequestMapping("/api/ca-truc")
@RestController
@Slf4j
@Api("ca-truc")
public class    CaTrucController {
    private final CaTrucService caTrucService;
    private final CaTrucRepository repository;
    private final CaTrucMapper caTrucMapper;

    public CaTrucController(CaTrucService caTrucService,CaTrucRepository repository,CaTrucMapper caTrucMapper) {
        this.caTrucService = caTrucService;
        this.caTrucMapper = caTrucMapper;
        this.repository = repository;
    }

    @PostMapping("/post")
    public ResponseEntity< Map<String, Object>> save(@RequestBody @Validated CaTrucDto caTrucDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            CaTrucDto item =caTrucService.save(caTrucDto);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            CaTrucDto caTruc = caTrucService.findById(id);
            result.put("result",caTruc);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        try {
            CaTruc caTruc = repository.findById(id).orElseThrow(()->new EntityNotFoundException(""));
            caTruc.setDeleted(true);
            repository.save(caTruc);
        }catch (Exception e){
        }
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<CaTruc> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<CaTruc> entityPage = repository.findAll(spec,pageable);
            result.put("result", entityPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated CaTrucDto caTrucDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            caTrucDto.setId(id);
            CaTruc entity = caTrucMapper.toEntity(caTrucDto);
            CaTruc item = repository.save(entity);
            result.put("result", item.getId());
            result.put("success",true);
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}
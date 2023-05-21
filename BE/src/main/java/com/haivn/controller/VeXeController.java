package com.haivn.controller;

import com.haivn.common_api.BaiXe;
import com.haivn.common_api.VeXe;
import com.haivn.dto.BaiXeDto;
import com.haivn.dto.VeXeDto;
import com.haivn.mapper.VeXeMapper;
import com.haivn.repository.VeXeRepository;
import com.haivn.service.VeXeService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@RequestMapping("/api/ve-xe")
@RestController
@Slf4j
@Api("ve-xe")
public class VeXeController {
    private final VeXeService veXeService;
    private final VeXeRepository repository;
    private final VeXeMapper veXeMapper;

    public VeXeController(VeXeService veXeService, VeXeRepository repository, VeXeMapper veXeMapper) {
        this.veXeService = veXeService;
        this.repository = repository;
        this.veXeMapper = veXeMapper;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated VeXeDto veXeDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            VeXe data = veXeMapper.toEntity(veXeDto);
            data.setCode(veXeDto.getCode());
            data.setBienSo(veXeDto.getBienSo());
            VeXe item =repository.save(data);
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
            VeXeDto veXe = veXeService.findById(id);
            result.put("result",veXe);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(veXeService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        veXeService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<VeXe> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<VeXe> entityPage = repository.findAll(spec,pageable);
            result.put("result", entityPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);

    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated VeXeDto veXeDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            VeXe data = veXeMapper.toEntity(veXeDto);
            data.setId(id);
            data.setCode(veXeDto.getCode());
            data.setBienSo(veXeDto.getBienSo());
            VeXe item =repository.save(data);
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
package com.haivn.controller;

import com.haivn.common_api.BaiXe;
import com.haivn.common_api.VeXe;
import com.haivn.common_api.XeLuuBai;
import com.haivn.dto.BaiXeDto;
import com.haivn.dto.XeLuuBaiDto;
import com.haivn.mapper.XeLuuBaiMapper;
import com.haivn.repository.XeLuuBaiRepository;
import com.haivn.service.XeLuuBaiService;
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

@RequestMapping("/api/xe-luu-bai")
@RestController
@Slf4j
@Api("xe-luu-bai")
public class XeLuuBaiController {
    private final XeLuuBaiService xeLuuBaiService;
    private final XeLuuBaiRepository repository;
    private final XeLuuBaiMapper xeLuuBaiMapper;

    public XeLuuBaiController(XeLuuBaiService xeLuuBaiService,XeLuuBaiRepository repository, XeLuuBaiMapper xeLuuBaiMapper) {
        this.xeLuuBaiService = xeLuuBaiService;
        this.repository = repository;
        this.xeLuuBaiMapper = xeLuuBaiMapper;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated XeLuuBaiDto xeLuuBaiDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            XeLuuBaiDto item =xeLuuBaiService.save(xeLuuBaiDto);
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
            XeLuuBaiDto xeLuuBai = xeLuuBaiService.findById(id);
            result.put("result",xeLuuBai);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(xeLuuBaiService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        xeLuuBaiService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<XeLuuBai> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<XeLuuBaiDto> xeLuuBaiPage = xeLuuBaiService.findByCondition(spec, pageable);
            result.put("result", xeLuuBaiPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated XeLuuBaiDto xeLuuBaiDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            XeLuuBai data = xeLuuBaiMapper.toEntity(xeLuuBaiDto);
            data.setId(id);
            XeLuuBai item =  repository.save(data);
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
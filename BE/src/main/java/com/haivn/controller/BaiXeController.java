package com.haivn.controller;

import com.haivn.common_api.BaiXe;
import com.haivn.dto.BaiXeDto;
import com.haivn.mapper.BaiXeMapper;
import com.haivn.repository.BaiXeRepository;
import com.haivn.service.BaiXeService;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import com.turkraft.springfilter.boot.Filter;
import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RequestMapping("/api/bai-xe")
@RestController
@Slf4j
@Api("bai-xe")
public class BaiXeController {
    private final BaiXeService baiXeService;
    private final BaiXeRepository repository;
    private final BaiXeMapper baiXeMapper;

    public BaiXeController(BaiXeService baiXeService,BaiXeRepository repository, BaiXeMapper baiXeMapper) {
        this.baiXeService = baiXeService;
        this.repository = repository;
        this.baiXeMapper = baiXeMapper;
    }

    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated BaiXeDto baiXeDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            BaiXeDto item =baiXeService.save(baiXeDto);
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
            BaiXeDto baiXe = baiXeService.findById(id);
            result.put("result",baiXe);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Boolean> delete(@PathVariable("id") Long id) {
       try{
           Optional.ofNullable(baiXeService.findById(id)).orElseThrow(() -> {
               log.error("Unable to delete non-existent data！");
               return new FileSystemNotFoundException();
           });
           baiXeService.deleteById(id);
           return ResponseEntity.ok(true);
       }catch (Exception e){
           return ResponseEntity.ok(false);
       }
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<BaiXe> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<BaiXeDto> baiXePage = baiXeService.findByCondition(spec, pageable);
            result.put("result", baiXePage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated BaiXeDto baiXeDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<>();
        try{
            BaiXe data = baiXeMapper.toEntity(baiXeDto);
            data.setId(id);
            BaiXe item = repository.save(data);
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
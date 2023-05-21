package com.haivn.controller;

import com.haivn.common_api.NguoiDung;
import com.haivn.common_api.UserLogin;
import com.haivn.dto.NguoiDungDto;
import com.haivn.handler.Utils;
import com.haivn.mapper.NguoiDungMapper;
import com.haivn.repository.NguoiDungRepository;
import com.haivn.service.NguoiDungService;
import com.turkraft.springfilter.boot.Filter;
import io.swagger.annotations.Api;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityNotFoundException;
import java.nio.file.FileSystemNotFoundException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RequestMapping("/api/nguoi-dung")
@RestController
@Slf4j
@Api("nguoi-dung")
public class NguoiDungController {
    private final NguoiDungService nguoiDungService;
    private final NguoiDungRepository repository;
    private final NguoiDungMapper nguoiDungMapper;


    public NguoiDungController(NguoiDungService nguoiDungService,NguoiDungRepository repository,NguoiDungMapper nguoiDungMapper) {
        this.nguoiDungService = nguoiDungService;
        this.repository = repository;
        this.nguoiDungMapper = nguoiDungMapper;
    }
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> loginPass(@RequestBody @Validated UserLogin userLogin) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {
            NguoiDung nguoiDung = repository.findByUserName(userLogin.getUserName());
            Boolean checkPass = BCrypt.checkpw(userLogin.getPassword(), nguoiDung.getPassword());
            if(checkPass){
                result.put("result",nguoiDung);
                result.put("success", true);
            }else {
                result.put("result", "Tài khoản / mật khẩu không đúng");
                result.put("success", false);
            }
        }catch (Exception e){
            result.put("result", "Tài khoản / mật khẩu không đúng");
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }
    @PostMapping("/post")
    public ResponseEntity<Map<String, Object>> save(@RequestBody @Validated NguoiDungDto nguoiDungDto) {
        Map<String, Object> result = new HashMap<>();
        try{
            NguoiDungDto nguoiDungCheck = nguoiDungService.findByEmail(nguoiDungDto.getEmail());
            if(nguoiDungCheck==null){
                NguoiDungDto checkUserCode = nguoiDungService.findByUserCode(nguoiDungDto.getUserCode());
                if(checkUserCode==null){
                    nguoiDungDto.setUserName(nguoiDungDto.getEmail());
                    nguoiDungDto.setPassword(Utils.getBCryptedPassword("123456"));
                    NguoiDungDto item =nguoiDungService.save(nguoiDungDto);
                    result.put("result", item.getId());
                    result.put("success",true);
                }else {
                    result.put("result","Mã nhân viên đã tồn tại");
                    result.put("success",false);
                }
            }else {
                result.put("result","Email đã được đăng ký");
                result.put("success",false);
            }
        }
        catch (Exception e){
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
    @PostMapping("/change-pass/{id}")
    public ResponseEntity<Map<String, Object>> changePass(@RequestBody @Validated UserLogin userLogin,@PathVariable("id") Long id) {
        Map<String, Object> result =new HashMap<String, Object>();
        try {
            NguoiDung nguoiDung =  repository.findById(id).orElseThrow(()
                    -> new EntityNotFoundException("Item Not Found! ID: " + id)
            );
            nguoiDung.setPassword(Utils.getBCryptedPassword(userLogin.getPassword()));
            NguoiDung item= repository.save(nguoiDung);
            result.put("result",item.getId());
            result.put("success", true);
        }catch (Exception e){
            result.put("result", "Tài khoản / mật khẩu không đúng");
            result.put("success", false);
        }
        return ResponseEntity.ok(result);
    }

    @GetMapping("/get/{id}")
    public ResponseEntity<Map<String, Object>> findById(@PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            NguoiDungDto nguoiDung = nguoiDungService.findById(id);
            result.put("result",nguoiDung);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result",e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @DeleteMapping("/del/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
        Optional.ofNullable(nguoiDungService.findById(id)).orElseThrow(() -> {
            log.error("Unable to delete non-existent data！");
            return new FileSystemNotFoundException();
        });
        nguoiDungService.deleteById(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/get/page")
    public ResponseEntity<Map<String, Object>> pageQuery(@Filter Specification<NguoiDung> spec, Pageable pageable) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            Page<NguoiDungDto> nguoiDungPage = nguoiDungService.findByCondition(spec, pageable);
            result.put("result", nguoiDungPage);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }

    @PutMapping("/put/{id}")
    public ResponseEntity<Map<String, Object>> update(@RequestBody @Validated NguoiDungDto nguoiDungDto, @PathVariable("id") Long id) {
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            nguoiDungDto.setId(id);
            NguoiDung data = nguoiDungMapper.toEntity(nguoiDungDto);
            NguoiDung item=repository.save(data);
            result.put("result", item);
            result.put("success",true);
        } catch (Exception e) {
            result.put("result", e.getMessage());
            result.put("success",false);
        }
        return ResponseEntity.ok(result);
    }
}
package com.haivn.repository;

import com.haivn.common_api.BaiXe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BaiXeRepository extends JpaRepository<BaiXe, Long>, JpaSpecificationExecutor<BaiXe> {
}
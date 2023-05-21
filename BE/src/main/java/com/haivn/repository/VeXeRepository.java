package com.haivn.repository;

import com.haivn.common_api.VeXe;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface VeXeRepository extends JpaRepository<VeXe, Long>, JpaSpecificationExecutor<VeXe> {
}
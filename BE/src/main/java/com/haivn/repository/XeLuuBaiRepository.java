package com.haivn.repository;

import com.haivn.common_api.XeLuuBai;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface XeLuuBaiRepository extends JpaRepository<XeLuuBai, Long>, JpaSpecificationExecutor<XeLuuBai> {
}
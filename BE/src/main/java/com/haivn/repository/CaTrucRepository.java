package com.haivn.repository;

import com.haivn.common_api.CaTruc;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CaTrucRepository extends JpaRepository<CaTruc, Long>, JpaSpecificationExecutor<CaTruc> {
}
package com.capstone.IngSpector.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.capstone.IngSpector.domain.User;

@Repository
public interface UserRepository extends CrudRepository<User,String>{

}

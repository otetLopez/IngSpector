package com.capstone.IngSpector.domain;

import java.io.Serializable;
import java.util.ArrayList;

import javax.persistence.Column;
import javax.persistence.Entity;

import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table(name="User")
public class User implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	@Id
	@Column(name="email")

	
	private String email;
	
	@Column(name="password")
	private String password;
	@Column(name="name")
	private String name;
	@Column(name="height")
	private String height;
	@Column(name="weight")
	private String weight;
	
	@Column(name="allergens")
	private String allergens; 
	@Column(name="allergicfoods")
	private String allergicFoods;
	
	public User() {
		
	}
	

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getHeight() {
		return height;
	}

	public void setHeight(String height) {
		this.height = height;
	}

	public String getWeight() {
		return weight;
	}

	public void setWeight(String weight) {
		this.weight = weight;
	}

	public String getAllergens() {
		return allergens;
	}

	public void setAllergens(String allergens) {
		this.allergens = allergens;
	}

	public String getAllergicFoods() {
		return allergicFoods;
	}

	public void setAllergicFoods(String allergicFoods) {
		this.allergicFoods = allergicFoods;
	}


	
	
	
	
	

}

package com.capstone.IngSpector.services;

import java.util.ArrayList;
import java.util.Arrays;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.capstone.IngSpector.domain.User;
import com.capstone.IngSpector.repository.UserRepository;

@Service
public class UserService {
	
	@Autowired
	private UserRepository userRepository;
	
	public ArrayList allUsersEmails() {
		
		ArrayList<String> users = new ArrayList<>();
		userRepository.findAll().forEach(t-> users.add(t.getEmail()));

		return users;
		
	}
	
public String usersAllergens(String email) {
		
		String allergens = "";
		User user = userRepository.findOne(email);
		
		if(user.getAllergens() == null) {
			allergens="Empty";
		}
		
		else {
			allergens = user.getAllergens();
		}
		
		return allergens;
		
	}

public String usersAllergicFoods(String email) {

	String allergicFoods="";
	User user = userRepository.findOne(email);
	if(user.getAllergicFoods() == null) {
		allergicFoods="Empty";
	}
	
	else {
		allergicFoods = user.getAllergicFoods();
	}
	
	return allergicFoods;
	
}

public boolean checkExistenceofUserEmail(String email) {
	boolean result = false;
	ArrayList<String> users = new ArrayList<>();
	userRepository.findAll().forEach(t-> users.add(t.getEmail()));

	
	for(int i =0 ; i<users.size() ; i++) {
		if(users.get(i).equals(email)) {
			result = true;
			break;
		}
		
		else {
			result = false;
		}
	}

	return result;
	
}

//return false if user exists
public boolean addNewUser(String email , String password , String name , String height , String weight , String allergens) {
	
	boolean existence = this.checkExistenceofUserEmail(email);
	boolean result = false;
	//Add user
	if(existence == false) {
		User user = new User();
		user.setEmail(email);
		user.setPassword(password);
		user.setName(name);
		user.setHeight(height);
		user.setWeight(weight);
		user.setAllergens(allergens);
		user.setAllergicFoods("");
		
		userRepository.save(user);
		result = true;
	}
		
	
	return result;
}

public void addAllergicFood (String email , String allergicFood) {
	User user = userRepository.findOne(email);
	String allergicFoods = user.getAllergicFoods();
	ArrayList<String> allergicFoodList = new ArrayList();

	if(!allergicFoods.equals("")){
	allergicFoodList = new ArrayList<String>(Arrays.asList(allergicFoods.split(",")));
	allergicFoodList.add(allergicFood);
	allergicFoods = allergicFoodList.toString();

	}
	else {
		allergicFoodList.add(allergicFood);
		allergicFoods = allergicFoodList.toString();
		
	}
	
	

	allergicFoods = allergicFoods.replaceAll("[\\[\\](){}]","");
	user.setAllergicFoods(allergicFoods);

	userRepository.save(user);
	
}

//string should be sent with following format-> abc,cde,def
public void addAllergens (String email , String allergens) {
	User user = userRepository.findOne(email);
	user.setAllergens(allergens);

	userRepository.save(user);
	
	}

public void removeAllergen (String email , String allergen) {
	User user = userRepository.findOne(email);
	String allAllergens = user.getAllergens();
	ArrayList<String> allergenList = new ArrayList<String>(Arrays.asList(allAllergens.split(",")));

	for(int i = 0 ; i<allergenList.size() ; i++) {
		if(allergenList.get(i).equals(allergen)) {
			allergenList.remove(i);
			break;
		}
	}
	
	allAllergens = allergenList.toString();

	allAllergens = allAllergens.replaceAll("[\\[\\](){}]","");
	user.setAllergens(allAllergens);

	userRepository.save(user);
	
}

public void updateUser (String email , String allergens , String height , String weight) {
	User user = userRepository.findOne(email);
	user.setAllergens(allergens);
	user.setHeight(height);
	user.setWeight(weight);
	userRepository.save(user);
	
	}

//return true if login successful
public boolean login (String email , String password ) {
	boolean existence=	this.checkExistenceofUserEmail(email);
	boolean result=false;
	
	if(existence) {
		User user = userRepository.findOne(email);
		if(user.getPassword().equals(password)) {
			result=true;
		}
	}


	return result;

	}

public User userInformation(String email) {
	User user = userRepository.findOne(email);
	return user;
}
}
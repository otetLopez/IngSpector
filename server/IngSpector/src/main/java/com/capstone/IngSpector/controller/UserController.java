package com.capstone.IngSpector.controller;

import java.util.ArrayList;
import java.util.Arrays;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;

import com.capstone.IngSpector.domain.User;
import com.capstone.IngSpector.services.UserService;


@RestController
@RequestMapping("/ingspector")
public class UserController {

	@Autowired
	private UserService userService;
	
	@RequestMapping
	public String test() {
		return "Hello Test";
	}
	
	

	@RequestMapping("/getallemails")
	public ArrayList allEmails() {

		return userService.allUsersEmails();
	}
	

	@RequestMapping("/getallallergens/{email}/get")
	public ArrayList allAllergens(@PathVariable String email) {
		String allergens = userService.usersAllergens(email);
		ArrayList<String> outputList = new ArrayList<String>(Arrays.asList(allergens.split(",")));
		return outputList;
	}
	

	@RequestMapping("/getallallergicfoodlist/{email}/get")
	public ArrayList allAllergicFoods(@PathVariable String email) {
		String allergicFoods = userService.usersAllergicFoods(email);
		ArrayList<String> outputList = new ArrayList<String>(Arrays.asList(allergicFoods.split(",")));
		return outputList;
	}
	

	@RequestMapping(method= RequestMethod.GET , value = "/adduser/{email}/{password}/{name}/{height}/{weight}/{allergens}")
	public boolean addUser(@PathVariable String email , @PathVariable String password, @PathVariable String name ,@PathVariable String height , @PathVariable String weight , @PathVariable String allergens) {
		boolean result = userService.addNewUser(email, password , name , height , weight , allergens);
		return result;
		
	}
	
	@RequestMapping(method= RequestMethod.GET , value = "/addallergicfood/{email}/{allergicfood}")
	public void addAllergicFoodToUser(@PathVariable String email , @PathVariable String allergicfood) {
		userService.addAllergicFood(email, allergicfood);

	}
	
	@RequestMapping(method= RequestMethod.GET , value = "/addallergens/{email}/{allergens}")
	public void addAllergensToUser(@PathVariable String email , @PathVariable String allergens) {
		userService.addAllergens(email, allergens);

	}

	@RequestMapping(method= RequestMethod.GET , value = "/removeallergen/{email}/{allergen}")
	public void removeUserAllergen(@PathVariable String email , @PathVariable String allergen) {
		userService.removeAllergen(email, allergen);

	}
	
	@RequestMapping(method= RequestMethod.GET , value = "/updateuser/{email}/{allergen}/{height}/{weight}")
	public void updateUserProfile(@PathVariable String email , @PathVariable String allergen , @PathVariable String height , @PathVariable String weight) {
		userService.updateUser(email, allergen , height , weight);

	}

	@RequestMapping(method= RequestMethod.GET , value = "/userlogin/{email}/{password}")
	public boolean userLoginCheck(@PathVariable String email , @PathVariable String password ) {
		boolean result = userService.login(email, password);
		return result;
	}
	
	@RequestMapping(method= RequestMethod.GET , value = "/userinfo/{email}/get")
	public User userLoginCheck(@PathVariable String email ) {
		User user = userService.userInformation(email);
		return user;
	}
}

//
//  DefaultsAccess.swift
//  IngSpector
//
//  Created by otet_tud on 4/12/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import Foundation

class DefaultsAccess {
    func setFromUserDefaults() -> UserDetails {
        let email : String = UserDefaults.standard.string(forKey: "email") ?? ""
        let password : String = UserDefaults.standard.string(forKey: "password") ?? ""
        let name: String = UserDefaults.standard.string(forKey: "name") ?? ""
        let height : Double = UserDefaults.standard.double(forKey: "height")
        let weight : Double = UserDefaults.standard.double(forKey: "weight")
        let allergenList : [String] = UserDefaults.standard.stringArray(forKey: "allergenList") ?? [String]()
        let foodList : [String] = UserDefaults.standard.stringArray(forKey: "foodList") ?? [String]()
        return UserDetails(name: name, eadd: email, height: height, weight: weight, passwd: password, allergens: allergenList, food: foodList)
    }
    
    func setToUserDefaults(user: UserDetails) {
        UserDefaults.standard.set(user.getEmail(), forKey: "email")
        UserDefaults.standard.set(user.getPassword(), forKey: "password")
        UserDefaults.standard.set(user.getName(), forKey: "name")
        UserDefaults.standard.set(user.getHeight(), forKey: "height")
        UserDefaults.standard.set(user.getWeight(), forKey: "weight")
        UserDefaults.standard.set(user.getAllergens(), forKey: "allergenList")
        UserDefaults.standard.set(user.getFoodList(), forKey: "foodList")
    }
    
    func removeUserFromDefaults() {
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "password")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "height")
        UserDefaults.standard.removeObject(forKey: "weight")
        UserDefaults.standard.removeObject(forKey: "allergenList")
        UserDefaults.standard.removeObject(forKey: "foodList")
    }
    
    func getEmailFromDefaults() -> String {
        return UserDefaults.standard.string(forKey: "email") ?? ""
    }
    
    func getFoodListFromDefaults() -> [String] {
        return UserDefaults.standard.stringArray(forKey: "foodList") ?? [String]()
    }
    
    func setFoodListToDefaults(foodList: [String]) {
        UserDefaults.standard.set(foodList, forKey: "foodList")
    }
}

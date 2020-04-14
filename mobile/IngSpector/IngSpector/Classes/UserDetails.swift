//
//  UserDetails.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import Foundation

class UserDetails : CustomStringConvertible {
    
    private var name : String
    private var eadd : String
    private var height : Double
    private var weight : Double
    private var passwd : String
    private var allergens : [String]
    private var food : [String]
    
    init(name: String, eadd: String, height: Double, weight: Double, passwd: String, allergens: [String], food: [String]) {
        self.name = name
        self.eadd = eadd
        self.height = height
        self.weight = weight
        self.passwd = passwd
        self.allergens = allergens
        self.food = food
    }
    
    init() {
        self.name = ""
        self.eadd = ""
        self.height = 0.0
        self.weight = 0.0
        self.passwd = ""
        self.allergens = [String]()
        self.food = [String]()
    }
    
    var description: String {
        var detailStr = "--------------------------------\nName: \(name)\nEmail: \(eadd)\nPassword: \(passwd)\nHeight: \(height)\nWeight: \(weight)\nAllergens:\n"
        for idx in allergens {
            detailStr += "\t \(idx)\n"
        }
        detailStr += "\nFood List:\n"
        for idx in food {
            detailStr += "\t \(idx)\n"
        }
        detailStr += "--------------------------------\n"
        return detailStr
    }

    /* Getters */
    public func getName() -> String { return self.name }
    
    public func getEmail() -> String { return self.eadd }
    
    public func getHeight() -> Double { return self.height }
    
    public func getWeight() -> Double { return self.weight }
    
    public func getPassword() -> String { return self.passwd }
    
    public func getAllergens() -> [String] { return self.allergens }
    
    public func getFoodList() -> [String] { return self.food }
    
    
    /* Setters */
    public func setName(name: String) { self.name = name }
    
    public func setEmail(eadd: String) { self.eadd = eadd }
    
    public func setHeight(height: Double) { self.height = height }

    public func setWeight(weight: Double) { self.weight = weight }
    
    public func setAllergens(allergens: [String]) { self.allergens = allergens }
    
    public func setFood(food: [String]) { self.food = food }
    

}

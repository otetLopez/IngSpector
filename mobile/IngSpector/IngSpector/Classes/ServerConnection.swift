//
//  ServerConnection.swift
//  IngSpector
//
//  Created by otet_tud on 4/11/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServerConnection {
    private var url : String
    
    init() {
        self.url = "http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/"
    }
    
    init(url: String) { self.url = url }
    
    public func setURL(url: String) { self.url = url }
    public func getURL() -> String { return self.url }
    public func getURLlogin() -> String {
        /* http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/userlogin/t@d.com/1234 */
        return (self.url + "userlogin/")
    }
    
    public func getURLreg() -> String {
        /* http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/adduser/rosette@test.com/123456/rosette/170/50/peanut,milk */
        return (self.url + "adduser/")
    }
    
    public func getURLinfo() -> String {
        /* http://72.137.45.112:8080/ingSpectorMobileServices/ingspector/userinfo/rosette@test.com/get */
        return (self.url + "userinfo/")
    }
    
    public func getURLupd() -> String {
        return (self.url + "updateuser/")
    }
    
    private func parseList(toParse: String) -> [String] {
        let parsed : [String] = toParse.split{$0 == ","}.map(String.init)
        return parsed
    }
    
    public func parseUserInfo(dataJSON: JSON) -> UserDetails {
        var user : UserDetails = UserDetails()
        if let email = dataJSON["email"].string {
            let password = (dataJSON["password"].string)!
            let name = (dataJSON["name"].string)!
            let height = (dataJSON["height"].string)!
            let weight = (dataJSON["weight"].string)!
            let allergens = (dataJSON["allergens"].string)!
            let allergicFoods = (dataJSON["allergicFoods"].string)!
            
            var allergenList = [String]()
            if(allergens.count > 0) {
                allergenList = parseList(toParse: allergens)
                var idxes : [Int] = [Int]()
                for (index, element) in allergenList.enumerated() {
                    print("Item \(index): \(element)")
                    if element == "empty" {
                        idxes.append(index)
                    }
                }
                for idx in idxes { allergenList.remove(at: idx) }
            }
            
            var foodList = [String]()
            if(allergicFoods.count > 0) {
                foodList = parseList(toParse: allergicFoods)
                for idx in foodList {
                    print("DEBUG: FoodList -> \(idx)")
                }
            }
            user = UserDetails(name: name, eadd: email, height: Double(height)!, weight: Double(weight)!, passwd: password, allergens: allergenList, food: foodList)
        }
        return user
    } 
}

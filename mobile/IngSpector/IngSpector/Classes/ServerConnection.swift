//
//  ServerConnection.swift
//  IngSpector
//
//  Created by otet_tud on 4/11/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import Foundation

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
}

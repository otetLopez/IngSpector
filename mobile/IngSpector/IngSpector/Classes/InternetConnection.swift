//
//  InternetConnection.swift
//  IngSpector
//
//  Created by otet_tud on 4/11/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import Foundation
import Reachability

class InternetConnection {
    
    public func isConnected() -> Bool {
        let reachability = Reachability.forInternetConnection()
        return (reachability?.isReachable())!
    }
}

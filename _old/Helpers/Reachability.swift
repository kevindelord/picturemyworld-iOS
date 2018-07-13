//
//  Reachability.swift
//  Eismann
//
//  Created by Kevin Delord on 12/10/16.
//  Copyright © 2016 Smart Mobile Factory. All rights reserved.
//

import Foundation
import Reachability

extension Reachability {

    static var isConnected : Bool {
        let reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus = reachability.currentReachabilityStatus()
        return (networkStatus != .NotReachable)
    }
}

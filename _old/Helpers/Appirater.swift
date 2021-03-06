//
//  Appirater.swift
//  BusMedellin
//
//  Created by Kevin Delord on 13/10/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import Appirater

extension Appirater {

    class func setup() {
        Appirater.setAppId(NSBundle.entryInPListForKey(PWPlist.AppId) as? String)
        Appirater.setAlwaysUseMainBundle(true)
        Appirater.setDaysUntilPrompt(7)
        Appirater.setUsesUntilPrompt(7)
        Appirater.setSignificantEventsUntilPrompt(0)
        Appirater.setTimeBeforeReminding(7)
        Appirater.setDebug(Configuration.DebugAppirater)
        Appirater.appLaunched(true)
    }
}

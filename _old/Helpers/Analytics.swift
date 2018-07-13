//
//  Analytics.swift
//  BusMedellin
//
//  Created by Kevin Delord on 24/10/16.
//  Copyright © 2016 Kevin Delord. All rights reserved.
//

import Foundation
import Firebase

struct Analytics {

     static func setup() {

        // Check if the analytics is enabled
        guard (Configuration.AnalyticsEnabled == true) else {
            return
        }

        // Firebase
        Firebase.setup()

        // Google Analytics
        GoogleAnalytics.setup()
    }

    // MARK: - Send Actions

    private static func send(category: String, action: String, label: String?, value: NSNumber?) {

        // Check if the analytics is enabled
        guard (Configuration.AnalyticsEnabled == true) else {
            return
        }

        // Google Analytics
        GoogleAnalytics.send(category, action: action, label: label, value: value)

        // Firebase
        Firebase.send(category, action: action, label: label, value: value)
    }

    static func sendScreenView(screen: Analytics.Screen) {

        // Check if the analytics is enabled
        guard (Configuration.AnalyticsEnabled == true) else {
            return
        }

        // Google Analytics
        GoogleAnalytics.sendScreenView(screen)

        // Firebase
        Firebase.sendScreenView(screen)
    }

    // MARK: - Actions type

    enum Screen                             : String {

        case CollectionView					= "Screen_CollectionView"
        case Slideshow                      = "Screen_Slideshow"

		var className : String {
			switch self {
			case .CollectionView: 			return "PWCollectionViewController"
			case .Slideshow:				return "FullScreenSlideshowViewController"
			}
		}
    }

    enum UserAction                       	: String {

        static let CategoryId               = "UserAction"

		case DidSelectItemCell				= "UserAction_DidSelectItemCell"
		case DidChangeDeviceOrientation		= "UserAction_DidChangeDeviceOrientation"
		case DidCloseSlideshow				= "UserAction_DidCloseSlideshow"
		case DidScrollCollectionView		= "UserAction_DidScrollCollectionView"
		case DidScrollSlideshow				= "UserAction_DidScrollSlideshow"
		case DidOpenInfoView				= "UserAction_DidOpenInfoView"
		case DidCloseInfoView				= "UserAction_DidCloseInfoView"
		case DidZoomImage					= "UserAction_DidZoomImage"
		case DidHideCloseButton				= "UserAction_DidHideCloseButton"
		case DidShowCloseButton				= "UserAction_DidShowCloseButton"
		case DidPullToRefresh				= "UserAction_DidPullToRefresh"
		case DidLoadWithoutInternet			= "UserAction_DidLoadWithoutInternet"

        func send() {
            let category = Analytics.UserAction.CategoryId
            Analytics.send(category, action: self.rawValue, label: nil, value: nil)
        }
    }
}

// MARK: - Google Analytics

private struct GoogleAnalytics {

    static func setup() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")

        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true // Report uncaught exceptions
        #if RELEASE
            gai.logger.logLevel = .Error
        #else
            gai.logger.logLevel = (Verbose.Manager.Analytics == true ? .Verbose : .None)
        #endif
    }

    // MARK: - Send Actions

    private static func send(category: String, action: String, label: String?, value: NSNumber?) {
        let event = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value)
        let dictionary = event.build() as [NSObject:AnyObject]
        GAI.sharedInstance().defaultTracker.send(dictionary)
    }

    static func sendScreenView(screen: Analytics.Screen) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: screen.rawValue)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}

// MARK: - Firebase

private struct Firebase {

    private static func setup() {
        // Use Firebase library to configure APIs
        FIRApp.configure()
    }

    private static func send(category: String, action: String, label: String?, value: NSNumber?) {
        var params : [String : NSObject] = [kFIRParameterContentType: action, kFIRParameterItemCategory: category]
        if let _label = label {
            params[kFIRParameterItemName] = _label
        }
        if let _value = value {
            params[kFIRParameterValue] = _value
        }
        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: params)
    }

    static func sendScreenView(screen: Analytics.Screen) {
		FIRAnalytics.setScreenName(screen.rawValue, screenClass: screen.className)
    }
}

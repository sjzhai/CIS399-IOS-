//
//  AppDelegate.swift
//  LendingLibrary
//
//  Created by Charles Augustine.
//
//


import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	// MARK: UIApplicationDelegate
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
			// Nothing to do here.  If no permissions are not granted the user will be notified when they attempt to
			// enable notifications.
		}
		UNUserNotificationCenter.current().delegate = self

		return true
	}

	// MARK: UNUserNotificationCenterDelegate
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		// This method is used to user actions from the notification, response.actionIdentifier can be used to determine
		// what action was taken.  After the action is handled, the completionHandler must be called
		completionHandler()
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		// This method is invoked when a notification is recieved while the app is in the foreground.  Custom logic to
		// handle the notification is inserted here, and then the completionHandler is invoked to let the system know
		// how it should present the notification (if at all)
		completionHandler([.alert, .sound])
	}

	// MARK: Properties (UIApplicationDelegate)
	var window: UIWindow?
}


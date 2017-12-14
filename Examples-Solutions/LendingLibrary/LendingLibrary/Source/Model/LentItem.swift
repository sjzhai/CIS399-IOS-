//
//  LentItem.swift
//  LendingLibrary
//


import CoreData
import UIKit
import UserNotifications


public class LentItem: NSManagedObject {
	// MARK: NSManagedObject
	public override func didSave() {
		super.didSave()

		// Make local constants so the completion handler closures below don't capture the CoreData entity
		let identifier = objectID.uriRepresentation().absoluteString
		let isDeleted = self.isDeleted
		let notify = self.notify!
		let dateToReturn = self.dateToReturn!

		let title = "Borrowed Item Reminder"
		let body = "\(borrower!) should return \(name!) soon."

		// Only handle notifications when dealing with objects in the viewContext
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			if settings.authorizationStatus  == .authorized {
				if LendingLibraryService.shared.isInViewContext(self) {
					if !isDeleted && notify.boolValue && dateToReturn.earlierDate(Date()) != dateToReturn as Date {
						let content = UNMutableNotificationContent()
						content.title = title
						content.body = body
						content.sound = UNNotificationSound.default()

						let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dateToReturn as Date)
						let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

						let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

						UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
					}
					else {
						UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])

						if isDeleted || !notify.boolValue {
							UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
						}
					}
				}
			}
		}
	}
}

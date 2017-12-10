//
//  UITableView_KeyboardNotification.swift
//  Assignment6
//


import UIKit


extension UITableView {
	func adjustInsets(forWillShowKeyboardNotification notification: Notification) {
		if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>, let rectValue = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let convertedRect = self.superview?.convert(rectValue, from: nil), let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
			UIView.animate(withDuration: animationDuration, animations: { () -> Void in
				var contentInset = self.contentInset
				contentInset.bottom = convertedRect.height
				self.contentInset = contentInset
				self.scrollIndicatorInsets = contentInset
			})
		}
	}

	func adjustInsets(forWillHideKeyboardNotification notification: Notification) {
		if let userInfo = notification.userInfo as? Dictionary<String, AnyObject>, let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
			UIView.animate(withDuration: animationDuration, animations: { () -> Void in
				var contentInset = self.contentInset
				contentInset.bottom = 0.0
				self.contentInset = contentInset
				self.scrollIndicatorInsets = contentInset
			})
		}
	}
}

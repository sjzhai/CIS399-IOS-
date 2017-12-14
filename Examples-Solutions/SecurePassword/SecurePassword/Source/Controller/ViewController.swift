//
//  ViewController.swift
//  SecurePassword
//


import UIKit


class ViewController: UIViewController {
	// MARK: IBAction
	@IBAction private func promptForPassword(_ sender: AnyObject) {
		let alertController = UIAlertController(title: "Please Login", message: "Enter your password", preferredStyle: .alert)
		alertController.addTextField { (textField) in
			textField.isSecureTextEntry = true
			textField.placeholder = "Password"
			textField.autocapitalizationType = .none
			textField.autocorrectionType = .no
		}
		alertController.view.setNeedsLayout() // This line keeps some internal bits of the alert controller from printing layout errors
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
			if let password = alertController.textFields?.first?.text, !password.isEmpty {
				self.storePassword(password, inKeychain: self.secureSwitch.isOn)
			}
			else {
				self.clearPassword(sender)
			}
		}))

		present(alertController, animated: true, completion: nil)
	}

	@IBAction private func showPassword(_ sender: AnyObject) {
		var password: String?
		if secureSwitch.isOn {
			if let passwordData = KeychainService.shared.passwordData(forAccount: ViewController.AccountPasswordKey) {
				password = String(data: passwordData, encoding: .utf8)
			}
		}
		else {
			password = UserDefaults.standard.string(forKey: ViewController.AccountPasswordKey)
		}

		let alertController: UIAlertController
		if let somePassword = password, !somePassword.isEmpty {
			alertController = UIAlertController(title: "Found Password", message: "Your stored password is \(somePassword)", preferredStyle: .alert)
		}
		else {
			alertController = UIAlertController(title: "No Password Found", message: nil, preferredStyle: .alert)
		}
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

		present(alertController, animated: true, completion: nil)
	}

	@IBAction private func clearPassword(_ sender: AnyObject) {
		UserDefaults.standard.removeObject(forKey: ViewController.AccountPasswordKey)
		UserDefaults.standard.synchronize()
		let _ = KeychainService.shared.deletePasswordData(forAccount: ViewController.AccountPasswordKey)

		let alertController = UIAlertController(title: "Password Cleared", message: nil, preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

		present(alertController, animated: true, completion: nil)
	}

	// MARK: Private
	private func storePassword(_ password: String, inKeychain: Bool) {
		print("Simulator location: \(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first)")

		if inKeychain {
			print("Storing password in the keychain.")
			if let passwordData = password.data(using: .utf8) {
				let _ = KeychainService.shared.update(passwordData: passwordData, forAccount: ViewController.AccountPasswordKey)
			}
			else {
				let alertController = UIAlertController(title: "Error storing password in keychain", message: nil, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

				present(alertController, animated: true, completion: nil)
			}
		}
		else {
			UserDefaults.standard.set(password, forKey: ViewController.AccountPasswordKey)
			UserDefaults.standard.synchronize()
		}
	}

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var secureSwitch: UISwitch!

	// MARK: Properties (Private Static Constant)
	private static let AccountPasswordKey = "AccountPasswordKey"
}


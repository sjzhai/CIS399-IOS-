//
//  LentItemDetailViewController.swift
//  LendingLibrary
//
//  Created by Charles Augustine.
//
//


import Contacts
import ContactsUI
import MessageUI
import MobileCoreServices
import UIKit
import UserNotifications


class LentItemDetailViewController: UITableViewController, UITextFieldDelegate, CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
	// MARK: IBAction
	@IBAction private func cancel(_ sender: AnyObject) {
		delegate.lentItemDetailViewControllerDidFinish(self)
	}

	@IBAction private func save(_ sender: AnyObject) {
		if let someBorrowerID = borrowerID {
			do {
				try LendingLibraryService.shared.addLentItem(withName: name, borrower: borrower, borrowerID: someBorrowerID, dateBorrowed: dateBorrowed, dateToReturn: dateToReturn, reminder: reminder, and: picture, in: selectedCategory)

				delegate.lentItemDetailViewControllerDidFinish(self)
			}
			catch _ {
				let alertController = UIAlertController(title: "Save failed", message: "Failed to save the new lent item", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				present(alertController, animated: true, completion: nil)
			}
		}
		else {
			let alertController = UIAlertController(title: "Borrower required", message: "Please select a borrower from your contacts", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}

	@IBAction private func datePickerDidChange(_ sender: UIDatePicker) {
		if dateBorrowedTextField.isFirstResponder {
			dateBorrowed = sender.date
			dateBorrowedLabel.text = dateFormatter.string(from: dateBorrowed)
			if (dateToReturn as NSDate).earlierDate(dateBorrowed) == dateToReturn {
				dateToReturn = dateBorrowed
				dateToReturnLabel.text = dateFormatter.string(from: dateToReturn)
			}
		}
		else {
			dateToReturn = sender.date
			dateToReturnLabel.text = dateFormatter.string(from: dateToReturn)
			if (dateToReturn as NSDate).earlierDate(dateBorrowed) == dateToReturn {
				dateBorrowed = dateToReturn
				dateBorrowedLabel.text = dateFormatter.string(from: dateBorrowed)
			}
		}
	}

	@IBAction private func datePickerDidFinish(_ sender: AnyObject) {
		view.endEditing(true)
	}

	@IBAction private func reminderSwitchToggled(_ sender: AnyObject) {
		checkNotificationAuthorizationStatus { (authorized) in
			if authorized {
				self.reminder = self.reminderSwitch.isOn
			}
			else {
				self.reminder = false
				self.reminderSwitch.setOn(false, animated: true)
			}
		}
	}

	@IBAction private func clearPicture(_ sender: AnyObject) {
		self.view.endEditing(true)

		let alertController = UIAlertController(title: nil, message: "Are you sure you want to delete the picture?", preferredStyle: .actionSheet)
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		alertController.addAction(UIAlertAction(title: "Delete Picture", style: .destructive, handler: { (action: UIAlertAction) -> Void in
			self.picture = nil

			self.updateUIForPicture()
		}))

		present(alertController, animated: true, completion: nil)
	}


	@IBAction private func sendReminderEmail(_ sender: AnyObject) {
		checkContactAuthorizationStatus() {
			var success = false
			if let borrowerID = self.borrowerID {

				let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactEmailAddressesKey as CNKeyDescriptor])
				fetchRequest.predicate = CNContact.predicateForContacts(withIdentifiers: [borrowerID])

				let contactStore = CNContactStore()
				var borrowerContact: CNContact? = nil
				do {
					try contactStore.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
						borrowerContact = contact
						stop.pointee = true
					})

					if let someBorrowerContact = borrowerContact, let emailAddress = someBorrowerContact.emailAddresses.first?.value as? String {
						success = true
						self.presentMailCompositionView(withRecipient: emailAddress)
					}
					else {
						print("Contact not found or contact has no email address")
					}
				}
				catch let error {
					print("Error trying to enumerate contacts: \(error as NSError)")
				}
			}
			else {
				print("No borrower ID set")
			}

			if !success {
				let alertController = UIAlertController(title: "No Recipient Found", message: "Could not send reminder to \(self.borrower)", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alertController, animated: true, completion: nil)
			}
		}
	}

	// MARK: UITableViewDelegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch LentItemRow.items[indexPath.row] {
		case .name:
			nameTextField.becomeFirstResponder()
		case .borrower:
			self.presentContactPicker()
		case .dateBorrowed:
			datePicker.date = dateBorrowed
			dateBorrowedTextField.becomeFirstResponder()
		case .dateToReturn:
			datePicker.date = dateToReturn
			dateToReturnTextField.becomeFirstResponder()
		case .reminder:
			checkNotificationAuthorizationStatus({ (authorized) in
				if authorized {
					self.reminder = !self.reminder
					self.reminderSwitch.setOn(self.reminder, animated: true)
				}
				else {
					self.reminder = false
					self.reminderSwitch.setOn(false, animated: true)
				}
			})
		case .picture:
			if picture == nil {
				let alertController = UIAlertController(title: nil, message: "Pick Image Source", preferredStyle: .actionSheet)

				let checkSourceType = { (sourceType: UIImagePickerControllerSourceType, buttonText: String) -> Void in
					if UIImagePickerController.isSourceTypeAvailable(sourceType) {
						alertController.addAction(UIAlertAction(title: buttonText, style: .default, handler: self.imagePickerControllerSourceTypeActionHandler(for: sourceType)))
					}
				}
				checkSourceType(.camera, "Camera")
				checkSourceType(.photoLibrary, "Photo Library")
				checkSourceType(.savedPhotosAlbum, "Saved Photos Album")

				if !alertController.actions.isEmpty {
					alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

					present(alertController, animated: true, completion: nil)
				}
			}
		}
	}

	// MARK: UITextFieldDelegate
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		name = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		nameTextField.resignFirstResponder()

		return false
	}

	// MARK: CNContactPickerDelegate
	func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
		borrowerID = contact.identifier
		let contactFormatter = CNContactFormatter()
		contactFormatter.style = .fullName
		if let someName = contactFormatter.string(from: contact) {
			borrower = someName
		}
		else {
			borrower = "Unnamed"
		}

		dismiss(animated: true, completion: nil)
	}

	func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: UIImagePickerControllerDelegate
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		// First check for an edited image, then the original image
		if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
			picture = image
		}
		else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			picture = image
		}

		updateUIForPicture()

		dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: MFMailComposeViewControllerDelegate
	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: Private
	private func checkContactAuthorizationStatus(_ contactOperation: @escaping () -> Void) {
		switch CNContactStore.authorizationStatus(for: .contacts) {
		case .authorized:
			contactOperation()
		case .notDetermined:
			let contactStore = CNContactStore()
			contactStore.requestAccess(for: .contacts, completionHandler: { (granted: Bool, error: Error?) -> Void in
				if granted {
					contactOperation()
				}
				else {
					let alertController = UIAlertController(title: "Contacts Error", message: "Contacts access is required, please check your privacy settings and try again.", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					self.present(alertController, animated: true, completion: nil)
				}
			})
		default:
			let alertController = UIAlertController(title: "Contacts Error", message: "Contacts access is required, please check your privacy settings and try again.", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}

	private func presentContactPicker() {
		checkContactAuthorizationStatus {
			let contactPickerViewController = CNContactPickerViewController()
			contactPickerViewController.delegate = self
			self.present(contactPickerViewController, animated: true, completion: nil)
		}
	}

	private func updateUIForPicture(animated: Bool = true) {
		if animated {
			if let somePicture = picture, pictureImageView.isHidden {
				pictureImageView.image = somePicture
				self.pictureImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: CGFloat(-M_PI))
				pictureImageView.isHidden = false
				clearPictureButton.alpha = 0.0
				clearPictureButton.isHidden = false

				UIView.animate(withDuration: 0.2, animations: { () -> Void in
					self.pictureImageView.transform = CGAffineTransform.identity
					self.clearPictureButton.alpha = 1.0
					self.addPictureLabel.alpha = 0.0
				}, completion: { (complete) -> Void in
					self.addPictureLabel.alpha = 1.0
					self.addPictureLabel.isHidden = true
				})
			}
			else {
				addPictureLabel.alpha = 0.0
				addPictureLabel.isHidden = false

				UIView.animate(withDuration: 0.2, animations: { () -> Void in
					self.pictureImageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: CGFloat(M_PI))
					self.clearPictureButton.alpha = 0.0
					self.addPictureLabel.alpha = 1.0
				}, completion: { (complete) -> Void in
					self.pictureImageView.image = nil
					self.pictureImageView.transform = CGAffineTransform.identity
					self.pictureImageView.isHidden = true
					self.clearPictureButton.alpha = 1.0
					self.clearPictureButton.isHidden = true
				})
			}
		}
		else {
			if let somePicture = picture {
				pictureImageView.isHidden = false
				pictureImageView.image = somePicture
				clearPictureButton.isHidden = false
				addPictureLabel.isHidden = true
			}
			else {
				pictureImageView.isHidden = true
				pictureImageView.image = nil
				clearPictureButton.isHidden = true
				addPictureLabel.isHidden = false
			}
		}
	}

	private func checkNotificationAuthorizationStatus(_ notificationOperation: @escaping (Bool) -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			let authorized = settings.authorizationStatus == .authorized
			if !authorized {
				let alertController = UIAlertController(title: "Notifications Not Allowed", message: "Check your privacy settings and try again", preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
				self.present(alertController, animated: true, completion: nil)
			}

			// This callback happens off the main queue, so dispatch the notification operation back to the main queue
			DispatchQueue.main.async {
				notificationOperation(authorized)
			}
		}
	}

	private func presentMailCompositionView(withRecipient recipient: String) {
		if MFMailComposeViewController.canSendMail() {
			let mailComposeViewController = MFMailComposeViewController()
			mailComposeViewController.mailComposeDelegate = self

			mailComposeViewController.setToRecipients([recipient])
			mailComposeViewController.setSubject("Reminder")
			mailComposeViewController.setMessageBody("Please remember to return \(name) at your earliest convenience", isHTML: false)

			present(mailComposeViewController, animated: true, completion: nil)
		}
		else {
			let alertController = UIAlertController(title: "Cannot Send Email", message: "Please got to your Settings app and configure an email account", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		}
	}

	private func imagePickerControllerSourceTypeActionHandler(for sourceType: UIImagePickerControllerSourceType) -> (_ action: UIAlertAction) -> Void {
		return { (action) in
			let imagePickerController = UIImagePickerController()
			imagePickerController.delegate = self
			imagePickerController.sourceType = sourceType
			imagePickerController.mediaTypes = [kUTTypeImage as String] // Import the MobileCoreServices framework to use kUTTypeImage (see top of file)
			imagePickerController.allowsEditing = true

			self.present(imagePickerController, animated: true, completion: nil)
		}
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if selectedLentItem != nil {
			navigationItem.title = "Edit Lent Item"
			navigationItem.leftBarButtonItem = nil
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(LentItemDetailViewController.sendReminderEmail(_:)))
		}
		else {
			navigationItem.title = "Add Lent Item"
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(LentItemDetailViewController.cancel(_:)))
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(LentItemDetailViewController.save(_:)))
		}

		nameTextField.text = name
		borrowerLabel.text = borrower
		dateBorrowedLabel.text = dateFormatter.string(from: dateBorrowed)
		dateToReturnLabel.text = dateFormatter.string(from: dateToReturn)
		reminderSwitch.isOn = reminder

		updateUIForPicture(animated: false)
	}

	override func viewWillDisappear(_ animated: Bool) {
		if isMovingFromParentViewController {
			if let someLentItem = selectedLentItem, let someBorrowerID = borrowerID {
				do {
					try LendingLibraryService.shared.update(someLentItem, withName: name, borrower: borrower, borrowerID: someBorrowerID, dateBorrowed: dateBorrowed, dateToReturn: dateToReturn, reminder: reminder, and: picture)
				}
				catch _ {
					let alertController = UIAlertController(title: "Save Failed", message: "Failed to update the lent item", preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
					present(alertController, animated: true, completion: nil)
				}
			}
		}

		super.viewWillDisappear(animated)
	}

	// MARK: View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		// Setup the accessory and accessory input views for the hidden text fields associated with the date labels
		datePicker = UIDatePicker(frame: CGRect.zero)
		datePicker.datePickerMode = .dateAndTime
		datePicker.addTarget(self, action: #selector(LentItemDetailViewController.datePickerDidChange(_:)), for: .valueChanged)
		let toolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 44.0))
		toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(LentItemDetailViewController.datePickerDidFinish(_:)))]
		dateBorrowedTextField.inputView = datePicker
		dateBorrowedTextField.inputAccessoryView = toolbar
		dateToReturnTextField.inputView = datePicker
		dateToReturnTextField.inputAccessoryView = toolbar

		dateFormatter.dateStyle = .long
		dateFormatter.timeStyle = .medium
	}

	// MARK: Initialization
	required init!(coder aDecoder: NSCoder) {
		let now = Date()
		dateBorrowed = now
		var dateComponents = DateComponents()
		dateComponents.weekOfYear = 2
		if let later = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: now, options: []) {
			dateToReturn = later
		}
		else {
			dateToReturn = now
		}

		super.init(coder: aDecoder)
	}

	// MARK: Properties
	var selectedCategory: Category!
	var selectedLentItem: LentItem? {
		didSet {
			if let someLentItem = selectedLentItem {
				name = someLentItem.name!
				borrower = someLentItem.borrower!
				borrowerID = someLentItem.borrowerID
				dateBorrowed = someLentItem.dateBorrowed! as Date
				dateToReturn = someLentItem.dateToReturn! as Date
				reminder = someLentItem.notify?.boolValue ?? false
				if let pictureData = someLentItem.picture?.data {
					picture = UIImage(data: pictureData as Data)
				}
				else {
					picture = nil
				}
			}
			else {
				name = LentItemDetailViewController.defaultName
				borrower = LentItemDetailViewController.defaultBorrower
				borrowerID = nil
				let now = Date()
				dateBorrowed = now
				var dateComponents = DateComponents()
				dateComponents.weekOfYear = 2
				if let later = (Calendar.current as NSCalendar).date(byAdding: dateComponents, to: now, options: []) {
					dateToReturn = later
				}
				else {
					dateToReturn = now
				}
				reminder = false
			}
		}
	}
	var delegate: LentItemDetailViewControllerDelegate!

	// MARK: Properties (Private)
	private var name = LentItemDetailViewController.defaultName
	private var borrower = LentItemDetailViewController.defaultBorrower
	private var borrowerID: String?
	private var dateBorrowed: Date
	private var dateToReturn: Date
	private var reminder = false
	private var picture: UIImage?

	private var datePicker: UIDatePicker!
	private var dateFormatter = DateFormatter()

	// MARK: Properties (IBOutlet)
	@IBOutlet private weak var nameTextField: UITextField!
	@IBOutlet private weak var borrowerLabel: UILabel!
	@IBOutlet private weak var dateBorrowedLabel: UILabel!
	@IBOutlet private weak var dateBorrowedTextField: UITextField!
	@IBOutlet private weak var dateToReturnLabel: UILabel!
	@IBOutlet private weak var dateToReturnTextField: UITextField!
	@IBOutlet private weak var reminderSwitch: UISwitch!
	@IBOutlet private weak var pictureImageView: UIImageView!
	@IBOutlet private weak var addPictureLabel: UILabel!
	@IBOutlet private weak var clearPictureButton: UIButton!

	// MARK: Properties (Private Static Constant)
	private static let defaultName = "New Item"
	private static let defaultBorrower = "Someone Trustworthy"

	// LentItemRow
	private enum LentItemRow {
		case name
		case borrower
		case dateBorrowed
		case dateToReturn
		case reminder
		case picture

		static let items: Array<LentItemRow> = [.name, .borrower, .dateBorrowed, .dateToReturn, .reminder, .picture]
	}
}

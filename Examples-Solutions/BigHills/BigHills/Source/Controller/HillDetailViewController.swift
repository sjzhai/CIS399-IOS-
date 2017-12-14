//
//  HillDetailViewController.swift
//  BigHills
//


import UIKit


class HillDetailViewController: UITableViewController, UITextFieldDelegate {
	// MARK: IBAction
	@IBAction private func done(_ sender: AnyObject) {
		performSegue(withIdentifier: "DoneUnwindSegue", sender: self)
	}

	// MARK: Public
	func updateHill(withLatitude latitude: Double, andLongitude longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
		self.name = "New Big Hill"
	}

	// MARK: UITextFieldDelegate
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		var newName = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
		if newName.isEmpty {
			if let someHill = selectedHill {
				newName = someHill.name ?? ""
			}
			else {
				newName = "Name"
			}
		}
		name = newName

		return true
	}

	func textFieldShouldClear(_ textField: UITextField) -> Bool {
		if let someHill = selectedHill {
			name = someHill.name
		}
		else {
			name = "Name"
		}

		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		nameTextField.resignFirstResponder()

		return false
	}

	// MARK: Private
	private func updateUI() {
		if let someLatitude = latitude, let someLongitude = longitude, let someName = name {
			nameTextField.text = someName;
			if let _ = selectedHill {
				nameTextField.placeholder = someName;
			}
			else {
				nameTextField.placeholder = "Name"
			}

			let numberFormatter = NumberFormatter()
			numberFormatter.formatterBehavior = .behavior10_4
			numberFormatter.minimumFractionDigits = 2
			numberFormatter.maximumFractionDigits = 5
			numberFormatter.minimumIntegerDigits = 1

			if let latitudeString = numberFormatter.string(from: someLatitude as NSNumber), let longitudeString = numberFormatter.string(from: someLongitude as NSNumber) {
				coordinateLabel.text = "\(latitudeString), \(longitudeString)"
			}
			else {
				coordinateLabel.text = ""
			}
		}
	}

	// MARK: View Management
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if let someHill = selectedHill {
			navigationItem.title = someHill.name
		}
		else {
			navigationItem.title = "New Hill"
			navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(HillDetailViewController.done(_:)))
		}

		updateUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		nameTextField.becomeFirstResponder()
	}

	override func viewWillDisappear(_ animated: Bool) {
		if let someLatitude = latitude, let someLongitude = longitude, let someName = name {
			if let someHill = selectedHill {
				do {
					try HillService.shared.updateHill(someHill, withLatitude: someLatitude, longitude: someLongitude, andName: someName)
					self.delegate?.hillDetailViewController(self, didChange: someHill)
				}
				catch let error {
					fatalError("Failed to update existing hill: \(error)")
				}
			}
			else {
				do {
					try HillService.shared.createHill(withLatitude: someLatitude, longitude: someLongitude, andName: someName)
				}
				catch let error {
					fatalError("Failed to create new hill: \(error)")
				}
			}
		}

		super.viewWillDisappear(animated)
	}

	// MARK: Properties
	var selectedHill: Hill? {
		didSet {
			if let someHill = selectedHill {
				latitude = someHill.latitude?.doubleValue ?? 0
				longitude = someHill.longitude?.doubleValue ?? 0
				name = someHill.name
			}
		}
	}

	weak var delegate: HillDetailViewControllerDelegate?

	// MARK: Properties (Private)
	private var latitude: Double?
	private var longitude: Double?
	private var name: String?

	// MARK: Properties (IBOutlet)
	@IBOutlet private var nameTextField: UITextField!
	@IBOutlet private var coordinateLabel: UILabel!
}

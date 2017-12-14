//
//  KeychainService.swift
//  SecurePassword
//


import Foundation
import Security


public class KeychainService {
	// MARK: Public
	public func add(passwordData data: Data, forAccount account: String) -> Bool {
		guard !account.isEmpty && data.count > 0 else {
			return false
		}

		var requestDictionary = self.requestDictionary(forAccount: account)
		requestDictionary[kSecValueData as String] = data as AnyObject?

		guard SecItemAdd(requestDictionary as CFDictionary, nil) == OSStatus(errSecSuccess) else {
			return false
		}

		return true
	}

	public func update(passwordData data: Data, forAccount account: String) -> Bool {
		guard !account.isEmpty && data.count > 0 else {
			return false
		}

		let requestDictionary = self.requestDictionary(forAccount: account)
		let attributesDictionary = [kSecValueData as String : data] as CFDictionary

		guard SecItemUpdate(requestDictionary as CFDictionary, attributesDictionary) == OSStatus(errSecSuccess) else {
			return add(passwordData: data, forAccount: account)
		}

		return true
	}

	public func deletePasswordData(forAccount account: String) -> Bool {
		guard !account.isEmpty else {
			return false
		}

		let requestDictionary = self.requestDictionary(forAccount: account)

		guard SecItemDelete(requestDictionary as CFDictionary) == OSStatus(errSecSuccess) else {
			return false
		}

		return true
	}

	public func passwordData(forAccount account: String) -> Data? {
		guard !account.isEmpty else {
			return nil
		}

		var requestDictionary = self.requestDictionary(forAccount: account)
		requestDictionary[kSecMatchLimit as String] = kSecMatchLimitOne
		requestDictionary[kSecReturnData as String] = kCFBooleanTrue

		var result: AnyObject?
		let status = SecItemCopyMatching(requestDictionary as CFDictionary, &result);
		guard let data = result as? Data, status == OSStatus(errSecSuccess) else {
			return nil
		}

		return data
	}

	// MARK: Private
	private func requestDictionary(forAccount account: String) -> Dictionary<String, AnyObject> {
		var requestDictionary = Dictionary<String, AnyObject>()
		requestDictionary[kSecClass as String] = kSecClassGenericPassword
		requestDictionary[kSecAttrAccount as String] = account as AnyObject?
		requestDictionary[kSecAttrService as String] = account as AnyObject?

		return requestDictionary
	}

	// MARK: Initialization
	private init() {
		// Empty init method implemented for access control (i.e., to be private)
	}

	// MARK: Properties
	static var shared = KeychainService()
}

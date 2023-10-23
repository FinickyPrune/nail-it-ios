//
//  Localizable.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 17.10.2023.
//

import UIKit

protocol Localizable {
    var localized: String { get }
}
extension String: Localizable {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

protocol XIBLocalizable {
    var localizationKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set (key) {
            text = key?.localized
        }
    }
}
extension UIButton: XIBLocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set (key) {
            setTitle(key?.localized, for: .normal)
        }
    }
}

extension UITextField: XIBLocalizable {
    @IBInspectable var localizationKey: String? {
        get { return nil }
        set (key) {
            placeholder = key?.localized
        }
    }
}

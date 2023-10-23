//
//  UISearchbar+Color.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.12.2022.
//

import UIKit

extension UISearchBar {

    func setPlaceholderColor(_ color: UIColor) {
        let textField = self.value(forKey: "searchField") as? UITextField
        let placeholder = textField!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.textColor = color
    }

    func setPlaceholderFont(_ font: UIFont) {
        let textField = self.value(forKey: "searchField") as? UITextField
        let placeholder = textField!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.font = font
    }

    public func setTextColor(color: UIColor) {
        let textField = self.value(forKey: "searchField") as? UITextField
        textField?.textColor = color
    }
}

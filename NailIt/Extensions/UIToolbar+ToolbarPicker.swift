//
//  UIToolbar+ToolbarPicker.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 07.09.2022.
//

import UIKit

extension UIToolbar {
    func ToolbarPiker(action: Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: action)
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}

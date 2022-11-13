//
//  UIViewController+Nib.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import UIKit

extension UIViewController {
    
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}

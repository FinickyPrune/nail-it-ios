//
//  UIFont.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.10.2023.
//

import UIKit

extension UIFont {

    static func montserratBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-Bold", size: size) else {
            fatalError("Montserrat-Bold is missed")
        }
        return font
    }

    static func montserratSemiBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-SemiBold", size: size) else {
            fatalError("Montserrat-Bold is missed")
        }
        return font
    }

    static func montserratRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-Regular", size: size) else {
            fatalError("Montserrat-Regular is missed")
        }
        return font
    }

}

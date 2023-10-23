//
//  UILabel+DynamicHeight.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 23.12.2022.
//

import UIKit

func heightFor(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = font
    label.text = text

    label.sizeToFit()
    return label.frame.height
}

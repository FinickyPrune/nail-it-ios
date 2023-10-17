//
//  String+Date.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 25.12.2022.
//

import Foundation

extension String {

    func dateFromFormattedString(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

}

//
//  User.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 27.11.2022.
//

import Foundation

enum TokenType {
    case nailIt
}

final class User: NSObject, NSCoding {

    var nailItToken: String?
    var id: Int?
    var name: String?
    var phoneNumber: String?

    override init() {
        super.init()
    }

    func changeToken(newToken: String?, tokenType: TokenType) {
        switch tokenType {
        case .nailIt:
            nailItToken = newToken
        }
    }

    func encode(with coder: NSCoder) {
        coder.encode(nailItToken, forKey: "nailit_token")
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(phoneNumber, forKey: "phone_number")
    }

    required init?(coder: NSCoder) {
        nailItToken = coder.decodeObject(forKey: "nailit_token") as! String?
        id = coder.decodeObject(forKey: "id") as! Int?
        name = coder.decodeObject(forKey: "name") as! String?
        phoneNumber = coder.decodeObject(forKey: "phone_number") as! String?
    }

}

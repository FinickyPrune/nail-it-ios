//
//  DataRequest+DataHandler.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 10.09.2022.
//

import Foundation
import Alamofire

protocol DataHandler: AnyObject {

}

protocol DataProvider {
    func cancelDataHandler(handler: DataHandler)
}

extension DataRequest: DataHandler {
    
}

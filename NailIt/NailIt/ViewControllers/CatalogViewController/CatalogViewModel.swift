//
//  MainViewModel.swift
//  Autotuned
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import Foundation
import UIKit
import Alamofire
import HealthKit

protocol CatalogViewModelDisplayDelegate: AnyObject {

}

protocol CatalogViewModelActionDelegate: AnyObject {
    func catalogViewModelAttemptsToLogin(_ viewModel: CatalogViewModel)
    func catalogViewModelAttemptsToDisplayProduct(_ viewModel: CatalogViewModel, product: NIProduct)
}

final class CatalogViewModel {
    
    weak var displayDelegate: CatalogViewModelDisplayDelegate?
    weak var actionDelegate: CatalogViewModelActionDelegate? {
        didSet {
            //      actionDelegate?.catalogViewModelAttemptsToLogin(self) // TODO: Remove
        }
    }

    let categories: [Category] = [Category(name: "Маникюр", products: [NIProduct(name: "Маникюр 1", price: 500, productDescription: "วรขอคำปรึกษาช่วยเหลือจากผู้ที่ไว้วางใจ ไม่จมอยู่กับปัญหา มองหาหนทางคลี่คลาย หากอาการที่ท่านเป็นมีผลกระทบต่อการทำงานหรือการเข้าสังคม หรือมีอาการระดับนี้มานาน 1-2 สัปดาห์แล้วยังไม่ดีขึ้น ท่านควรเข้าพบแพทย์เพื่อรับการช่วยเหลือรักษาต่อไป"),
                                                                          NIProduct(name: "Маникюр 2", price: 250, productDescription: "Description Description"),
                                                                          NIProduct(name: "Маникюр 3", price: 500, productDescription: "Description Description"),
                                                                          NIProduct(name: "Маникюр 4", price: 250.5, productDescription: "Description Description")]),
                                  Category(name: "Стрижка", products: [NIProduct(name: "Стрижка 5", price: 500, productDescription: "Description Description"),
                                                                          NIProduct(name: "Стрижка 6", price: 250, productDescription: "Description Description"),
                                                                          NIProduct(name: "Стрижка 7", price: 500, productDescription: "Description Description")]),
                                  Category(name: "Макияж", products: [NIProduct(name: "Макияж 5", price: 500, productDescription: "Description Description"),
                                                                       NIProduct(name: "Макияж 6", price: 250, productDescription: "Description Description"),
                                                                      NIProduct(name: "Макияж 7", price: 500, productDescription: "Description Description")]),
                                  Category(name: "Педикюр", products: [NIProduct(name: "Педикюр 5", price: 500, productDescription: "Description Description"),
                                                                       NIProduct(name: "Педикюр 6", price: 250, productDescription: "Description Description"),
                                                                       NIProduct(name: "Педикюр 7", price: 500, productDescription: "Description Description")])]

    func didLoginSuccessfully() {

    }

    var count: Int { categories.count }

    func category(for index: Int) -> Category? { categories[safe: index] }

    func didSelect(_ product: NIProduct) {
        actionDelegate?.catalogViewModelAttemptsToDisplayProduct(self, product: product)
    }

}

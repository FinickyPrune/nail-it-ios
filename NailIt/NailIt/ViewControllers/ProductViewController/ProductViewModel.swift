//
//  ProductViewModel.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 12.12.2022.
//

import Foundation

protocol ProductViewModelDisplayDelegate: AnyObject {
}

protocol ProductViewModelActionDelegate: AnyObject {
}

final class ProductViewModel {

    weak var actionDelegate: ProductViewModelActionDelegate?
    weak var displayDelegate: ProductViewModelDisplayDelegate?

    private let product: NIProduct

    init(product: NIProduct) {
        self.product = product
    }

    var productName: String { product.name }
    var productPrice: Float { product.price }
    var productDescription: String { product.productDescription }
}

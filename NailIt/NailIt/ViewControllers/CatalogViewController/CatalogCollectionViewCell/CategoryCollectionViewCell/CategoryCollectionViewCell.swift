//
//  CategoryCollectionViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 12.12.2022.
//

import UIKit

struct NIProduct {
    let name: String
    let price: Float
    let productDescription: String
}

final class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!

    private(set) var product: NIProduct?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with product: NIProduct) {
        self.product = product
        productNameLabel.text = product.name
        productPriceLabel.text = "THB \(product.price)0"
    }

}

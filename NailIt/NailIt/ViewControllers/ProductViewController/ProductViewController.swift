//
//  ProductViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 12.12.2022.
//

import UIKit

final class ProductViewController: UIViewController {

    var viewModel: ProductViewModel?

    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productNameLabel.text = viewModel?.productName ?? ""
        productPriceLabel.text = "THB \(viewModel?.productPrice ?? 0.0)0"
        productDescriptionLabel.text = viewModel?.productDescription ?? ""
    }

}

extension ProductViewController: ProductViewModelDisplayDelegate {

}

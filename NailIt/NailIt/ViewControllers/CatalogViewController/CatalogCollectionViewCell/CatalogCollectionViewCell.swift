//
//  CatalogCollectionViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 12.12.2022.
//

import UIKit

struct Category {
    let name: String
    let products: [NIProduct]
}

protocol CatalogCollectionViewDelegate: AnyObject {
    func collectionViewDidSelect(_ collectionView: UICollectionView, cell: CategoryCollectionViewCell)
}

final class CatalogCollectionViewCell: UICollectionViewCell {

    weak var delegate: CatalogCollectionViewDelegate?

    @IBOutlet private weak var categoryNameLabel: UILabel!
    @IBOutlet private weak var categoryCollectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!

    private let identifier = "CategoryCollectionViewCell"
    private var category: Category?

    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        categoryCollectionView.collectionViewLayout = layout
    }

    func configure(with category: Category) {
        self.category = category
        categoryNameLabel.text = category.name
        pageControl.numberOfPages = category.products.count/2 + (category.products.count % 2 == 0 ? 0 : 1)
        let inset = categoryCollectionView.contentInset
        categoryCollectionView.contentInset = UIEdgeInsets(top: inset.top,
                                                           left: inset.left,
                                                           bottom: inset.bottom,
                                                           right: (category.products.count % 2 == 0 ? inset.right : categoryCollectionView.frame.size.width/2))
    }

}

extension CatalogCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        category?.products.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell,
           (0..<(category?.products.count ?? 0)).contains(indexPath.row),
           let product = category?.products[indexPath.row] {
            cell.configure(with: product)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell else { return }
        delegate?.collectionViewDidSelect(collectionView, cell: cell)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

}

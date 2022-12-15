//
//  SalonTableViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 15.12.2022.
//

import UIKit

class SalonTableViewCell: UITableViewCell {

    static let identifier = "SalonTableViewCell"

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private var starsImageViews: [UIImageView]!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    private let starImageStroke = UIImage(systemName: "star")
    private let starImageFill = UIImage(systemName: "star.fill")

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 15
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 0, dy: 7.5)
    }

    func configure(with salon: Salon) {
        nameLabel.text = salon.name
        addressLabel.text = salon.address
        let rate = Int(round(salon.rate))
        starsImageViews.forEach { $0.image = ( $0.tag <= rate ? starImageFill : starImageStroke ) }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

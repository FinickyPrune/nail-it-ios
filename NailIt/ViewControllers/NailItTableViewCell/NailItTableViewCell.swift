//
//  SalonTableViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 15.12.2022.
//

import UIKit

enum CellType {
    case salon
    case service
}

class NailItTableViewCell: UITableViewCell {

    static let identifier = "NailItTableViewCell"

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var secondSubtitleLabel: UILabel!
    @IBOutlet private var starsImageViews: [UIImageView]!
    @IBOutlet private weak var thumbnailImageView: UIImageView!

    private let starImageStroke = UIImage(systemName: "star")
    private let starImageFill = UIImage(systemName: "star.fill")

    private var cellType: CellType = .salon

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 15
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor

        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor

        thumbnailImageView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if cellType == .service {
            contentView.layer.borderColor = selected ? NailItAppearance.nailItOrangeColor.cgColor : UIColor.clear.cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 20, dy: 7.5)
    }

    func configure(with salon: Salon) {
        cellType = .salon
        titleLabel.text = salon.name
        subtitleLabel.text = salon.address
        let rate = Int(round(salon.rate))
        starsImageViews.forEach { $0.isHidden = false }
        starsImageViews.forEach { $0.image = ( $0.tag <= rate ? starImageFill : starImageStroke ) }
        secondSubtitleLabel.isHidden = true
    }

    func configure(with service: Service) {
        cellType = .service
        titleLabel.text = service.title
        subtitleLabel.text = "\(service.price)р"
        starsImageViews.forEach { $0.isHidden = true  }
        secondSubtitleLabel.isHidden = false
        secondSubtitleLabel.text = service.estimate
    }
}

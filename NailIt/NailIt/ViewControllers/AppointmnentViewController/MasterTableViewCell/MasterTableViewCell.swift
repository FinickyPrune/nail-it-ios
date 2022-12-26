//
//  MasterTableViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 25.12.2022.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    static let identifier = "MasterTableViewCell"

    @IBOutlet private weak var masterLabel: UILabel!
    @IBOutlet private var starsImageViews: [UIImageView]!

    private let starImageStroke = UIImage(systemName: "star")
    private let starImageFill = UIImage(systemName: "star.fill")

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 0, dy: 2.5)
        contentView.layer.cornerRadius = 15
    }

    func configure(with master: Master) {
        masterLabel.text = master.name
        let rate = Int(round(master.rate))
        starsImageViews.forEach { $0.image = ( $0.tag <= rate ? starImageFill : starImageStroke ) }
    }
    
}

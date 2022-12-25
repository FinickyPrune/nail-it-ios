//
//  MasterTableViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 25.12.2022.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

    static let identifier = "MasterTableViewCell"

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

    }
    
}

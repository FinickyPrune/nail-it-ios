//
//  AccountTableViewCell.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.12.2022.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    static let identifier = "AppointmentTableViewCell"

    @IBOutlet private weak var serviceNameLabel: UILabel!
    @IBOutlet private weak var salonNameLabel: UILabel!
    @IBOutlet private weak var masterNameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 15
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.insetBy(dx: 5, dy: 5)
    }

    func configure(with appointment: Appointment) {
        serviceNameLabel.text = appointment.serviceTitle
        salonNameLabel.text = appointment.salonTitle
        masterNameLabel.text = appointment.masterName
        dateLabel.text = appointment.date
        timeLabel.text = appointment.time
        priceLabel.text = "\(appointment.price)р"
    }
    
}

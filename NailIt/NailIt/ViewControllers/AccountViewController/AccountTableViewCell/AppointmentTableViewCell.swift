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
        serviceNameLabel.text = appointment.title
        salonNameLabel.text = " \(appointment.address ?? ""), \(appointment.salon ?? "")"
        masterNameLabel.text = appointment.master

        if let date = appointment.date.dateFromFormattedString(format: "yyyy-MM-dd HH:mm:ss.SSSSZZZ") {
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            dateLabel.text = "\(components.day ?? 0).\(components.month ?? 0).\(components.year ?? 0)"
            timeLabel.text = "\(components.hour ?? 0):\(components.minute ?? 0)"

        }
        priceLabel.text = "\(appointment.price ?? 0)р"
    }
    
}

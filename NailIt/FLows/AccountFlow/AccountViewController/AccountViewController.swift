//
//  AccountViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.12.2022.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userphoneNumberLabel: UILabel!
    @IBOutlet private weak var userInfoContainerView: UIView!
    @IBOutlet private weak var tableView: UITableView!

    var viewModel: AccountViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabel.text = viewModel?.username ?? ""
        userphoneNumberLabel.text = viewModel?.phoneNumber ?? ""

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AppointmentTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: AppointmentTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layer = userInfoContainerView.layer
        layer.masksToBounds = false
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 15

        let shadowView = UIView(frame: tableView.bounds)
        let shadowViewLayer = view.layer
        shadowViewLayer.masksToBounds = false
        shadowViewLayer.shadowOpacity = 0.07
        shadowViewLayer.shadowRadius = 20
        shadowViewLayer.shadowOffset = CGSize(width: 0, height: 5)
        shadowViewLayer.shadowColor = UIColor.black.cgColor
        view.insertSubview(shadowView, belowSubview: tableView)

        let tableLayer = tableView.layer
        tableLayer.cornerRadius = 15
    }

    private func fetchData() {
        viewModel?.loadData { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.sectionsCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.count(for: section) ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = viewModel?.section(for: section) else { return nil }
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: tableView.bounds.width, height: 30)))
        view.layer.cornerRadius = 15
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        label.textColor = .black
        label.textAlignment = .left
        label.frame = view.bounds.insetBy(dx: 13, dy: 2)
        switch section {
        case .coming:
            label.text = "AccountViewController.enrolls".localized
            label.font = UIFont.montserratBold(size: 20)
        case .history:
            label.text = "AccountViewController.previousEnrolls".localized
            label.font = UIFont.montserratSemiBold(size: 16)
        }
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentTableViewCell.identifier) as? AppointmentTableViewCell,
           let appointment = viewModel?.appointments(for: indexPath.section)?[indexPath.row] {
            cell.configure(with: appointment,
                           isAlertColor: viewModel?.conflictingAppointments.first(where: { $0.appointmentId == appointment.appointmentId }) != nil)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(with: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        93
    }
}

extension AccountViewController: AccountViewModelDisplayDelegate {

    func dispayAlert(_ viewModel: AccountViewModel, message: String) {
        DispatchQueue.main.async {
            self.presentFailAlert(with: message)
        }
    }

    private func presentFailAlert(with message: String) {
        let alertController = UIAlertController(title: "NailIt.warning".localized, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

//
//  AppointmentViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 21.12.2022.
//

import TinyConstraints
import ProgressHUD

@available(iOS 16.0, *)
final class AppointmentViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var serviceNameLabel: UILabel!
    @IBOutlet private weak var serviceDurationLabel: UILabel!
    @IBOutlet private weak var serivcePriceLabel: UILabel!
    @IBOutlet private weak var serivceDescriptionContainerView: UIView!

    @IBOutlet private weak var calendarParentView: UIView!
    @IBOutlet private weak var calendarContainerView: UIView!

    @IBOutlet private weak var mastersTableView: UITableView!
    @IBOutlet private weak var mastersTableViewContainerView: UIView!

    @IBOutlet private weak var timeTextField: UITextField!
    @IBOutlet private weak var timeContainerView: UIView!

    @IBOutlet private weak var assignButton: UIButton!

    private var calendarView: UICalendarView?

    private let timePickerView = UIPickerView()
    private var keyboardToolbar: UIToolbar! {
        didSet {
            timeTextField.inputAccessoryView = keyboardToolbar
        }
    }

    private var isEdited = false

    private var selectedMasterIndexPath: IndexPath?

    var viewModel: AppointmentViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        serviceNameLabel.text = viewModel?.serviceName ?? ""
        serviceNameLabel.frame = CGRect(origin: serviceNameLabel.frame.origin,
                                        size: CGSize(width: serviceNameLabel.frame.width,
                                                     height: heightFor(text: viewModel?.serviceName ?? "",
                                                                       font: UIFont(name: "Montserrat-Bold", size: 20)!,
                                                                       width: serviceNameLabel.frame.width)))
        serivcePriceLabel.text = "\(viewModel?.servicePrice ?? "0.0")\("NailIt.currency".localized)"
        serviceDurationLabel.text = viewModel?.serviceDuration
        setupCalendar()

        mastersTableView.delegate = self
        mastersTableView.dataSource = self
        mastersTableView.register(UINib(nibName: MasterTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: MasterTableViewCell.identifier)
        mastersTableView.showsVerticalScrollIndicator = false
        mastersTableView.separatorStyle = .none

        timePickerView.delegate = self
        timeTextField.inputView = timePickerView

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 60
        scrollView.contentInset = contentInset
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAccount))
        navigationItem.rightBarButtonItem?.tintColor = NIAppearance.nailItBrownColor
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.title = viewModel?.salonName ?? ""
    }

    @objc private func didTapAccount() {
        viewModel?.didTapAccount()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        keyboardToolbar = UIToolbar().ToolbarPiker(action: #selector(dismissPicker))
        setupNavigationBar()

        var layer = serivceDescriptionContainerView.layer
        layer.masksToBounds = false
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 15

        layer = calendarContainerView.layer
        layer.masksToBounds = false
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 15

        layer = mastersTableViewContainerView.layer
        layer.masksToBounds = false
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 15

        layer = timeContainerView.layer
        layer.masksToBounds = false
        layer.shadowOpacity = 0.07
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowColor = UIColor.black.cgColor
        layer.cornerRadius = 15

        assignButton.layer.cornerRadius = 15
    }

    private func setupCalendar() {
        calendarView = UICalendarView()
        calendarView?.calendar = Calendar(identifier: .gregorian)
        calendarView?.translatesAutoresizingMaskIntoConstraints = false
        calendarParentView.addSubview(calendarView!)
        calendarView?.edgesToSuperview()

        calendarView?.tintColor = NIAppearance.nailItOrangeColor
        calendarView?.availableDateRange = DateInterval(start: .now, end: .distantFuture)

        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView?.selectionBehavior = selection
    }

    @IBAction func textFieldDidEdited(_ sender: Any) {
        isEdited = true
    }

    @IBAction func textFieldCompleteEditing(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func didTapEnroll() {
        viewModel?.didTapEnroll()
    }

    private func presentFailAlert(with message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

@available(iOS 16.0, *)
extension AppointmentViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents = dateComponents else { return }
        viewModel?.didSelectDate(with: dateComponents)
    }
}

@available(iOS 16.0, *)
extension AppointmentViewController: AppointmentViewModelDisplayDelegate {

    func showLoading(_ viewModel: AppointmentViewModel) {
        DispatchQueue.main.async {
            ProgressHUD.animate()
        }

    }

    func stopLoading(_ viewModel: AppointmentViewModel) {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }

    func presentMessage(_ viewModel: AppointmentViewModel, message: String) {
//        DispatchQueue.main.async {
//            self.presentFailAlert(with: message)
//        }
    }

    func reloadTableView(_ viewModel: AppointmentViewModel) {
        DispatchQueue.main.async {
            self.mastersTableView.reloadData()
        }
    }

}

@available(iOS 16.0, *)
extension AppointmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel?.timeCount ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.time(for: row)
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isEdited = true
        timeTextField.text = viewModel?.time(for: row) ?? ""
        viewModel?.didSelectAppointment(for: row)
    }

    @objc func dismissPicker() {
        view.endEditing(true)
    }
}

@available(iOS 16.0, *)
extension AppointmentViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.mastersCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MasterTableViewCell.identifier) as? MasterTableViewCell,
           let master = viewModel?.master(for: indexPath.row) {
            cell.configure(with: master)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectMaster(with: indexPath.row)
        if let indexPath = selectedMasterIndexPath {
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor(red: 0.949, green: 0.859, blue: 0.835, alpha: 0.5)
        }
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor(red: 0.949, green: 0.859, blue: 0.835, alpha: 1)
        selectedMasterIndexPath = indexPath
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        47
    }

}

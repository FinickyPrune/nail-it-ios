//
//  SalonViewController.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 18.12.2022.
//

import UIKit

class SalonViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bannerView: UIView!

    private var hiddenSections = Set<Int>()

    private var searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    var viewModel: SalonViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: NailItTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: NailItTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        fetchData()
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var contentInset = tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - 20
        tableView.contentInset = contentInset
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }

    private func setupNavigationBar() {
        searchController.obscuresBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        searchBar.setPlaceholderColor(NailItAppearance.nailItPlaceholderTextColor)
        searchBar.setTextColor(color: NailItAppearance.nailItPlaceholderTextColor)
        searchBar.searchTextField.leftView?.tintColor = NailItAppearance.nailItPlaceholderTextColor
        searchBar.placeholder = "Найти услугу"
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = NailItAppearance.nailItOrangeColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapAccount))
        navigationItem.rightBarButtonItem?.tintColor = NailItAppearance.nailItBrownColor
                navigationController?.navigationBar.backItem?.title = ""
        navigationItem.title = viewModel?.salonName ?? ""
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
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
        setupNavigationBar()
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

extension SalonViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.sectionsCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel,
              let serviceType = viewModel.serviceType(for: section) else { return 0 }
        return hiddenSections.contains(section) ? 0 : viewModel.count(for: serviceType)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let serviceType = viewModel?.serviceType(for: section) else { return nil }
        let view = UIView(frame: CGRect(origin: .zero,
                                        size: CGSize(width: tableView.bounds.width, height: 30)))
        view.backgroundColor = .clear
        let label = UILabel()
        view.addSubview(label)
        label.textColor = .black
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.textAlignment = .center
        label.text = serviceType.title
        let labelWidth = label.intrinsicContentSize.width
        label.frame = CGRect(origin: CGPoint(x: (view.bounds.width - labelWidth)/2, y: 0),
                             size: CGSize(width: labelWidth, height: view.bounds.height))

        let arrowImageView = UIImageView(frame: CGRect(origin: CGPoint(x: label.frame.maxX + 5, y: 10),
                                                size: CGSize(width: 10, height: 10)))
        arrowImageView.image = UIImage(named: "arrow")
        arrowImageView.contentMode = .center
        view.addSubview(arrowImageView)
        
        view.tag = section
        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(hideSection))
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }

    @objc private func hideSection(_ sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag,
              let viewModel = viewModel,
              let serviceType = viewModel.serviceType(for: section) else { return }

        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()

            for row in 0..<viewModel.count(for: serviceType) {
                indexPaths.append(IndexPath(row: row,
                                            section: section))
            }

            return indexPaths
        }

        if hiddenSections.contains(section) {
            hiddenSections.remove(section)
            tableView.insertRows(at: indexPathsForSection(),
                                      with: .fade)
        } else {
            hiddenSections.insert(section)
            tableView.deleteRows(at: indexPathsForSection(),
                                      with: .fade)
        }
        guard let arrow = sender.view?.subviews.last else { return }
        UIView.animate(withDuration: 0.2) {
            arrow.transform = arrow.transform.concatenating(CGAffineTransform(rotationAngle: .pi))
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NailItTableViewCell.identifier) as? NailItTableViewCell,
           let serviceType = viewModel?.serviceType(for: indexPath.section),
           let service = viewModel?.services(for: serviceType)[safe: indexPath.row] {
            cell.configure(with: service)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectItem(with: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}

extension SalonViewController: UISearchBarDelegate {}

extension SalonViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(updateCellsWithSearchResult), object: nil)
        self.perform(#selector(updateCellsWithSearchResult), with: nil, afterDelay: 0.5)
    }

    @objc private func updateCellsWithSearchResult() {
        viewModel?.filterContentForSearchText(searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension SalonViewController: SalonViewModelDisplayDelegate {

    func showBanner(_ viewModel: SalonViewModel, _ flag: Bool) {
        bannerView.isHidden = !flag
    }

    func reloadTable(_ viewModel: SalonViewModel) {
        tableView.reloadData()
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
}

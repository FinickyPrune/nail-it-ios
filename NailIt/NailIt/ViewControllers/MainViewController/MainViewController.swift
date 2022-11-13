//
//  MainViewController.swift
//  Autotuned
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import UIKit
import WebKit

class MainViewController: UIViewController {

    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}

extension MainViewController: MainViewModelDisplayDelegate {

}

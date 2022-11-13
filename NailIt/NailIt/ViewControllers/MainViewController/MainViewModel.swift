//
//  MainViewModel.swift
//  Autotuned
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import Foundation
import UIKit
import Alamofire
import HealthKit

protocol MainViewModelDisplayDelegate: AnyObject {

}

protocol MainViewModelActionDelegate: AnyObject {
    func mainViewModelAttemptsToLogin(_ viewModel: MainViewModel)
}

class MainViewModel {
    
    weak var displayDelegate: MainViewModelDisplayDelegate?
    weak var actionDelegate: MainViewModelActionDelegate?

  func didLoginSuccessfully() {
    
  }

}

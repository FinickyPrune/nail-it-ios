//
//  Coordinator.swift
//  NailIt
//
//  Created by Anastasia Kravchenko on 06.09.2022.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

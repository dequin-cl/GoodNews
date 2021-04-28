//
//  Coordinator.swift
//  GoodNewsRxMVVM
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import UIKit

protocol Coordinator {
    var childCoordinators:[Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

//
//  MainCoordinator.swift
//  GoodNewsRxMVVM
//
//  Created by Iván Galaz Jeria on 27-04-21.
//

import UIKit

struct MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ArticleListViewModel()
        let viewController: NewsListViewController = UIStoryboard().viewController()
        viewController.bind(to: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

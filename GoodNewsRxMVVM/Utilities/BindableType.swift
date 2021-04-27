import UIKit

protocol BindableType {
    associatedtype ViewModelType

    var viewModel: ViewModelType? { get }
    func setViewModel(viewModel: ViewModelType)
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    func bind(to viewModel: Self.ViewModelType) {
        setViewModel(viewModel: viewModel)
        loadViewIfNeeded()
        bindViewModel()
    }
}

extension BindableType where Self: UIView {
    func bind(to viewModel: Self.ViewModelType) {
        setViewModel(viewModel: viewModel)
        bindViewModel()
    }
}

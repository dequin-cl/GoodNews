import UIKit
import RxSwift

protocol AlertPresentableView {
    associatedtype ModelType: AlertPresentableViewModel
    
    var alertPresentableViewModel: ModelType { get }
}

extension AlertPresentableView where Self: DisposableViewController {
    func bindToAlerts() {
        alertPresentableViewModel.alertModel
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                guard let model = model else {
                    return
                }
                
                let alert = AlertBuilder.buildAlertController(for: model)
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
}

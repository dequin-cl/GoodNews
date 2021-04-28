import RxSwift

class AlertViewModel: AlertPresentableViewModel {
    var alertModel: PublishSubject<AlertModel> = PublishSubject<AlertModel>()
    
    func showOkAlert(message: String) {
        let alert = AlertModel(
            actionModels: [
                AlertModel.ActionModel.init(
                    title: "OK",
                    style: .default,
                    handler: nil)],
            title: "Alert",
            message: message,
            prefferedStyle: .alert
        )
        
        DispatchQueue.main.async {
            self.alertModel.onNext(alert)
        }
    }
    
}

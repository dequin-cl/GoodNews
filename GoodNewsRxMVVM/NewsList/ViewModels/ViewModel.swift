import RxSwift

class ViewModel: AlertPresentableViewModel {
    var alertModel: PublishSubject<AlertModel?> = PublishSubject<AlertModel?>()
    
    func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.alertModel.onNext(
                AlertModel(
                    actionModels: [
                        AlertModel.ActionModel.init(
                            title: "OK",
                            style: .default,
                            handler: nil)],
                    title: "Alert example",
                    message: "That's our easy alert.",
                    prefferedStyle: .alert
                )
            )
        }
    }
    
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

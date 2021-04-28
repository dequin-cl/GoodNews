import RxSwift

protocol AlertPresentableViewModel {
    var alertModel: PublishSubject<AlertModel?> { get }
}

import UIKit

struct AlertModel {
    struct ActionModel {
        let title: String?
        let style: UIAlertAction.Style
        let handler: ((UIAlertAction) -> ())?
    }
    
    let actionModels: [ActionModel]
    let title: String?
    let message: String?
    let prefferedStyle: UIAlertController.Style
}

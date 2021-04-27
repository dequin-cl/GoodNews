import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(withCellType type: T.Type = T.self, forIndexPath indexPath: IndexPath) -> T where T: ClassIdentifiable {
        guard let cell = dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as? T else { fatalError(dequeueError(withIdentifier: type.reuseId, type: self)) }
        
        return cell
    }
}

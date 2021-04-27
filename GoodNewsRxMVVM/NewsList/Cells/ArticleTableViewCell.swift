import UIKit
import RxSwift
import RxCocoa


class ArticleTableViewCell: DisposableTableViewCell, ClassIdentifiable {
    static let identifier = "ArticleTableViewCell"
    
    let labelArticleTitle = UILabel()
    let labelArticleDescription = UILabel()
    let container = UIStackView()
    
    var viewModel: ArticleListCellViewModel?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        labelArticleTitle.text = nil
        labelArticleDescription.text = nil
    }
    
    private func createLayout() {
        labelArticleTitle.numberOfLines = 0
        labelArticleDescription.numberOfLines = 0
        
        labelArticleDescription.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .vertical)
        labelArticleDescription.font = UIFont.systemFont(ofSize: 14)
        labelArticleDescription.textColor = UIColor.darkGray
        
        container.axis = .vertical
        container.addArrangedSubview(labelArticleTitle)
        container.addArrangedSubview(labelArticleDescription)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(container)
        
        container.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
        container.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    }
}

extension ArticleTableViewCell: BindableType {
    func setViewModel(viewModel: ArticleListCellViewModel) {
        self.viewModel = viewModel
    }
    
    func bindViewModel() {
        viewModel?.title
            .drive(labelArticleTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel?.description
            .drive(labelArticleDescription.rx.text)
            .disposed(by: disposeBag)
    }
}

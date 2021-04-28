import UIKit
import RxSwift
import RxDataSources

final class NewsListViewController: DisposableViewController, AlertPresentableView {    
    var alertPresentableViewModel = ViewModel()
    
    typealias ArticleListSectionModel = AnimatableSectionModel<String, Article>
    
    private var dataSource: RxTableViewSectionedAnimatedDataSource<ArticleListSectionModel>!
    private(set) var viewModel: ArticleListViewModel?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        bindToAlerts()
        
        self.bind(to: ArticleListViewModel(withArticle: []))

        viewModel?.onFetchArticlesError = { [weak self] message in
            DispatchQueue.main.async {
                self?.alertPresentableViewModel.showOkAlert(message: message)
            }
        }
        
        viewModel?.fetchNextArticles.accept(())
        
        tableView.rx.contentOffset
            .flatMap { offset in
                NewsListViewController.isNearTheBottomEdge(offset, self.tableView)
                    ? Observable.just(())
                    : Observable.empty()
            }.subscribe(onNext: { [weak self] in
                self?.viewModel?.fetchNextArticles.accept(())
            })
            .disposed(by: disposeBag)
        
    }
    
    static let startLoadingOffset: CGFloat = 20.0
    
    static func isNearTheBottomEdge(_ contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y + tableView.frame.size.height + startLoadingOffset > tableView.contentSize.height
    }
    
    private func setupTableView() {
        registerCell()
        setupDataSource()
    }
    
    private func registerCell() {
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.identifier)
    }
    
    private func setupDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<ArticleListSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .right,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .left),
            configureCell: configureCell,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath
        )
    }
}

extension NewsListViewController: BindableType {
    func setViewModel(viewModel: ArticleListViewModel) {
        self.viewModel = viewModel
    }
    
    func bindViewModel() {
        bindDataSource()
        //        bindSelected()
    }
    
    private func bindDataSource() {
        viewModel?.dataSource.asDriver()
            .map { [ArticleListSectionModel(model: "", items: $0)] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    //    private func bindSelected() {
    //        tableView.rx.modelSelected(Article.self)
    //            .asDriver()
    //            .drive(onNext: { [unowned self] recipe in
    //                var vc = RecipeViewController.initFromNib()
    //                vc.bind(to: RecipeViewModel(withRecipe: recipe))
    //
    //                self.navigationController?.pushViewController(vc, animated: true)
    //            })
    //            .disposed(by: disposeBag)
    //    }
    
}

// MARK: Data Source Configuration

extension NewsListViewController {
    private var configureCell: RxTableViewSectionedAnimatedDataSource<ArticleListSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, article in
            let cell: ArticleTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.bind(to: ArticleListCellViewModel(withArticle: article))
            return cell
        }
    }
    
    private var canEditRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<ArticleListSectionModel>.CanEditRowAtIndexPath {
        return { [unowned self] _, _ in
            if self.tableView.isEditing {
                return true
            } else {
                return false
            }
        }
    }
    
    private var canMoveRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<ArticleListSectionModel>.CanMoveRowAtIndexPath {
        return { _, _ in
            return true
        }
    }
}

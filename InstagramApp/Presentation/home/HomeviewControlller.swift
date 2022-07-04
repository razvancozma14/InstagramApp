//
//  HomeviewControlller.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 25.06.2022.
//

import RxSwift
import RxCocoa
import RxSwiftExt

class HomeviewControlller: UIViewController {
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView(frame: CGRect.zero)
        tableview.register(HomeItemTableViewCell.self, forCellReuseIdentifier: "HomeItemTableViewCell")
        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 40
        tableview.separatorStyle = .none
        tableview.backgroundColor = .clear
        return tableview
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter
    }()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.requestData()
    }
    
    func setupBindings() {
        viewModel.error.asObservable()
            .observe(on: MainScheduler.instance)
            .do(onNext: {[weak self]  (error) in
                guard let self = self else { return }
                self.showAlert(error: error)
            }).subscribe().disposed(by: disposeBag)
        
        viewModel.homeUIItems.asObservable()
            .observe(on: MainScheduler.instance)
                .bind(to: tableView.rx.items(cellIdentifier: "HomeItemTableViewCell", cellType: HomeItemTableViewCell.self)) { [weak self]  (row,item,cell) in
                    guard let self = self else { return }
                    cell.update(uiElement: item, dateFormatter: self.dateFormatter)
                    
                }.disposed(by: disposeBag)
        
        tableView.rx
            .willDisplayCell
            .subscribe(onNext: {[weak self]  _, indexPath in
                guard let self = self else { return }
                if indexPath.row == self.viewModel.homeUIItems.value.count - 1 && !self.viewModel.homeUIItems.value.isEmpty {
                    self.viewModel.loadNextPage()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.loading.asObservable()
            .observe(on: MainScheduler.instance)
            .do(onNext: {[unowned self]  (show) in
                show ? self.refreshControl.beginRefreshing() : self.refreshControl.endRefreshing()
                self.tableView.isUserInteractionEnabled = !show
            }).subscribe().disposed(by: disposeBag)
    }
    
    private func showAlert(error: HomeViewModel.HomeError) {
        var message = ""
        switch error {
        case .internetError(let error):
            message = error
        }
        let alert = UIAlertController(title: "Oooops!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: {[unowned self] (_) in
            self.viewModel.retry()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    override func loadView() {
        super.loadView()
        self.title = "Posts"
        view.backgroundColor = .black
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.leadingAnchor(equalTo: view.leadingAnchor)
            .trailingAnchor(equalTo: view.trailingAnchor)
            .topAnchor(equalTo: view.safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        refreshControl.tintColor = .white
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)

    }
    
    @objc private func refreshData(_ sender: Any) {
        self.viewModel.retry()
    }
}

//
//  ViewController.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import UIKit

class SellerListViewController: UIViewController {
    let divideView: UIView = UIView()
    let tableView: UITableView = UITableView()
    lazy var locationButtonView: LocationButtonView = LocationButtonView()
    
    var sellerType: SellerViewType
    let topAlertViewIdentifier = "topAlertTableViewCell"
    var isNeededTopAlertView: Bool = true
    var topAlertList = [TopAlertModel]()
    var isLoading = false
    var sellerInfoLoaders: [SellerInfoLoader] = (0..<10).map{ _ in SellerInfoLoader()}
    
    //MARK: - init
    init(type: SellerViewType) {
        sellerType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        sellerType = SellerViewType.sellerCell
        
        super.init(coder: coder)
    }
    
    // MARK: - method
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDivideView()
        setUpTableView()
        setUpNavigationBar()
        setUpRefreshControl()
        setUpSurveyRequest()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSurveyPost(notification:)), name: .surveyPost(), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveLocationPost(notification:)), name: .locationPost(), object: nil)
        
    }
    
    func setUpSurveyRequest() {
        switch sellerType {
        case .notificationCell:
            isNeededTopAlertView = false
        case .sellerCell:
            isNeededTopAlertView = true
            fetchSurvey {
                DispatchQueue.mainAsync {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - setUpView
    func setUpDivideView() {
        view.addSubview(divideView)
        let safeLayout = view.safeAreaLayoutGuide
        divideView.translatesAutoresizingMaskIntoConstraints = false
        divideView.backgroundColor = .lightGray
        NSLayoutConstraint.activate(
            [divideView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
             divideView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
             divideView.topAnchor.constraint(equalTo: safeLayout.topAnchor),
             divideView.heightAnchor.constraint(equalToConstant: 0.5)])
    }
    
    func setUpTableView() {
        view.addSubview(tableView)
        let safeLayout = view.safeAreaLayoutGuide
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [tableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
             tableView.topAnchor.constraint(equalTo: divideView.bottomAnchor),
             tableView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor)])
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.register(SellerTableViewCell.self, forCellReuseIdentifier: sellerType.identifier)
        tableView.register(TopAlertTableViewCell.self, forCellReuseIdentifier: topAlertViewIdentifier)
    }
    
    func setUpRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.tintColor = UIColor(named: "carrotColor")
        tableView.refreshControl = refresh
        
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl),
                                            for: .valueChanged)
    }
    
    func setUpNavigationBar() {
        switch sellerType {
        case .sellerCell:
            let notificationButton = UIBarButtonItem(title: "알림",
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(clickNotificationButton))
            notificationButton.tintColor = .black
            let location = UIBarButtonItem(customView: locationButtonView)
            navigationItem.rightBarButtonItems = [notificationButton]
            navigationItem.leftBarButtonItems = [location]

        case .notificationCell:
            let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                              target: self, action: nil)
            trashButton.tintColor = .black
            let backButton = UIBarButtonItem(title: "<-",
                                             style: .done,
                                             target: self,
                                             action: #selector(clickBackButton))
            backButton.tintColor = .black
            navigationItem.title = "알림"
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            navigationItem.rightBarButtonItems = [trashButton]
            navigationItem.leftBarButtonItems = [backButton]
        }
    }
    
    //MARK: - Action
    @objc func clickNotificationButton() {
                let notificationViewController = SellerListViewController(type: .notificationCell)
                navigationController?.pushViewController(notificationViewController, animated: true)
    }
    @objc func clickBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc func handleRefreshControl() {
        refreshAllData()
    }
    
    func refreshAllData() {
        refreshSllerInfoLoaders()
        setUpSurveyRequest()
        tableView.refreshControl?.endRefreshing()
    }
    
    func refreshSllerInfoLoaders() {
        sellerInfoLoaders = (0..<10).map{ _ in SellerInfoLoader()}
    }
    
    func fetchSurvey(_ completion: @escaping () -> Void ) {
        SurveyLoader.load { result in
            switch result {
            case .success(let model) :
                self.topAlertList = [model]
                completion()
            case .failure(let error): print(error)
            }
        }
    }
    
    func fetchLocationCertification(by name: String ) {
        PopulationLoader.load { population in
            let surveyModel = createRandomLocationCertification(name: name, with: population)
            self.topAlertList = [surveyModel]
            self.refreshSllerInfoLoaders()
            DispatchQueue.mainAsync {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func didReceiveLocationPost(notification: Notification) {
        guard let location = notification.userInfo?[Notification.Name.locationPost()] as? String else { return }
        if location != "산본동" {
            fetchLocationCertification(by: location)
        } else {
            fetchSurvey {
                self.refreshSllerInfoLoaders()
                DispatchQueue.mainAsync {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func didReceiveSurveyPost(notification: Notification) {
        DispatchQueue.mainAsync { [self] in 
            topAlertList.removeAll()
            tableView.beginUpdates()
            tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            tableView.endUpdates()
        }
    }
}

// MARK: - tableViewDataSource
extension SellerListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return isNeededTopAlertView ? topAlertList.count : 0
        default: return sellerInfoLoaders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: topAlertViewIdentifier,for: indexPath) as? TopAlertTableViewCell else { return UITableViewCell() }
            cell.updateTopAlertView(by: topAlertList[indexPath.row])
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sellerType.identifier, for: indexPath) as? SellerTableViewCell else { return UITableViewCell() }
            cell.indexPath = indexPath
            let sellerLoader = sellerInfoLoaders[indexPath.row]
            
            if let seller = sellerLoader.sellerInfo {
                //
                DispatchQueue.mainAsync {
                    cell.updateSellerView(by: seller)
                }
            }
            return cell
        }
    }
    
    /*
     이미지가 있다면, 이미지를 그대로 사용하고,
     이미지가없다면, 로드하는중이거나, 안하고있는중이므로,
     클로저에 이미지를 로드완료하면 셀에 업데이트하는것을 저장하고,
     만약 로드안하고있다면 로드하고,
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let cell = cell as? TopAlertTableViewCell else { return  }
            cell.updateTopAlertView(by: topAlertList[indexPath.row])
        default:
            guard let cell = cell as? SellerTableViewCell else { return }
            cell.indexPath = indexPath
            let sellerLoader = sellerInfoLoaders[indexPath.row]
            if let seller = sellerLoader.sellerInfo {
                DispatchQueue.mainAsync {
                    cell.updateSellerView(by: seller)
                }
            } else {
                sellerLoader.completion = {  seller in
                    if cell.indexPath == indexPath {
                        DispatchQueue.mainAsync {
                            cell.updateSellerView(by: seller)
                            UIView.setAnimationsEnabled(false)
                            tableView.beginUpdates()
                            tableView.endUpdates()
                            UIView.setAnimationsEnabled(true)
                        }
                    }
                }
                if sellerLoader.dataTask?.state != .running {
                    sellerLoader.load()
                }
            }
        }
    }
}

//MARK: - TableView Prefetch 
extension SellerListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let imageLoader = sellerInfoLoaders[$0.row]
            if $0.section == 1, imageLoader.dataTask?.state != .running {
                imageLoader.indexPath = $0
                imageLoader.load()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if $0.section == 1 {
                
                let imageLoader = sellerInfoLoaders[$0.row]
                imageLoader.completion = nil
                imageLoader.dataTask?.cancel()
            }
        }
    }
}

//MARK: - TableView Scroll
extension SellerListViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentSize = scrollView.contentSize
        let frame = scrollView.frame.size
        let offset = scrollView.contentOffset.y
        if !isLoading, frame.height*1.2 >= contentSize.height - offset {
            isLoading = true
            tableView.performBatchUpdates {
                let count = sellerInfoLoaders.count
                let indexPaths: [IndexPath] = (0..<10).map{
                    sellerInfoLoaders.append(SellerInfoLoader())
                    return IndexPath(row: count+$0, section: 1)
                }
                tableView.insertRows(at: indexPaths, with: .none)
            } completion: { _ in
                self.isLoading = false
            }
        }
    }
}

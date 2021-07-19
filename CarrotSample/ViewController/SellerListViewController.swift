//
//  ViewController.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import UIKit

class SellerListViewController: UIViewController {
    var tableView: UITableView = UITableView()
    var divideView: UIView = UIView()
    
    var sellerType: SellerViewType
    let surveyViewIdentifier = "surveyViewCell"
    var isSurveyRequest: Bool = true {
        didSet {
            DispatchQueue.main.async { [self] in
                if isSurveyRequest {
//                    tableView.reloadData()
//                    if tableView.cellForRow(at: IndexPath(row: 0, section: 0)) == nil  {
//                        tableView.performBatchUpdates {
//                            tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
//                        }
//                    }
                } else {
                    if let _ = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
                        tableView.performBatchUpdates {
                                tableView.deleteRows(at: [IndexPath(item: 0, section: 0)], with: .automatic)
                        }
                    }
                }
            }
        }
    }
    
    var isLoading = false
    var sellerInfoLoaders: [SellerInfoLoader] = (0..<20).map{ _ in SellerInfoLoader()}
    
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
        setUpSurveyRequest()
        setUpDivideView()
        setUpTableView()
        setUpNavigationBar()
        setUpRefreshControl()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSurveyPost(notification:)), name: .surveyPost(), object: nil)
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now()+5) {
//            self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
//            self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
//            print("-")
//        }
    }
    
    func setUpSurveyRequest() {
        switch sellerType {
        case .notificationCell: isSurveyRequest = false
        case .sellerCell: isSurveyRequest = true
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
        tableView.estimatedRowHeight = 300
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.reloadData()
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.register(SellerTableViewCell.self, forCellReuseIdentifier: sellerType.identifier)
        tableView.register(SurveyViewCell.self, forCellReuseIdentifier: surveyViewIdentifier)
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
            let location = UIBarButtonItem(customView: locView)
            location.action = #selector(clickLocation)
            let tapGetsure = UITapGestureRecognizer(target: self, action: #selector(showLocationList(sender:)))
            locView.addGestureRecognizer(tapGetsure)
            locView.isUserInteractionEnabled = true
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
    
    @objc func clickSearch() {
        
    }
    
    @objc func handleRefreshControl() {
        setUpSurveyRequest()
        sellerInfoLoaders = (0..<20).map{ _ in SellerInfoLoader()}
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        
    }
    
    
    var listView: UIStackView!
    @objc func showLocationList(sender: UITapGestureRecognizer) {
        guard let senderView = sender.view else { return }
        guard let frame = senderView.superview?.convert(senderView.frame, to:nil) else { return }
        guard let naviView = navigationController?.view else { return }
        
        let alphaView = UIView(frame: naviView.frame )
        naviView.addSubview(alphaView)
        alphaView.backgroundColor = .black
        alphaView.alpha = 0
        alphaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeAlphaView(sender:))))
        
        let x = frame.minX
        let y = frame.maxY
        listView = UIStackView()
        listView.axis = .vertical
        listView.backgroundColor = .white
        listView.distribution = .fill
        listView.setRoundCorner(to: 5.0)
        listView.clipsToBounds = true
        let locList = ["   산본동","   아현동","   내 동네 설정하기"]
        for i in 0..<locList.count {
            let label = UILabel()
            label.text = locList[i]
            label.textColor = i == 0 ? .black : .darkGray
            label.font.withSize(14.0)
            let separator = UIView()
            separator.backgroundColor = .lightGray
            listView.addArrangedSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            label.backgroundColor = .white
            if i < 2 {
                listView.addArrangedSubview(separator)
                separator.setContentHuggingPriority(.required, for: .vertical)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            }
        }
        
        
        naviView.addSubview(listView)
        listView.translatesAutoresizingMaskIntoConstraints = false
        listView.topAnchor.constraint(equalTo: naviView.topAnchor, constant: y).isActive = true
        listView.leadingAnchor.constraint(equalTo: naviView.leadingAnchor,constant: x).isActive = true
        listView.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        
        listView.setRoundCorner(to: 7.0)
        
        listView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5) { [self] in
            alphaView.alpha = 0.5
            listView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    @objc func removeAlphaView(sender: UITapGestureRecognizer ) {
        UIView.animate(withDuration: 0.5) { [self] in
            navigationController?.view.layoutIfNeeded()
            listView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            sender.view?.alpha = 0.0
        } completion: { [self] compelte  in
            sender.view?.removeFromSuperview()
            listView.removeFromSuperview()
        }
    }
    
    @objc func clickLocation() {
        UIView.animate(withDuration: 0.5) { [self] in
            locView.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    let locView: UILabel = {
        let label = UILabel()
        label.text = "산본동"
        label.textColor = .black
        return  label
    }()
    
    @objc func didReceiveSurveyPost(notification: Notification) {
        isSurveyRequest = false
    }
}

// MARK: - tableViewDataSource
extension SellerListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return isSurveyRequest ? 1 : 0
        default: return sellerInfoLoaders.count
        }
    }
    
    /*
     이미지가 있다면, 이미지를 그대로 사용하고,
     이미지가없다면, 로드하는중이거나, 안하고있는중이므로,
     클로저에 이미지를 로드완료하면 셀에 업데이트하는것을 저장하고,
     만약 로드안하고있다면 로드하고,
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: surveyViewIdentifier,for: indexPath) as? SurveyViewCell else { return UITableViewCell() }
//            cell.titleLabel.text = "asdfansjdlfalkjsbdflkjabskjdbfaljkbsdflkjabskjfbakbsldkjfblaksdbfbakjbsjdf"
            if isSurveyRequest {
                SurveyLoader().load { result in
                    switch result {
                    case .success(let model):
                        
                        DispatchQueue.main.async {
                            cell.updateSurveyView(with: model)
                            
                            }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sellerType.identifier, for: indexPath) as? SellerTableViewCell else { return UITableViewCell() }
            
            cell.indexPath = indexPath
            let sellerLoader = sellerInfoLoaders[indexPath.row]
            
            if let seller = sellerLoader.sellerInfo {
                DispatchQueue.main.async {
                    cell.updateSellerView(with: seller)
                }
            } else {
                sellerLoader.completion = {  seller in
                    DispatchQueue.main.async {
                        if cell.indexPath == indexPath {
                            cell.updateSellerView(with: seller)
                        }
                        sellerLoader.completion = nil
                    }
                }
                if sellerLoader.dataTask == nil {
                    sellerLoader.load()
                } else {
                    if sellerLoader.isError {
                        sellerLoader.load()
                    }
                }
            }
            return cell
        }
    }
    

}

//MARK: - TableView Prefetch 
extension SellerListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if $0.section == 1 {
                let imageLoader = sellerInfoLoaders[$0.row]
                
                if let dataTask = imageLoader.dataTask {
                    dataTask.resume()
                } else {
                    imageLoader.load()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            if $0.section == 1 {
                let imageLoader = sellerInfoLoaders[$0.row]
                imageLoader.completion = nil
                if let dataTask = imageLoader.dataTask {
                    dataTask.cancel()
                }
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
                let indexPaths: [IndexPath] = (0..<20).map{
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

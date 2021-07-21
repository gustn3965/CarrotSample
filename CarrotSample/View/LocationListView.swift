//
//  LocationListView.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/19.
//

import UIKit

class LocationListView: UIView {

    var listView: UIStackView = UIStackView()
    var strLocationList: [String] = Array(repeating: "", count: 3)
    var isLocationList: [Bool] = Array(repeating: false, count: 3)
    var selectedIndex: Int = 0
    var actionList = [#selector(clickList1), #selector(clickList2), #selector(clickList3)]
    var locationList: [String] = Array(repeating: "", count: 3)
    
    //MARK: - init
    convenience init(list: [String]) {
        self.init(frame: .zero)
        
        for i in 0..<list.count {
            self.strLocationList[i] = "   " + list[i]
            self.locationList[i] = list[i]
            self.isLocationList[i] = true
        }
        setUpView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - setUpView
    private func setUpView() {
        listView.axis = .vertical
        listView.backgroundColor = .white
        listView.distribution = .fill
        listView.setRoundCorner(to: 5.0)
        listView.clipsToBounds = true
        for i in 0..<strLocationList.count {
            let label = UILabel()
            label.text = strLocationList[i]
            label.textColor = i == selectedIndex ? .black : .darkGray
            label.font.withSize(14.0)
            let separator = UIView()
            separator.backgroundColor = .lightGray
            listView.addArrangedSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
            label.backgroundColor = .white
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: actionList[i]))
            if i < 2 {
                listView.addArrangedSubview(separator)
                separator.setContentHuggingPriority(.required, for: .vertical)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            }
        }
        
        addSubview(listView)
        listView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [listView.leadingAnchor.constraint(equalTo: leadingAnchor),
             listView.trailingAnchor.constraint(equalTo: trailingAnchor),
             listView.topAnchor.constraint(equalTo: topAnchor),
             listView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        listView.setRoundCorner(to: 7.0)
    }
    
    //MARK: - Action
    @objc func clickList1() {
        postLocation(by: 0)
    }
    
    @objc func clickList2() {
        postLocation(by: 1)
    }
    
    @objc func clickList3() {
        postLocation(by: 2)
    }
    
    private func postLocation(by idx: Int ) {
        NotificationCenter.default.post(name: .locationPost(), object: nil, userInfo: [Notification.Name.locationPost(): locationList[idx]])
    }
}

//
//  LocationButtonView.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/19.
//

import UIKit

/// NavigationBar 좌측에 나타나는 지역을 나타내는 뷰
///
/// 터치시,  LocationlistLoader를 통해 비동기적으로 지역리스트를 가져오고, 흐릿한 뷰와 LocationListView가 나타납니다.
class LocationButtonView: UIView {
    
    var stackView: UIStackView = UIStackView()
    var locationLabel: UILabel = UILabel()
    var arrowLabel: UILabel = UILabel()
    
    var didTouchCompletion: (() -> Void)?
    var isTouched: Bool = false
    
    lazy var locationListView: LocationListView = LocationListView()
    lazy var alphaView: UIView = UIView()
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        addReceiveNotification()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - setUpView
    private func setUpView() {
        locationLabel.text = "산본동"
        locationLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        arrowLabel.text = "⬇"
        arrowLabel.font = arrowLabel.font.withSize(17)
        arrowLabel.textColor = .black
        locationLabel.textColor = .black
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(arrowLabel)
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        arrowLabel.backgroundColor = .white
        locationLabel.backgroundColor = .white
        backgroundColor = .white
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        locationLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        arrowLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate(
            [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
             stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
             stackView.topAnchor.constraint(equalTo: topAnchor),
             stackView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouch)))
    }
    
    //MARK: - Action
    @objc func didTouch() {
        UIView.animate(withDuration: 0.3) {
            self.arrowLabel.transform =  CGAffineTransform(rotationAngle: .pi)
            self.isTouched.toggle()
            self.showLocationListView()
        }
    }
    
    
    @objc func clickAlphaView(sender: UITapGestureRecognizer ) {
        removeAlphaView()
    }
    
    private func removeAlphaView() {
        UIView.animate(withDuration: 0.3) { [self] in
            locationListView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            alphaView.alpha = 0.0
            arrowLabel.transform = CGAffineTransform(rotationAngle: 0)
        } completion: { [self] compelte  in
            alphaView.removeFromSuperview()
            locationListView.removeFromSuperview()
        }
    }
    
    /// 흐릿한 배경과 LocationListView가 나타납니다.
    private func showLocationListView() {
        LocationListLoader.load { [self] locationList in
            DispatchQueue.mainAsync {
                self.locationListView = LocationListView(list: locationList)
                
                alphaView = UIView(frame: UIApplication.shared.keyWindow!.frame )
                alphaView.backgroundColor = .black
                alphaView.alpha = 0
                alphaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickAlphaView(sender:))))
                
                let frame = self.superview?.convert(self.frame, to: nil)
                let x: CGFloat = frame!.minX
                let y: CGFloat = frame!.maxY + 10
                self.locationListView.frame = CGRect(x: x, y: y, width: 200.0, height: 151 )
                
                UIApplication.shared.keyWindow!.addSubview(alphaView)
                UIApplication.shared.keyWindow!.addSubview(self.locationListView)
                self.locationListView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                UIView.animate(withDuration: 0.3) {
                    alphaView.alpha = 0.5
                    self.locationListView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        }
    }

    private func addReceiveNotification() {
        NotificationCenter.default.addObserver(forName: .locationPost(), object: nil, queue: .main) { notification in
            self.didReceiveLocationPost(notification: notification)
        }
    }
    
    @objc func didReceiveLocationPost(notification: Notification) {
        guard let location = notification.userInfo?[Notification.Name.locationPost()] as? String   else { return }
        guard let label = stackView.arrangedSubviews[0] as? UILabel else { return }
        label.text = location
        removeAlphaView()
    }
}

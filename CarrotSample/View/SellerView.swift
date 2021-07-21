//
//  HomeTableViewCell.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/06.
//

import UIKit

class SellerView: UIView {
    
    
    @IBOutlet weak var imageImageView: UIImageView!
    
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var middleStackView: UIStackView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var stateLabel: StateLabel!
    
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var messageCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var soldView: UIView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var imageViewHeightContraint: NSLayoutConstraint!
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        makeRoundCorner()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        makeRoundCorner()
    }
    
    //MARK: - setUpView
    private func loadView() {
        let bundle = Bundle(for: SellerView.self)
        let nib = UINib(nibName: "SellerView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
    }
    
    /// SellerView를 재활용하기위해,  `Type`에 따라 `SellerView`의 레이아웃을 변경한다.
    func change(Type type: SellerViewType) {
        let heightConstant = convertToConstant(by: type)
        imageViewHeightContraint.constant = heightConstant
        imageViewHeightContraint.isActive = true
        
        switch type {
        case .sellerCell:
            topStackView.isHidden = false
            middleStackView.isHidden = false
            bottomStackView.isHidden = false
        case .notificationCell:
            topStackView.isHidden = false
            middleStackView.isHidden = true
            bottomStackView.isHidden = true
        }
    }
    
    //MARK: -
    private func makeRoundCorner() {
        imageImageView.setRoundCorner(to: 10.0)
    }
    
    func updateView(by seller: SellerModel?) {
        DispatchQueue.mainAsync { [self] in 
            guard let seller = seller else {
                titleLabel.text = nil
                priceLabel.text = nil
                locationLabel.text = nil
                imageImageView.image = nil
                stateLabel.isHidden = true
                likeCountLabel.isHidden = true
                messageCountLabel.isHidden = true
                setSoldView(isSold: false)
                indicatorView.startAnimating()
                indicatorView.isHidden = false
                return }
            indicatorView.stopAnimating()
            imageImageView.image = seller.thumbnail
            indicatorView.isHidden = true
            titleLabel.text = seller.title
            priceLabel.text = seller.price.returnPriceString() + "원"
            locationLabel.text = seller.location
            stateLabel.isHidden = seller.state.color == nil ? true : false
            stateLabel.updateView(by: seller.state)
            likeCountLabel.isHidden = seller.likeCount == 0
            messageCountLabel.isHidden = seller.messageCount == 0
            likeCountLabel.text = "♡ \(seller.likeCount)"
            messageCountLabel.text = "✉️ \(seller.messageCount)"
            setSoldView(isSold: seller.state == .sold )
        }
    }
    
    private func setSoldView( isSold: Bool ) {
        soldView.alpha = isSold ? 0.7 : 0.0
        soldView.backgroundColor = isSold ? .white : .clear
    }
    
    private func convertToConstant(by type: SellerViewType) -> CGFloat{
        switch type {
        case .sellerCell : return 120.0
        case .notificationCell: return 60.0
        }
    }


}

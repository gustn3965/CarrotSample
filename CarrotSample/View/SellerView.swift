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
    
    // MARK: - method
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
    
    private func loadView() {
        let bundle = Bundle(for: SellerView.self)
        let nib = UINib(nibName: "SellerView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self).first as? UIView else { return }
        view.frame = bounds
        addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate(
//        [view.leadingAnchor.constraint(equalTo: leadingAnchor),
//         view.trailingAnchor.constraint(equalTo: trailingAnchor),
//         view.topAnchor.constraint(equalTo: topAnchor),
//         view.bottomAnchor.constraint(equalTo: bottomAnchor)])
//       
    }
    
    private func makeRoundCorner() {
        imageImageView.setRoundCorner(to: 10.0)
    }
    
    func updateSellerView(with seller: SellerModel?) {
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
        priceLabel.text = String.returnPriceString(with: seller.price) + "원"
        locationLabel.text = seller.location
        stateLabel.isHidden = seller.state.color == nil ? true : false
        stateLabel.setBackground(with: seller.state)
        stateLabel.setText(with: seller.state)
        likeCountLabel.isHidden = seller.likeCount == 0
        messageCountLabel.isHidden = seller.messageCount == 0
        likeCountLabel.text = "♡ \(seller.likeCount)"
        messageCountLabel.text = "✉️ \(seller.messageCount)"
        setSoldView(isSold: seller.state == .sold )
    }
    
    private func setSoldView( isSold: Bool ) {
        soldView.alpha = isSold ? 0.7 : 0.0
        soldView.backgroundColor = isSold ? .white : .clear
    }

}

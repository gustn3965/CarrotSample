//
//  ImageLoader.swift
//  CarrotSample
//
//  Created by hyunsu on 2021/07/13.
//

import Foundation
import UIKit.UIImage

/// 판매자의 정보를 비동기적으로 가져오는 객체
class SellerInfoLoader {
    
    var dataTask: URLSessionDataTask?
    var sellerInfo: SellerModel? = nil {
        didSet {
            completion?(sellerInfo)
        }
    }
    
    var indexPath: IndexPath?
    
    var completion: ((SellerModel?) -> Void)?
    var isError = false
    
    func load() {
        if let _ = sellerInfo { return }
        
        guard let url = URL(string: "https://source.unsplash.com/random/100x100") else {
            completion?(nil)
            return }
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode),
                  error == nil,
                  let data = data,
                  let loadedImage = UIImage(data: data) else {
                self?.isError = true
                self?.sellerInfo = nil
                return }
            
            self?.isError = false
            let sellerModel = createMockSeller()
            sellerModel.thumbnail = loadedImage
            self?.sellerInfo = sellerModel
        })
        dataTask?.resume()
    }
}

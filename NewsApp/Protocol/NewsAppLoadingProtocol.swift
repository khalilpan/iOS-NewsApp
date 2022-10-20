//
//  NewsAppLoadingProtocol.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import Foundation
import UIKit

protocol NewsAppLoadingProtocol { }

extension NewsAppLoadingProtocol where Self: UIViewController {
    func showLoadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func closeLoadingIndicator() {
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

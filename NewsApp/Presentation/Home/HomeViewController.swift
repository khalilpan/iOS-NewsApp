//
//  ViewController.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "News"
        APICaller.sharedInstance.getTopStories { result in
            switch result {
            case .success(let response):
                break
                
            case .failure(let error):
                print(error)
                
            default:
                break
            }
        }
    }
}


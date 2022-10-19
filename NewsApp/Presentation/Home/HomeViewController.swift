//
//  ViewController.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController {
    private var viewModel = HomeViewModel()
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "News"
        APICaller.sharedInstance.getTopStories { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.viewModel.articles = response
                self.viewModel.headLines = response.compactMap({ HomeTableViewCellType(
                    title: $0.title,
                    subtitle: $0.description ?? "No Description",
                    imageURL: URL(string: $0.urlToImage ?? "")
                )
                })
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
                
            default:
                break
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.headLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        
        if (indexPath.row < self.viewModel.headLines.count) {
            cell.setupData(data: self.viewModel.headLines[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row < self.viewModel.articles.count) {
            let article = self.viewModel.articles[indexPath.row]
            
            guard let url = URL(string: article.url ?? "") else { return }
            
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

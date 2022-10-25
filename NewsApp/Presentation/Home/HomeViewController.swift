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
    
    private var searchVC = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        setupUI()
        setupRefreshControl()
        self.viewModel.delegate = self
        self.viewModel.fetchHealdLines(calltype: .topHeadlines, with: nil)
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        navigationItem.searchController = searchVC
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(tableView.topAnchor.constraint(equalTo: view.topAnchor))
        constraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        constraints.append(tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        constraints.append(tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
        tableView.delegate = self
        tableView.dataSource = self
        searchVC.searchBar.delegate = self
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(handleRefreshPull), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func handleRefreshPull() {
        var queryText: String? = nil
        var callType: NewsArticlesCallType = .topHeadlines
        if let text = self.searchVC.searchBar.text, !text.isEmpty {
            queryText = text
            callType = .searchQuery
        }
        
        self.viewModel.fetchHealdLines(calltype: callType, with: queryText, showLoadingIndicator: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1/2)) {
            self.refreshControl.endRefreshing()
        }
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
        
        if let data = self.viewModel.headLines[safe: indexPath.row] {
            let cellData = data
            cell.setupData(data: cellData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let article = self.viewModel.articles[safe: indexPath.row] {
            
            guard let url = URL(string: article.url) else { return }
            
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

//MARK: - TopHeadlinesFetchDelegate, NewsAppLoadingProtocol
extension HomeViewController: TopHeadlinesFetchDelegate, NewsAppLoadingProtocol {
    func loadingStarted() {
        DispatchQueue.main.async {
            self.showLoadingIndicator()
        }
    }
    
    func loadingFinished() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.closeLoadingIndicator()
        }
    }
}

//MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        
        self.viewModel.fetchHealdLines(calltype: .searchQuery, with: text, showLoadingIndicator: false)
    }
}

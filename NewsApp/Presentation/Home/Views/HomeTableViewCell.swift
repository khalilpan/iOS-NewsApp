//
//  HomeTableViewCell.swift
//  NewsApp
//
//  Created by khalil on 19/10/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
    
    private let newsTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 2
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 17, weight: .light)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let newsImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.backgroundColor = .secondarySystemBackground
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(newsImageView)
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(newsTitleLabel.topAnchor.constraint(equalTo: self.topAnchor ,constant: 10))
        constraints.append(newsTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor ,constant: 10))
        constraints.append(newsTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor ,multiplier: 0.5))
        
        constraints.append(subTitleLabel.topAnchor.constraint(equalTo: self.newsTitleLabel.bottomAnchor ,constant: 10))
        constraints.append(subTitleLabel.leadingAnchor.constraint(equalTo: self.newsTitleLabel.leadingAnchor ,constant: 0))
        constraints.append(subTitleLabel.widthAnchor.constraint(equalTo: self.widthAnchor ,multiplier: 0.5))
        constraints.append(subTitleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor ,constant: -5))
        
        constraints.append(newsImageView.topAnchor.constraint(equalTo: self.newsTitleLabel.topAnchor ,constant: 0))
        constraints.append(newsImageView.leadingAnchor.constraint(equalTo: self.newsTitleLabel.trailingAnchor ,constant: 5))
        constraints.append(newsImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor ,constant: -5))
        constraints.append(newsImageView.bottomAnchor.constraint(equalTo: self.subTitleLabel.bottomAnchor ,constant: 0))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupData(data: HomeTableViewCellType) {
        self.newsTitleLabel.text = data.title
        self.subTitleLabel.text = data.subtitle
        var imageData = data.imageData
        
        if let image = imageData {
            newsImageView.image = UIImage(data: image)
        } else if let url = data.imageURL {
            
            //TODO: - Move APICaller to HomeViewModel
            NewsApiRepository.sharedInstance.fetchImage(url: url, completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    imageData = data
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: data)
                    }
                    
                case .failure(let error):
                    debugPrint(error)
                }
            })
        }
    }
}

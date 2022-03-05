//
//  FeedTableViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

  //MARK: - Properties
    
    static let idintifier = "FeedTableViewCell"
    
    private let articleImage: UIImageView = {
  
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 1
        return image
    }()
    
     let articleTitle: UILabel = {
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.clipsToBounds = true
        title.numberOfLines = 0
        return title
    }()
    
     let articleSource: UILabel = {
        
        let source = UILabel()
        source.translatesAutoresizingMaskIntoConstraints = false
        source.numberOfLines = 1
        return source
    }()
    
    
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        contentView.addSubview(articleImage)
        contentView.addSubview(articleTitle)
    }
    
    func configureCell(with article:Article){
        
        articleTitle.text = article.title
        articleSource.text = article.newsSite
        articleImage.image = fetchImage(with: article.imageUrl)
    }
    
    func fetchImage(with url:String) -> UIImage {
        var image = UIImage()
        NetworkManager.shared.fetchArticleImage(url: url) { results in
            switch results {
            case .success(let fetchedImage):
               image = fetchedImage
            case .failure(let error):
                print("imagedownloading error \(error)")
            }
    }
        return image
    }
    
    func setConstraints(){
        
        let articleImageConstraints = [
            articleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let artticleTitleConstraints = [
            articleTitle.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor, constant: 5),
            articleTitle.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: -20),
            articleTitle.topAnchor.constraint(equalTo: articleImage.topAnchor, constant: 5),
            articleTitle.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: -5)
        ]
        
//        let articleSourceConstraints = [
//            articleSource.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor, constant: 5),
//            articleSource.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: -20),
//            articleSource.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: -5)
//
//        ]
        
        NSLayoutConstraint.activate(articleImageConstraints)
        NSLayoutConstraint.activate(artticleTitleConstraints)
//        NSLayoutConstraint.activate(articleSourceConstraints)
    }
    
    
    
    
}


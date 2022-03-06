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
        title.font = .boldSystemFont(ofSize: 35)
        title.textColor = .white
        return title
    }()
    
     let articleSource: UILabel = {
        
        let source = UILabel()
        source.translatesAutoresizingMaskIntoConstraints = false
        source.numberOfLines = 1
         source.textColor = .systemYellow
         source.font = .boldSystemFont(ofSize: 14)
        return source
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let myView = UIActivityIndicatorView()
        myView.hidesWhenStopped = true
        myView.style = .medium
        myView.color = .systemPink
        myView.startAnimating()
        return myView
    }()
    
    private let blackView: UIView = {
       let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = contentView.center
        blackView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        contentView.addSubview(articleImage)
        contentView.addSubview(articleSource)
        articleImage.addSubview(blackView)
        contentView.addSubview(articleTitle)
        articleImage.addSubview(activityIndicatorView)
    }
    
    func configureCell(with article:Article){
        
        articleTitle.text = article.title
        articleSource.text = article.newsSite
        NetworkManager.shared.fetchArticleImage(url: article.imageUrl) { results in
            switch results {
            case .success(let fetchedImage):
                self.articleImage.image = fetchedImage
                self.activityIndicatorView.stopAnimating()
            case .failure(let error):
                self.articleImage.image = UIImage(named: "test")
                print("imagedownloading error \(error)")
            }
        }
    }
    
    func setConstraints(){
        
        let articleImageConstraints = [
            articleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let artticleTitleConstraints = [
            articleTitle.leadingAnchor.constraint(equalTo: articleImage.leadingAnchor, constant: 15),
            articleTitle.trailingAnchor.constraint(equalTo: articleImage.trailingAnchor, constant: -contentView.frame.width/3),
            articleTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            articleTitle.bottomAnchor.constraint(equalTo: articleImage.bottomAnchor, constant: -5)
        ]
        
        let articleSourceConstraints = [
          
            articleSource.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            articleSource.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)

        ]
        
        NSLayoutConstraint.activate(articleImageConstraints)
        NSLayoutConstraint.activate(artticleTitleConstraints)
        NSLayoutConstraint.activate(articleSourceConstraints)
    }
    
    
    
    
}


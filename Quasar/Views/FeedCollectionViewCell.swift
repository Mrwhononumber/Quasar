//
//  FeedTableViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

  //MARK: - Properties
    
    static let idintifier = "FeedCollectionViewCell"
    
    private let articleImage: UIImageView = {
  
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 1
        image.layer.cornerRadius = 10
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
        myView.color = .gray
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        contentView.addSubview(activityIndicatorView)
        contentView.addSubview(articleImage)
        contentView.addSubview(articleSource)
        articleImage.addSubview(blackView)
        articleImage.addSubview(articleTitle)
    }
    
    func configureCell(with article:Article){
        
        articleTitle.text = article.title
        articleSource.text = article.newsSite
        NetworkManager.shared.fetchArticleImage(url: article.imageUrl) { [weak self] results in
            switch results {
            case .success(let fetchedImage):
                self?.articleImage.alpha = 0
                self?.articleImage.image = fetchedImage
                self?.animateImageToFadeIn(source: self!.articleImage, duration: 0.3)
                self?.activityIndicatorView.stopAnimating()
            case .failure(let error):
                self?.articleImage.image = UIImage(named: "test")
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
    
    private func animateImageToFadeIn(source: UIView?, duration: TimeInterval){
        guard source != nil else {return}
         UIView.animate(withDuration: duration) { [weak self] in
             self?.articleImage.alpha = 1
         }
     }
}


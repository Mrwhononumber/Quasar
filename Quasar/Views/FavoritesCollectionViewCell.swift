//
//  FavoritesCollectionViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 4/1/22.

import UIKit

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var favoritesVC: FavoritesViewController?
    
    static let idintifier = "FavoritesCollectionViewCell"
  
   private let ArticleImage:UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let articleTitle: UILabel = {
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.clipsToBounds = true
        title.numberOfLines = 3
        title.textColor = .gray
        title.textAlignment = .left
        title.font = .boldSystemFont(ofSize: 12)
        return title
    }()
    
    private let blackView: UIView = {
     
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private let deleteButton: UIButton = {
       let button = UIButton()
       let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "trash", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let shareButton: UIButton = {
       let button = UIButton()
       let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .medium, scale: .large)
        button.setImage(UIImage(systemName: "paperplane", withConfiguration: imageConfiguration), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicatorView: UIActivityIndicatorView = {
      
        let myView = UIActivityIndicatorView()
        myView.hidesWhenStopped = true
        myView.style = .medium
        myView.color = .gray
        myView.startAnimating()
        return myView
    }()
    
    //MARK: - Init
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
        configureDeleteButton()
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        ArticleImage.image = nil
    }
    
   //MARK: - Helper Functions
    
   private func configureUI() {
       backgroundColor = .label
        contentView.addSubview(ArticleImage)
        contentView.addSubview(articleTitle)
        contentView.addSubview(deleteButton)
        contentView.addSubview(shareButton)
    }
    
    
  public func configureCell(with article:StoredArticle) {
      
      self.articleTitle.text = article.title
      NetworkManager.shared.fetchArticleImageWith(url: article.imageUrl ?? "") { [weak self] results in
          switch results {
          case .success(let fetchedImage):
              self?.ArticleImage.image = fetchedImage
          case .failure(let error):
              self?.ArticleImage.image = UIImage(named: "PlaceHolder")
              print("imagedownloading error \(error)")
          }
      }
    }
    
    
  private  func setConstraints() {
        
     let articleImageConstraints = [
            ArticleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            ArticleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            ArticleImage.heightAnchor.constraint(equalToConstant: 150)
        ]
        
     let articleTitleConstraints = [
            articleTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            articleTitle.topAnchor.constraint(equalTo: ArticleImage.bottomAnchor, constant: -22),
            articleTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            articleTitle.heightAnchor.constraint(equalToConstant: 100)
        ]
      
     let deleteButtonConstraints = [
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 34)
      ]
      
     let shareButtonConstraints = [
        shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -34)
      ]
        
        NSLayoutConstraint.activate(articleImageConstraints)
        NSLayoutConstraint.activate(articleTitleConstraints)
        NSLayoutConstraint.activate(deleteButtonConstraints)
        NSLayoutConstraint.activate(shareButtonConstraints)
    }
    
    private func configureDeleteButton(){
        
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton(_:)), for: .touchUpInside)
    }

    @objc private func didTapDeleteButton(_ sender: UIButton) {
        favoritesVC?.handleArticleDeletion(cell: self)
        print("delete tapped")
    }
    
    private func configureShareButton() {
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    }
    
    @objc private func didTapShareButton() {
        print ("Share tapped")
        favoritesVC?.handleArticleSharing(cell: self)
    }
}

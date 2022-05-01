//
//  FeedTableViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {

  //MARK: - Properties
    
    /// Cell idintifier
    static let idintifier = "FeedCollectionViewCell"
    
    /// Instance of the HomeViewController
    var homeVC: HomeViewController?
    
    /// Flag that holds the status of the cell weather it's persisted or not
    private var isFavorite = false
    /// Article's image
    private let articleImage: UIImageView = {
  
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.alpha = 1
        image.layer.cornerRadius = 10
        return image
    }()
    /// Articles title
    private let articleTitle: UILabel = {
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.clipsToBounds = true
        title.numberOfLines = 0
        title.font = .boldSystemFont(ofSize: 35)
        title.textColor = .white
        return title
    }()
    /// Articles publisher website
    private let articleSource: UILabel = {
        
        let source = UILabel()
        source.translatesAutoresizingMaskIntoConstraints = false
        source.numberOfLines = 1
        source.textColor = .systemYellow
        source.font = .boldSystemFont(ofSize: 14)
        return source
    }()
    /// Button that adds the article to favorites
    private let favoriteButton: UIButton = {
       
        let button = UIButton()

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)
        let heartImage = UIImage(systemName: "heart", withConfiguration: largeConfig)
        let filledHeartImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
    
        button.setImage(heartImage, for: .normal)
        button.tintColor = .systemPink
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
        updateFavoriteButtonUI()
//        configureFavoriteButton()
        listenToDeleteButtonUpdates()
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = contentView.center
        blackView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        articleImage.image = nil
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        contentView.addSubview(activityIndicatorView)
        contentView.addSubview(articleImage)
        contentView.addSubview(articleSource)
        articleImage.addSubview(blackView)
        articleImage.addSubview(articleTitle)
        contentView.addSubview(favoriteButton)
    }
    
    func configureCell(with article:Article){
        
        articleTitle.text = article.title
        articleSource.text = article.newsSite
        NetworkManager.shared.fetchArticleImageWith(url: article.imageUrl) { [weak self] results in
            switch results {
            case .success(let fetchedImage):
                self?.articleImage.alpha = 0
                self?.articleImage.image = fetchedImage
                self?.animateImageToFadeIn(source: self!.articleImage, duration: 0.8)
                self?.activityIndicatorView.stopAnimating()
            case .failure(let error):
                self?.articleImage.image = UIImage(named: "PlaceHolder")
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
        
        let favoriteButtonConstraints = [
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(articleImageConstraints)
        NSLayoutConstraint.activate(artticleTitleConstraints)
        NSLayoutConstraint.activate(articleSourceConstraints)
        NSLayoutConstraint.activate(favoriteButtonConstraints)
    }
    
    private func configureFavoriteButton() {
        favoriteButton.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    }
    
    private func updateFavoriteButtonUI() {
        if isFavorite {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)
            let filledHeartImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
            favoriteButton.setImage(filledHeartImage, for: .normal)
            favoriteButton.tintColor = .systemPink
            
            print("LETS MAKE BIG HEART")
        }
    }
    
    
    @objc private func didTapFavoriteButton(_ sender: UIButton) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        let filledHeartImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
        
        switch isFavorite {
            
        case false:
            favoriteButton.setImage(filledHeartImage, for: .normal)
            favoriteButton.tintColor = .systemPink
            isFavorite = true
            homeVC?.handleArticlePersisting(cell: self, toBePersisted: true)
            print("favorite")
            
            
            
        case true:
            
            print("limboooooo land !!!")
            homeVC?.handleArticlePersisting(cell: self, toBePersisted: false)
//            favoriteButton.setImage(heartImage, for: .normal)
//            favoriteButton.tintColor = .systemYellow
//            isFavorite = false
//            print("unfavorite")
            break
        }
    }
    
    /// Here we check if the article is in favorites or not, and to be called while dequing the cell in the cellForItem method
    /// - Parameter article: The current article this cell holds
    func checkIfCurentArticleIsFavouriteWith(article:Article){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold, scale: .large)
        switch DataPersistenceManager.shared.checkIfArticleIsStoredWith(article.id) {
           
        case true:
            print("There are favorites")
            isFavorite = true
            let filledHeartImage = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)
            favoriteButton.setImage(filledHeartImage, for: .normal)
            favoriteButton.tintColor = .systemPink
            
        case false:
            print("No favorites")
            isFavorite = false
            let heartImage = UIImage(systemName: "heart", withConfiguration: largeConfig)
            favoriteButton.setImage(heartImage, for: .normal)
            favoriteButton.tintColor = .systemPink
        }
    }
    
    
    /// This method is responsible for aplying a fade in animation for the articles images
    /// - Parameters:
    ///   - source: The view to be animated
    ///   - duration: the duration of the animation
    private func animateImageToFadeIn(source: UIView?, duration: TimeInterval){
        guard source != nil else {return}
         UIView.animate(withDuration: duration) { [weak self] in
             self?.articleImage.alpha = 1
         }
     }
    
    
    /// change the isFavorite value when the article is deleted from favorites VC
    private func listenToDeleteButtonUpdates(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name.deleteArticleButtontapped, object: nil, queue: nil) { notificaiton in
            print("Deletion notification received")
            self.isFavorite = false
        }
    }
}


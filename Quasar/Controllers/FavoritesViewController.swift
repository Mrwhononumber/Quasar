//
//  FavoritesViewController.swift
//  Quasar
//
//  Created by Basem El kady on 4/1/22.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    //MARK: - Properties
    
   private var favoriteArticles = [StoredArticle]()
    
    
   private let emptyBackgroundView = EmptyBackgroundView(frame: .zero)
    
    
   private let favoritesCollectionView:UICollectionView = {
       let layout = UICollectionViewFlowLayout()
       layout.itemSize = CGSize(width: (UIScreen.main.bounds.width/2.15) - 4 , height: 245)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCollectionViewCell.idintifier)
        return collectionView
    }()
    

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
        setupEmptyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStoredArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesCollectionView.frame = view.bounds
    }
    

    
    
    //MARK: - Helper functions
    
    private func configureUI() {
        
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(favoritesCollectionView)
        view.backgroundColor = .systemBackground
    }
    
    private func loadStoredArticles() {
        
        DataPersistenceManager.shared.loadArticleFromDataBase { result in
            switch result {
            case .success(let storedArticles):
                self.favoriteArticles = storedArticles
                DispatchQueue.main.async {
                    self.favoritesCollectionView.reloadData()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.showOneButtonAlert(title: "Error", action: "Ok", message:error.rawValue)
                }
            }
        }
    }
}

//MARK: - CollectionView Implementation

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favoriteArticles.count == 0 {
            favoritesCollectionView.backgroundView?.isHidden = false
            return 0
        } else {
            favoritesCollectionView.backgroundView?.isHidden = true
            return favoriteArticles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.idintifier, for: indexPath) as! FavoritesCollectionViewCell
        
        let selectedCell = favoriteArticles[indexPath.row]
        cell.AddShadow()
        cell.configureCell(with: selectedCell)
        cell.favoritesVC = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArticle = favoriteArticles[indexPath.row]
        let detailVC = ArticleDetailViewController()
        detailVC.currentArticle = Article(id: Int(selectedArticle.id),
                                          title: selectedArticle.title ?? "",
                                          url: selectedArticle.url ?? "",
                                          imageUrl: selectedArticle.imageUrl ?? "",
                                          newsSite: selectedArticle.newsSite ?? "",
                                          summary: selectedArticle.summary ?? "",
                                          publishedAt: selectedArticle.publishedAt ?? "")
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func setupCollectionView() {
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        favoritesCollectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    //MARK: - Article deletion and sharing handling
    
    func handleArticleDeletion(cell:UICollectionViewCell) {
        
        /// Here we identifiy which article to be handeled
        guard let selectedCellIndexPath = favoritesCollectionView.indexPath(for: cell) else {return}
        let articleToBeDeleted = favoriteArticles[selectedCellIndexPath.row]
        /// Show deletion alert
        showDestructiveAlert(title: "", action: "Delete", message: "Are you sure you want to delete this article?") { _ in
            /// Delete the article from database
            DataPersistenceManager.shared.deleteArticleFromDataBaseWith(storedArticle: articleToBeDeleted) { result in
                switch result {
                case .success(_):
                    print("Article got deleted successfuly")
                    /// Broadcast a notification of the deletion action
                    NotificationCenter.default.post(name: NSNotification.Name.deleteArticleButtontapped, object: nil)
                    self.favoriteArticles.remove(at: selectedCellIndexPath.row)
                    self.favoritesCollectionView.reloadData()
                    
                    
                case .failure(let error):
                    print(error)
                    self.showOneButtonAlert(title: "Error", action: "Ok", message: error.rawValue)
                }
            }
        }
    }
    
    func handleArticleSharing(cell:UICollectionViewCell) {
        /// Here we identifiy which article to be shared
        guard let selectedCellIndexPath = favoritesCollectionView.indexPath(for: cell) else {return}
        let articleToBeShared = favoriteArticles[selectedCellIndexPath.row]
        /// Create and present share sheet
        guard let articleUrl = NSURL(string: articleToBeShared.url ?? "") else {return}
        let objectToShare = [articleUrl]
        let activityViewController = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        activityViewController.popoverPresentationController?.sourceView = view
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
   private func setupEmptyView() {
        favoritesCollectionView.backgroundView = emptyBackgroundView
    }
}
    
    
    
    
    
    
    
    
    


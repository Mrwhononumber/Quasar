//
//  ViewController.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    /// An Array of the feed articles
    private var articles = [Article]()
    /// Number of page which will be increased incrementally to fetch more articles
    private var pageNumber = 1
    /// A flag of the current status, weather more articles  are being fetched or not
    private var isFetchingMoreArticles = false
    /// The collectionView responsible for presenting the articles 
    private let feedcCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 40
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.idintifier)
        collectionView.register(LoadingCollectionViewCell.self, forCellWithReuseIdentifier: LoadingCollectionViewCell.idintifier)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavBar()
        setupFeedCollectionView()
        fetchArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedApperance()
        tabBarController?.tabBar.isHidden = false
        feedcCollectionView.reloadData()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedcCollectionView.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    
    private func configureUI(){
        title = "Quasar Feed"
        view.addSubview(feedcCollectionView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavBar(){
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(didTapSettingsButton))
        settingsButton.tintColor = .systemGray
        navigationItem.rightBarButtonItem = settingsButton
        navigationController?.navigationBar.prefersLargeTitles     = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    /// This method is resposible for excuting the network call:
    /// In the success case:  it returns an array of articles so we assign it to the self.Articles
    /// In the failure case: it returns a csutom error (Quasar Error), so we show a one button alert to the user with the error message
    private func fetchArticles(){
        NetworkManager.shared.fetchArticleData(with: Constants.APIEndPoint+String(pageNumber)) { [weak self] results in
            switch results {
            case .success(let fetchedArticles):
                DispatchQueue.main.async {
                    self?.articles = fetchedArticles
                    self?.feedcCollectionView.reloadData()
                }
            case .failure(let error):
                self?.showOneButtonAlert(title: "Oops!", action: "Ok", message: error.rawValue)
                print(error)
            }
        }
    }
    
    /// This method is responsible for fetching more articles
    private func fetchMoreArticles(){
        
        pageNumber += 11
        isFetchingMoreArticles = true
        feedcCollectionView.reloadSections(IndexSet(integer: 1))
        NetworkManager.shared.fetchArticleData(with: Constants.APIEndPoint+String(pageNumber)) { [weak self] results in
            switch results {
            case .success(let newArticles):
                DispatchQueue.main.async {
                    self?.articles.append(contentsOf: newArticles)
                    self?.isFetchingMoreArticles = false
                    self?.feedcCollectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    /// This method is responsible for pushing the settingsViewController to the navigation stack
    @objc func didTapSettingsButton(){
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

//MARK: - Feed CollectionView

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
     func setupFeedCollectionView(){
        feedcCollectionView.delegate   = self
        feedcCollectionView.dataSource = self
    }
 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let normalCellSize  = CGSize(width: UIScreen.main.bounds.width - 36, height: 400)
        let loadingCellSize = CGSize(width: UIScreen.main.bounds.width - 36, height: 80)
        if indexPath.section == 0 {
            return normalCellSize
        } else {
            return loadingCellSize
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return articles.count
        } else if section == 1 {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = feedcCollectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.idintifier, for: indexPath) as! FeedCollectionViewCell
            cell.AddShadow()
            cell.homeVC = self
            let selectedArticle = articles[indexPath.row]
            cell.configureCell(with: selectedArticle)
            cell.checkIfCurentArticleIsFavouriteWith(article: selectedArticle)
            return cell
        } else {
            let cell = feedcCollectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.idintifier, for: indexPath) as! LoadingCollectionViewCell
            cell.activityIndicatorView.startAnimating()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("did select")
        let selectedArticle = articles[indexPath.row]
        let detailVC = ArticleDetailViewController()
        detailVC.currentArticle = selectedArticle
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// This method is responsible for fetching more articles once the user scrolls until he reaches the end of the collectionView Feed
    /// - Parameter scrollView: The scrollView here is the FeedCollectionView
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// The Y access offset position
        let offsetY = scrollView.contentOffset.y
        /// The total content height
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isFetchingMoreArticles {
                fetchMoreArticles()
            }
        }
    }
    
    //MARK: - Add articles to favorites implementation
    
    /// This  method is responsible for persisting the articles bookmarked by the user, and that happen in two steps:
    /// 1)  Identifing the cell (Article) that got tapped (bookmarked/favorited) by the user
    /// 2)  Persisting or deleting the corresponding article from dat base
    /// - Parameters:
    ///   - cell: This is the sellected cell which had been passed by the collectionView cell
    ///   - toBePersisted: This is is the state the user choose , if true: the article should be persisted, if false: the article showld be deleted
    func handleArticlePersisting(cell: UICollectionViewCell, toBePersisted:Bool){
        /// Here we identifiy which article to be handeled
        let selectedCellIndexPath = feedcCollectionView.indexPath(for: cell)
        let selectedArticle = articles[selectedCellIndexPath!.row]
      
        /// Here we handel the two possible cases the user could choose
        switch toBePersisted {
            
        case true: /// Here we save the article to the local database
            print("persist Article: \(selectedArticle.title)")
            DataPersistenceManager.shared.persistArticleWith(article: selectedArticle) { result in
                switch result {
                case .success(_):
                    print("Article saved successfuly")
                case .failure(let error):
                    self.showOneButtonAlert(title: "Error", action: "Ok", message: error.rawValue)
                }
            }
        case false: /// TODO:  We delete the article from local database
          showOneButtonAlert(title: "", action: "Ok", message:  "Article has been saved already!")
            break
        }
    }
}

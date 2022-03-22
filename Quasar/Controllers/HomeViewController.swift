//
//  ViewController.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private var articles = [Article]()
    private var pageNumber = 1
    private var isFetchingMoreArticles = false
    
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
    
    @objc func didTapSettingsButton(){
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

//MARK: - Feed TableView

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
            let selectedArticle = articles[indexPath.row]
            cell.configureCell(with: selectedArticle)
            return cell
        } else {
            let cell = feedcCollectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionViewCell.idintifier, for: indexPath) as! LoadingCollectionViewCell
            cell.activityIndicatorView.startAnimating()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedArticle = articles[indexPath.row]
        let detailVC = ArticleDetailViewController()
        detailVC.currentArticle = selectedArticle
        navigationController?.pushViewController(detailVC, animated: true)
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isFetchingMoreArticles {
                fetchMoreArticles()
            }
        }
    }
}

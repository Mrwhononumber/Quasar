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
    
    private let feedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.idintifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupFeedTableView()
        fetchArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    
    private func configureUI(){
        title = "Quasar Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(feedTableView)
    }
    
    private func fetchArticles(){
        NetworkManager.shared.fetchArticleData(with: Constants.APIEndPoint+String(pageNumber)) { results in
            switch results {
            case .success(let fetchedArticles):
                self.articles = fetchedArticles
                DispatchQueue.main.async {
                    self.feedTableView.reloadData()
                }
            case .failure(let error):
                self.showOneButtonAlert(title: "Sorry", action: "Ok", message: error.rawValue)
                print(error)
            }
        }
    }
    
    private func fetchMoreArticles(){
        
        pageNumber += 11
        isFetchingMoreArticles = true
        NetworkManager.shared.fetchArticleData(with: Constants.APIEndPoint+String(pageNumber)) { results in
            switch results {
            case .success(let newArticles):
                self.articles.append(contentsOf: newArticles)
                self.isFetchingMoreArticles = false
                DispatchQueue.main.async {
                    self.feedTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
                return
            }
        }
    }
}

//MARK: - Feed TableView

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupFeedTableView(){
        
        feedTableView.delegate = self
        feedTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = feedTableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.idintifier, for: indexPath) as! FeedTableViewCell
        let selectedArticle = articles[indexPath.section]
        cell.configureCell(with: selectedArticle)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let selectedArticle = self.articles[indexPath.section]
            let detailVC = ArticleDetailViewController()
            detailVC.configure(with: selectedArticle.url)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height  {
            if !isFetchingMoreArticles {
                fetchMoreArticles()
            }
        }
    }
}


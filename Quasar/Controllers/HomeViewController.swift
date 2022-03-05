//
//  ViewController.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    var articles = [Article]()
    
    let feedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.idintifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
//MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureFeedTableView()
        fetchArticles()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        feedTableView.frame = view.bounds
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        title = "Your Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(feedTableView)
    }
    
    func fetchArticles(){
        NetworkManager.shared.fetchArticleData(with: Constants.APIEndPoint) { results in
            switch results {
            case .success(let fetchedArticles):
                self.articles = fetchedArticles
                DispatchQueue.main.async {
                    self.feedTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Feed TableView

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func configureFeedTableView(){
        
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
    
    
    
    
    
}


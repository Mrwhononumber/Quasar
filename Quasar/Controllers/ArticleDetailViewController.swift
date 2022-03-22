//
//  ArticleDetailViewController.swift
//  Quasar
//
//  Created by Basem El kady on 3/6/22.
//

import UIKit
import WebKit

class ArticleDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    /// This is the Article the user selected and had been passed from the HomeViewController
    var currentArticle: Article?
    
    
    /// This is the web view we gonna use to view the article
    private let webView: WKWebView = {
        let view = WKWebView()
       return view
    }()
    
    /// The activity indicator that users will see while the article is being fetched
    private let activityIndicatorView: UIActivityIndicatorView = {
        let myView = UIActivityIndicatorView()
        myView.hidesWhenStopped = true
        myView.style = .medium
        myView.color = .systemGray
        myView.startAnimating()
        return myView
    }()

    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureArticleDetailVC()
        configureWKNavigationDelegate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        activityIndicatorView.center = view.center
    }
    
    //MARK: - Helper Funcions
    
    private func configureUI(){
        title = "Quasar"
        navigationController?.navigationBar.prefersLargeTitles = false
        view.addSubview(webView)
        view.addSubview(activityIndicatorView)
    }
    
    /// Configure the webview using the currentArticle url
    func configureArticleDetailVC(){
        guard let articleURL = URL(string: currentArticle!.url) else {return}
        webView.load(URLRequest(url: articleURL))
    }
}

//MARK: - WebKit Navigation Delegate

extension ArticleDetailViewController: WKNavigationDelegate {
    
    
    /// Set the the ArticleDetailVC as the web view navigation delegate
    func configureWKNavigationDelegate(){
        webView.navigationDelegate = self
    }
    
   /// Hide the navigation indicator once the webview (the article) finishes loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
}

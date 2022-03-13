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
    
    private let webView: WKWebView = {
        let view = WKWebView()
       return view
    }()
    
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
        configureWKNavigationDelegate()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
        activityIndicatorView.center = view.center
    }
    
    //MARK: - Helper Funcions
    
    private func configureUI(){
        view.addSubview(webView)
        view.addSubview(activityIndicatorView)
    }
    
    func configureArticleDetailVC(with url:String){
        guard let articleURL = URL(string: url) else {return}
        webView.load(URLRequest(url: articleURL))
    }
}

//MARK: - WebKit Navigation Delegate

extension ArticleDetailViewController: WKNavigationDelegate {
    
    func configureWKNavigationDelegate(){
        webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
}

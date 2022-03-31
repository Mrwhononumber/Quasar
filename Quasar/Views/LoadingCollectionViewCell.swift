//
//  LoadingTableViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 3/6/22.
//

import UIKit

/// This cell should be used while we're fetching more articles to indicate to the user that more articles are being loaded
class LoadingCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    /// Cell idintifier
    static let idintifier = "LoadingCollectionViewCell"

     let activityIndicatorView: UIActivityIndicatorView = {
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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activityIndicatorView.center = contentView.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func configureUI(){
        contentView.addSubview(activityIndicatorView)
    }
}

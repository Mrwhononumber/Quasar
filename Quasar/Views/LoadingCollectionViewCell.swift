//
//  LoadingTableViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 3/6/22.
//

import UIKit

class LoadingCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
      
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
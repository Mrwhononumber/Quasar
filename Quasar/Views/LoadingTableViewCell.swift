//
//  LoadingTableViewCell.swift
//  Quasar
//
//  Created by Basem El kady on 3/6/22.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    
    //MARK: - Properties
      
    static let idintifier = "LoadingTableViewCell"

    private let activityIndicatorView: UIActivityIndicatorView = {
        let myView = UIActivityIndicatorView()
        myView.hidesWhenStopped = true
        myView.style = .medium
        myView.color = .gray
        myView.startAnimating()
        return myView
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

//
//  EmptyBackgroundView.swift
//  Quasar
//
//  Created by Basem El kady on 4/9/22.
//

import Foundation
import UIKit

class EmptyBackgroundView: UIView {
    
    //MARK: - Properties
    
    private let topLabel: UILabel = {
      
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Add your favorite articles here!"
        label.textColor = .systemPink
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topLabel)
        topLabel.center = self.center
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Methods
    private func configureConstraints() {
        
        let topLabelConstraints = [
        
            topLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(topLabelConstraints)
    }
}

//
//  SettingsViewController.swift
//  Quasar
//
//  Created by Basem El kady on 3/13/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let items = ["Adaptive","Light","Dark"]
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureConstraints()
    }
    
    
    //MARK: - Helper Functions
    
    private func setupUI(){
        view.addSubview(segmentedControl)
        view.backgroundColor = .systemBackground
    }
    
    private func configureConstraints(){
        
        let segmentedControlConstraints = [
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            segmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        NSLayoutConstraint.activate(segmentedControlConstraints)
    }
}

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
    
    private lazy var apperanceSegmentedControl: UISegmentedControl = {
        let defaults = UserDefaults.standard
        let savedSelection = defaults.integer(forKey: Constants.apperanceUserDefaultsKey)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = savedSelection
        control.translatesAutoresizingMaskIntoConstraints = false
        control.addTarget(self, action: #selector(didTapSegmentedControl(_:)), for: .valueChanged)
        return control
    }()
    
    private let apperanceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apperance"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.tintColor = .systemGray
        return label
    }()
    
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSavedApperance()
    }
        
    //MARK: - Helper Functions
    
    private func configureUI(){
        view.addSubview(apperanceLabel)
        view.addSubview(apperanceSegmentedControl)
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapSegmentedControl(_ sender:UISegmentedControl) {
        
        let defaults = UserDefaults.standard
       
        switch sender.selectedSegmentIndex {
            
        case 0 :
            overrideUserInterfaceStyle = .unspecified
            defaults.set(sender.selectedSegmentIndex, forKey: Constants.apperanceUserDefaultsKey)
            switch traitCollection.userInterfaceStyle {
                
            case .unspecified:
                break
            case .light:
                navigationController?.navigationBar.barStyle = .default
                navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            case .dark:
                navigationController?.navigationBar.barStyle = .black
                navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            @unknown default:
                break
            }
          
        case 1 :
            overrideUserInterfaceStyle = .light
            defaults.set(sender.selectedSegmentIndex, forKey: Constants.apperanceUserDefaultsKey)
            navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]

        case 2 :
            overrideUserInterfaceStyle = .dark
            defaults.set(sender.selectedSegmentIndex, forKey: Constants.apperanceUserDefaultsKey)
            navigationController?.navigationBar.barStyle = .black
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]

        default:
            print ("Error Happened while selecting apperance")
        }
    }
    
    private func configureConstraints(){
        
        let apperanceLabelConstraints = [
            apperanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            apperanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            apperanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            apperanceLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let segmentedControlConstraints = [
            apperanceSegmentedControl.topAnchor.constraint(equalTo: apperanceLabel.bottomAnchor, constant: 15),
            apperanceSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            apperanceSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            apperanceSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ]

        NSLayoutConstraint.activate(apperanceLabelConstraints)
        NSLayoutConstraint.activate(segmentedControlConstraints)
    }
}

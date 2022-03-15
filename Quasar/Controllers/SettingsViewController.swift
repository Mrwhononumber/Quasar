//
//  SettingsViewController.swift
//  Quasar
//
//  Created by Basem El kady on 3/13/22.
//

import UIKit

class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    
    private let apperanceLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Theme"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
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
    
    private let settingsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.layer.cornerRadius = 10
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell2")
        table.translatesAutoresizingMaskIntoConstraints = false
       return table
    }()
        
    //MARK: - VC LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureConstraints()
        configureSettingsTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSavedApperance()
    }
        
    //MARK: - Helper Functions
    
    private func configureUI(){
        view.addSubview(apperanceLabel)
        view.addSubview(apperanceSegmentedControl)
        view.addSubview(settingsTable)
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
            apperanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 46),
            apperanceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            apperanceLabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let segmentedControlConstraints = [
            apperanceSegmentedControl.topAnchor.constraint(equalTo: apperanceLabel.bottomAnchor, constant: 5),
            apperanceSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 22),
            apperanceSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            apperanceSegmentedControl.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let settingsTableConstraints = [
            settingsTable.topAnchor.constraint(equalTo: apperanceSegmentedControl.bottomAnchor, constant: 20),
            settingsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            settingsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            settingsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ]

        NSLayoutConstraint.activate(apperanceLabelConstraints)
        NSLayoutConstraint.activate(segmentedControlConstraints)
        NSLayoutConstraint.activate(settingsTableConstraints)
    }
    
    @objc private func didTapAdsSwitch(){
        print("Ads switch got tapped")
    }
    
    @objc private func didTapNotificationsSwitch(){
        print("Notifications switch got tapped")
    }
}
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    private func configureSettingsTable(){
        settingsTable.dataSource      = self
        settingsTable.delegate        = self
        settingsTable.isScrollEnabled = false
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 3
            
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
            
        case 0:
            let cell = settingsTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let mySwitch = UISwitch(frame: .zero)
            mySwitch.setOn(true, animated: true)
            mySwitch.onTintColor = .systemPink
          
            if indexPath.row == 0 {
                cell.textLabel?.text = "Enable Ads"
                cell.accessoryView = mySwitch
                mySwitch.addTarget(self, action: #selector(didTapAdsSwitch), for: .valueChanged)
            } else {
                cell.textLabel?.text = "Enable Notifications"
                cell.accessoryView = mySwitch
                mySwitch.addTarget(self, action: #selector(didTapNotificationsSwitch), for: .valueChanged)
            }
          
            
            return cell
        case 1:
            var cell = settingsTable.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            let  largeConfig = UIImage.SymbolConfiguration(scale: .large)
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell2")
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Leave a rating"
                cell.detailTextLabel?.text = "Help the developer buy a PSVR2"
                cell.imageView?.image = UIImage(systemName: "hand.thumbsup", withConfiguration: largeConfig)
                cell.imageView?.tintColor = .systemPink
            case 1:
                cell.textLabel?.text = "Share the app"
                cell.detailTextLabel?.text = "Have a space geek friend? send it their way!"
                cell.imageView?.image = UIImage(systemName: "paperplane", withConfiguration: largeConfig)
                cell.imageView?.tintColor = .systemPink
            case 2:
                cell.textLabel?.text = "Send feedback"
                cell.detailTextLabel?.text = "Any thoughts, bugs, or questions?"
                cell.imageView?.image = UIImage(systemName: "envelope", withConfiguration: largeConfig)
                cell.imageView?.tintColor = .systemPink
                
            default:
                break
            }

            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return 50
        case 1:
            return 60
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Customizations"
        case 1:
            return "Feedback"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsTable.deselectRow(at: indexPath, animated: true)
    }
}

//
//  Extensions.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import Foundation
import UIKit


extension UIViewController {
    
    func showOneButtonAlert(title: String, action: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: action, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true)
    }
  /// Load the apperance preference choosen by the user from the user defaults
    func loadSavedApperance() {
        
        let defaults       = UserDefaults.standard
        let savedSelection = defaults.integer(forKey: Constants.apperanceUserDefaultsKey)
       
        switch savedSelection {
       
        case 0:
            overrideUserInterfaceStyle = .unspecified
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

        case 1:
            overrideUserInterfaceStyle = .light
            navigationController?.navigationBar.barStyle = .default
        case 2:
            overrideUserInterfaceStyle = .dark
            navigationController?.navigationBar.barStyle = .black
        default:
            print ("Error Happened while loading saved apperance")
        }
    }
}

extension UICollectionViewCell {
    func AddShadow() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius  = radius
        contentView.layer.borderWidth   = 2
        contentView.layer.borderColor   = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
    
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: 0, height: 2.0)
        layer.shadowRadius  = 6.0
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
        layer.shadowPath    = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius  = radius
    }
}



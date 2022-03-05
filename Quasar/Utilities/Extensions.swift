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
}



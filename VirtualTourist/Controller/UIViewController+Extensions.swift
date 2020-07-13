//
//  UIViewController+Extensions.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/5/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {

    func getManagedContext() -> NSManagedObjectContext? {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return nil
        }
        
        return appDelegate.persistentContainer.viewContext
    }
    
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

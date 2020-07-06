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
}

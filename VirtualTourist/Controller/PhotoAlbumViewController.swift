//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/6/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    
    var pin: Pin!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

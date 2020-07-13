//
//  PhotoUrl.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/12/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

struct PhotoUrl: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_m"
    }
}




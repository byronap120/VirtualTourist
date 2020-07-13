//
//  Photos.swift
//  VirtualTourist
//
//  Created by Byron Ajin on 7/12/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let page: Int
    let pages: Int
    let photo: [PhotoUrl]
}

//
//  Hardware.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 02/10/22.
//

import Foundation

struct Hardware: Codable {
    let id: Int
    var name: String
    var description: String
    var location: String
    var type: String
    var is_active: Bool
    
    init(id: Int, name: String, description: String, location: String, type: String, is_active: Bool) {
        self.id = id
        self.name = name
        self.description = description
        self.location = location
        self.type = type
        self.is_active = is_active
    }
}

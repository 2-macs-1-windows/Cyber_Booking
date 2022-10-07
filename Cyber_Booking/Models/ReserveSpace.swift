//
//  ReserveSpace.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

import Foundation
import UIKit
// Estructura de información de ReservaSpace
struct ReserveSpace:Codable {
    var id: Int
    var user_id: Int
    var service_id: String
    var created_at: String
    var booking_start: String
    var booking_end: String
    var active: Int
    
    init(service_id:String, booking_start: String, booking_end:String){
        self.id = 1234
        self.user_id = appDelegate.user_id // CAMBIAR
        self.service_id = service_id
        self.created_at = "hoy"
        self.booking_start = booking_start
        self.booking_end = booking_end
        self.active = 1
    }
}

typealias ReservasSpaces = [ReserveSpace]


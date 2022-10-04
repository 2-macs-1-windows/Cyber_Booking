//
//  Usuario.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 27/09/22.
//

import Foundation

// Estructura de información del Usuario
struct User: Decodable {
    var id:Int
    var name: String
    var last_name: String
    var email: String
    var phone: Int
    var password: String
    var verified_email: Bool
    var is_Tec: Bool
    var date_created: String
    var is_active: Bool
}

// Funciones de la clase User

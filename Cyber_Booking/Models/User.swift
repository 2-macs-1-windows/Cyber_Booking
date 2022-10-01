//
//  Usuario.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 27/09/22.
//

import Foundation

// Estructura de información del Usuario
struct User {
    var name: String
    var last_name: String
    var email: String
    var phone: Int
    var is_admin: Bool
    var is_superadmin: Bool
    var password: String
    var verified_email: Bool
    var is_Tec: Bool
    var date_created: String
    var is_active: Bool
}

// Funciones de la clase User

extension User {
    // función que regresa un arreglo de User
    static func listaUsers()->User {
        return
            // Datos dummie FALTA BD
            User(name: "Zachary",
                 last_name: "Joyce",
                 email: "sed@google.net",
                 phone: 12886560226,
                 is_admin: false,
                 is_superadmin: false,
                 password: "montes",
                 verified_email: true,
                 is_Tec: true,
                 date_created: "Oct 25, 2022",
                 is_active: true)
        
    }
}

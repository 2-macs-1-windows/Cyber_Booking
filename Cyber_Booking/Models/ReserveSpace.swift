//
//  ReserveSpace.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

import Foundation

// Estructura de información de ReservaSpace

struct ReserveSpace {
    var id: Int
    var userId: Int
    var nameService: String
    var created_at: String
    var booking_start: String
    var booking_end: String
    var active: Bool
}

// Funciones de la clase User

extension ReserveSpace {
    static func listaReserveSpace()->[ReserveSpace] {
        return
            // Datos dummie FALTA BD
            [ReserveSpace(id: 1, userId: 1, nameService: "Laboratorio de IoT", created_at: "Oct 25, 2022", booking_start: "Oct 27, 2022", booking_end: "Oct 29, 2022", active: true),
             ReserveSpace(id: 2, userId: 1, nameService: "Sala de juntas", created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: false),
                ]
    }
}

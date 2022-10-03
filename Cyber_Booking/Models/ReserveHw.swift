//
//  ReserveHw.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

import Foundation

// Estructura de información de ReservaHardware

struct ReserveHw:Codable {
    var id: Int
    var userId: Int
    var serviceId: String
    var created_at: String
    var booking_start: String
    var booking_end: String
    var active: Int
}

// Funciones de la clase User
typealias ReservasHw = [ReserveHw]

/*
extension ReserveHw {
    static func listaReserveHw()->[ReserveHw] {
        return
            // Datos dummie FALTA BD
            [ReserveHw(id: 1, userId: 1, serviceId: "Mac mini", created_at: "Oct 25, 2022", booking_start: "Oct 27, 2022", booking_end: "Oct 29, 2022", active: true),
             ReserveHw(id: 2, userId: 1, serviceId: "iPod 6", created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: true),
                ]
    }
} */

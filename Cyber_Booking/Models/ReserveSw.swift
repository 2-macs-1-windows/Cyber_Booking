//
//  ReserveSw.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

import Foundation

// Estructura de información de ReservaSpace

struct ReserveSw {
    var id: Int
    //var icono: String
    var userId: Int
    var serviceId: Int
    var created_at: String
    var booking_start: String
    var booking_end: String
    var active: Bool
}

// Funciones de la clase User

extension ReserveSw {
    static func listaReserveSw()->[ReserveSw] {
        return
            // Datos dummie FALTA BD
    [ReserveSw(id: 1, userId: 1, serviceId: 1, created_at: "Oct 25, 2022", booking_start: "Oct 27, 2022", booking_end: "Oct 29, 2022", active: true),
         ReserveSw(id: 2, userId: 1, serviceId: 2, created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: true),
                ]
    }
}


//
//  ReserveSw.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 29/09/22.
//

import Foundation

// Estructura de información de ReservaSpace

struct ReserveSw:Codable {
    var id: Int
    var userId: Int
    var serviceId: String
    var created_at: String
    var booking_start: String
    var booking_end: String
    var active: Int //Bool ps no sé como decirle al Json decoder que el int lo haga bool
}

// Funciones de la clase User
typealias ReservasSw = [ReserveSw]
/*
extension ReserveSw {
    static func listaReserveSw()->[ReserveSw] {
        return
            // Datos dummie FALTA BD
            [ReserveSw(id: 1, userId: 1, serviceId: "Matlab", created_at: "Oct 25, 2022", booking_start: "Oct 27, 2022", booking_end: "Oct 29, 2022", active: false),
             ReserveSw(id: 2, userId: 1, serviceId: "Packet Tracer", created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: true),
             ReserveSw(id: 3, userId: 1, serviceId: "Visual Studio", created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: false),
             ReserveSw(id: 4, userId: 1, serviceId: "Office 360", created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: true),
             ReserveSw(id: 5, userId: 1, serviceId: "Azure", created_at: "Oct 30, 2022", booking_start: "Oct 30, 2022", booking_end: "Nov 2, 2022", active: true),
                ]
    }
}*/



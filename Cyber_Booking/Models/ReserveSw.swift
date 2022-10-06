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
    
    init(serviceId:String, booking_start: String, booking_end:String){
            self.id = 1234
            self.userId = 1 // CAMBIAR
            self.serviceId = serviceId
            self.created_at = "hoy"
            self.booking_start = booking_start
            self.booking_end = booking_end
            self.active = 1
        }
}

// Funciones de la clase User
typealias ReservasSw = [ReserveSw]




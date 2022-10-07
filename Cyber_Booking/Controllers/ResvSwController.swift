//
//  ResvSwController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 2/10/22.
//

import Foundation
import UIKit

enum ReservaError:Error, LocalizedError{
    case itemNotFound
    case decodeError
}

class ReservaSwController{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Obtener todas las reservas
    func fetchReservas() async throws->ReservasSw{
        let urlString = "http://127.0.0.1:8000/resvSw?user_id=\(await appDelegate.user_id)"
        
        let baseURL = URL(string: urlString)!
        
        let (data, response) = try await URLSession.shared.data(from: baseURL)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
        
            throw ReservaError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        do{
        
            let reservas = try jsonDecoder.decode(ReservasSw.self, from: data)
            
            return reservas
        }catch let jsonError as NSError{
            print("JSON decode failed: \(jsonError)")
            throw ReservaError.decodeError
        }
        
    }
    
    // Insertar nueva reserva
    func insertReserva(nuevareserva:ReserveSw)async throws->Void{
        let baseString = "http://127.0.0.1:8000/api/reserveSw/"
        
        let insertURL = URL(string: baseString)!
        var request = URLRequest(url: insertURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(nuevareserva)
        
        print(nuevareserva)
        request.httpBody = jsonData
        // Imprimir el cuerpo del JSON
        let s = String(data: jsonData!, encoding: .utf8)!
        print(s)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else { throw ReservaError.itemNotFound}
    }
    
    // Eliminar reserva
    func deleteReserva(registroID:Int) async throws -> Void{
        let baseString = "http://127.0.0.1:8000/delteHistResvSw/"
        
        let deleteString = baseString + String(registroID) + "/"
        let deleteURL = URL(string: deleteString)!
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ReservaError.itemNotFound}
    }
    

}

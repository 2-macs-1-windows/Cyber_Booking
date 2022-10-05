//
//  ResvHwController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 3/10/22.
//

import Foundation

class ReservaHwController{
    let baseURL = URL(string: "http://127.0.0.1:8000/resvHw")!
    
    func fetchReservas() async throws->ReservasHw{
        let (data, response) = try await URLSession.shared.data(from: baseURL)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
        
            throw ReservaError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        do{
        
            let reservas = try jsonDecoder.decode(ReservasHw.self, from: data)
            
            return reservas
        }catch let jsonError as NSError{
            print("JSON decode failed: \(jsonError)")
            throw ReservaError.decodeError
        }
        
    }
    
    func deleteReserva(registroID:Int) async throws -> Void{
        let baseString = "http://127.0.0.1:8000/delteHistResvHw/"
        
        let deleteString = baseString + String(registroID) + "/"
        let deleteURL = URL(string: deleteString)!
        var request = URLRequest(url: deleteURL)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw ReservaError.itemNotFound}
    }
    

}

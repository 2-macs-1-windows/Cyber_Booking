//
//  ResvSwController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 2/10/22.
//

import Foundation

enum ReservaError:Error, LocalizedError{
    case itemNotFound
    case decodeError
}

class ReservaSwController{
    let baseURL = URL(string: "http://127.0.0.1:8000/resvSw")!
    
    func fetchReservas() async throws->ReservasSw{
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

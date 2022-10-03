//
//  ReservaSpacesController.swift
//  Cyber_Booking
//
//  Created by Victoria Estefania Vazquez Morales on 3/10/22.
//

import Foundation

class ReservaSpacesController{
    let baseURL = URL(string: "http://127.0.0.1:8000/resvSp")!
    
    func fetchReservas() async throws->ReservasSpaces{
        let (data, response) = try await URLSession.shared.data(from: baseURL)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
        
            throw ReservaError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        do{
        
            let reservas = try jsonDecoder.decode(ReservasSpaces.self, from: data)
            
            return reservas
        }catch let jsonError as NSError{
            print("JSON decode failed: \(jsonError)")
            throw ReservaError.decodeError
        }
        
        
        
    }
    

}

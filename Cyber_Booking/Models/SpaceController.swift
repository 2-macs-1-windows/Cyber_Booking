//
//  SpaceController.swift
//  Cyber_Booking
//
//  Created by Sofía Hernandez on 02/10/22.
//

import Foundation

enum SpaceError: Error, LocalizedError {
    case itemNotFound
}

class SpaceController {
    let baseString = "http://127.0.0.1:8000/api/spaces/"
    
    func fetchSpaces() async throws->Spaces{
        let spacesURL = URL(string: baseString + "?format=json")!
        let (data, response) = try await URLSession.shared.data(from: spacesURL)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw SpaceError.itemNotFound
        }
        let jsonDecoder = JSONDecoder()
        let reservas = try? jsonDecoder.decode(Spaces.self, from: data)
        return reservas!
    }
}

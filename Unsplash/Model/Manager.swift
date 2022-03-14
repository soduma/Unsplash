//
//  Manager.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/14.
//

import Foundation
import Alamofire

class Manager {
    func fetchWithAsync(_ keyword: String) async -> [Results] {
        guard let url = URL(string: "https://api.unsplash.com/search/photos/?client_id=oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0&query=\(keyword)") else { return [] }
        
        do {
            let data = try await AF.request(url, method: .get).serializingDecodable(UnsplashAPI.self).value
            return data.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}

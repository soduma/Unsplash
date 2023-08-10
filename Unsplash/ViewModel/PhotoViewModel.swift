//
//  PhotoViewModel.swift
//  Unsplash
//
//  Created by 장기화 on 2023/08/09.
//

import Foundation
import Alamofire

enum PhotoSize {
    case raw
    case regular
    case small
}

class PhotoViewModel {
    var currentPage = 1
    var isFetching = true
    
    func getPhoto(keyword: String) async -> [Results] {
        let result = await NetworkManager().fetchUnsplash(keyword: keyword, page: currentPage)
        
        switch result {
        case .success(let data):
            isFetching = false
            return data.results
            
        case .failure(let error):
            print(error.localizedDescription)
            return []
        }
    }
}

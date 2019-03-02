//
//  Decodables.swift
//  RR18_BlueToothProj
//
//  Created by Yeo Hwee Lin on 3/2/19.
//  Copyright © 2019 Yeo Hwee Lin. All rights reserved.
//

import Foundation

struct getRunIDAPIResponse {
    let runID: Int
}

extension getRunIDAPIResponse: Decodable {
    
    private enum getRunIDAPIResponseCodingKeys: String, CodingKey {
        case runID = "run_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: getRunIDAPIResponseCodingKeys.self)
        
        runID = try container.decode(Int.self, forKey: .runID)
        
    }
}


struct Movie {
    let id: Int
    let posterPath: String
    let backdrop: String
    let title: String
    let releaseDate: String
    let rating: Double
    let overview: String
}
//
//extension Movie: Decodable {
//    
//    enum MovieCodingKeys: String, CodingKey {
//        case id
//        case posterPath = "poster_path"
//        case backdrop = "backdrop_path"
//        case title
//        case releaseDate = "release_date"
//        case rating = "vote_average"
//        case overview
//    }
//    
//    
//    init(from decoder: Decoder) throws {
//        let movieContainer = try decoder.container(keyedBy: MovieCodingKeys.self)
//        
//        id = try movieContainer.decode(Int.self, forKey: .id)
//        posterPath = try movieContainer.decode(String.self, forKey: .posterPath)
//        backdrop = try movieContainer.decode(String.self, forKey: .backdrop)
//        title = try movieContainer.decode(String.self, forKey: .title)
//        releaseDate = try movieContainer.decode(String.self, forKey: .releaseDate)
//        rating = try movieContainer.decode(Double.self, forKey: .rating)
//        overview = try movieContainer.decode(String.self, forKey: .overview)
//    }
//}

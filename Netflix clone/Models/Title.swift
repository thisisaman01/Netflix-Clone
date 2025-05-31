//
//  Movie.swift
//  Netflix clone
//
//  Created by AMAN K.A on 10/09/23.
//

//import Foundation
//
//
//struct TrendingTitleResponse: Codable {
//    let results: [Title]
//}
//
//struct Title: Codable {
//    let id: Int
//    let media_type: String?
//    let original_name: String?
//    let original_title: String?
//    let title: String?
//    let name: String?
//    let poster_path: String?
//    let overview: String?
//    let vote_count: Int
//    let release_date: String?
//    let first_air_date: String?
//    let vote_average: Double
//    
//    // Computed property for easy title access
//    var displayTitle: String {
//        return original_title ??
//               original_name ??
//               title ??
//               name ??
//               "Unknown Title"
//    }
//}
//
//



//
//  Movie.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 08/12/2021.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}


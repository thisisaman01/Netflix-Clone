//
//  YoutubeSearchResponse.swift
//  Netflix clone
//
//  Created by AMAN K.A on 17/09/23.
//

import Foundation



struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}


struct VideoElement: Codable {
    let id: IdVideoElement
}


struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}

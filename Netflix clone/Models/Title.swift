//
//  Movie.swift
//  Netflix clone
//
//  Created by AMAN K.A on 10/09/23.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}


struct Title: Codable {
    let id: Int
    let media_type: String?
    let orignal_name: String?
    let orignal_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
    
    
}


/*
 
 {
adult = 0;
"backdrop_path" = "/4le1Gguoz9ueuWDzECdCf2rabq9.jpg";
"genre_ids" =             (
 10749,
 35,
 18
);
id = 936952;
"media_type" = movie;
"original_language" = en;
"original_title" = "Sitting in Bars with Cake";
overview = "Extrovert Corinne convinces Jane, a shy, talented baker, to commit to a year of bringing cakes to bars, to help her meet people and build confidence. But when Corinne receives a life-altering diagnosis, the pair faces a challenge unlike anything they've experienced before.";
popularity = "70.88500000000001";
"poster_path" = "/kGENInUWI9tRVg4ae8XAVgAWpEi.jpg";
"release_date" = "2023-09-07";
title = "Sitting in Bars with Cake";
video = 0;
"vote_average" = "6.9";
"vote_count" = 11;
 
 */



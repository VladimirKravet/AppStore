//
//  SearchResult.swift
//  AppStore
//
//  Created by Vladimir Kravets on 01.12.2022.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackId: Int
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
    var screenshotUrls: [String]? // images
    let artworkUrl100: String //map icon
    var formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    var artistName: String?
    var collectionName: String?
}

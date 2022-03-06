//
//  MovieSecondData.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 11.02.22.
//

import Foundation

struct MovieSecondData: Codable, Equatable {
    let title, released: String
    let runtime, genre, director, writer: String
    let actors: String
    let awards: String
    let poster: String
    let imdbRating: String
    let boxOffice: String
    let plot: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating
        case boxOffice = "BoxOffice"
        case plot = "Plot"
    }


}

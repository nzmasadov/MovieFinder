//
//  MovieManager.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 10.02.22.
//

import UIKit

protocol MovieManagerDelegate {
    func  didUpdateMovie(_ movieManager:MovieManager, movieData: Movie)
    func didFailWithError (error: Error)
}
protocol MovieSecondDelegate {
    func didSecondUpdate (_ movieManager: MovieManager, movieSecond:MovieSecondData)
}

struct MovieManager {
    
    var delegate: MovieManagerDelegate?
    var delegateSecond: MovieSecondDelegate?
    
    let movieUrl = "https://www.omdbapi.com/?&apikey=95e7e8fc&s="
  //  let movieSecondUrl = "http://www.omdbapi.com/?i=&apikey=95e7e8fc"
        
  
        
    func performSecondRequest(_ id: String) {
        let url = "http://www.omdbapi.com/?i=\(id)&apikey=95e7e8fc"
        guard let urlStringFormat = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: urlStringFormat) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlString) { data, response, error in
            if error != nil {
                delegate?.didFailWithError(error: error!)
            }else{
                if let safeData = data {
                    guard let movieSecondData = parseSecondJSON(safeData) else {return}
                    delegateSecond?.didSecondUpdate(self, movieSecond: movieSecondData)
                    print(movieSecondData.director)
                }
            }
        }
        task.resume()
    }
    
    
    func parseSecondJSON(_ data: Data) -> MovieSecondData? {
        let decoder = JSONDecoder()
        do{
        let decoderdata = try decoder.decode(MovieSecondData.self, from: data)
            print(decoderdata.awards)
            return decoderdata
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        }
    
    
    func performRequest(_ searchName:String) {
        
        let replaced = searchName.replacingOccurrences(of: " ", with: "+")
        let url = movieUrl + replaced
        guard let urlString = URL(string: url) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlString) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }else{
                if data != nil {
                    guard let safeData = data else {return}
                    guard let movie = parseJson(with: safeData) else {return}
                    delegate?.didUpdateMovie(self, movieData: movie)
                    
                }
            }
        }
        task.resume()
    }
    
    func parseJson (with data: Data) -> Movie? {
        let decoder = JSONDecoder()
        do{
            let decoderdata = try decoder.decode(Movie.self, from: data)
            print("success \(decoderdata.search[0].year)")
            return decoderdata
           
        }catch{
            print("success not errorData")
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

//
//  Singleton.swift
//  MovieFinder
//
//  Created by Nazim Asadov on 26.02.22.
//

import Foundation
import UIKit

struct Helper {
    static var shared = Helper()
    
    var movieIdArray: [String]? = []    
    var movieTitleArray: [String]? = []
    var moviePosterArray: [String]? = []
    
    private init() {}
}


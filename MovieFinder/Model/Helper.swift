//
//  Singleton.swift
//  MovieFinder
//
//  Created by Nazim Asadov on 26.02.22.
//

import Foundation
import UIKit

struct Helper {
    static var sharedInstance = Helper()
    
    var movieIdArray: [String] = []
    var savedDataArray: [MovieSecondData] = []
    
    private init() {}
}

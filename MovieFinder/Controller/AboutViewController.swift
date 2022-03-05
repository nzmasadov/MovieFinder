//
//  AboutViewController.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 09.02.22.
//

import UIKit
import CoreData

class AboutViewController: UIViewController, MovieSecondDelegate{
    
    // var fromHomeVC: Bool? = true
    
    var idApi: String?
    
    var index: Int?
    
//    var helper = Helper.sharedInstance
    @IBOutlet weak var savedButtonOutlet:UIBarButtonItem!
    
    var movieManagerStruct = MovieManager()
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var producerlabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imdbRatingLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var runningTimeLbl: UILabel!
    @IBOutlet weak var boxofficeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var aboutLbl: UILabel!
    @IBOutlet weak var starringLbl: UILabel!
    @IBOutlet weak var writersLbl: UILabel!
    @IBOutlet weak var awardsLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        movieManagerStruct.delegateSecond = self
        movieManagerStruct.performRequest(idApi!)
        movieManagerStruct.performSecondRequest(idApi ?? "")
    }
    
    func didSecondUpdate(_ movieManager: MovieManager, movieSecond: MovieSecondData) {
        DispatchQueue.main.async {
            
            // about vc screen items. it is coming from second api data. 
            self.movieName.text = movieSecond.title
            self.producerlabel.text = movieSecond.director
            self.posterImageView.sd_setImage(with: URL(string: movieSecond.poster))
            self.imdbRatingLbl.text = movieSecond.imdbRating
            self.releaseDateLbl.text = movieSecond.released
            self.genreLbl.text = movieSecond.genre
            self.runningTimeLbl.text = movieSecond.runtime
            self.boxofficeLbl.text = movieSecond.boxOffice
            self.aboutLbl.text = movieSecond.plot
            self.starringLbl.text = "Starring:  \(movieSecond.actors)"
            self.writersLbl.text = "Writers: \(movieSecond.writer)"
            self.awardsLbl.text = "Awards: \(movieSecond.awards)"
        }
    }
    
    @IBAction func savedPageClicked(_ sender: UIButton) {
        guard let idApi = idApi else { return }
        
        // check save. if there is not movie with spesific id save move and if there is id in the array, delete the movie
        if Helper.sharedInstance.movieIdArray.contains(idApi) {
            guard let index = Helper.sharedInstance.movieIdArray.firstIndex(of: idApi) else {return}
            Helper.sharedInstance.movieIdArray.remove(at: index)
            savedButtonOutlet.image = UIImage(named: K.savedImgEmpty)
            
        }else {
            Helper.sharedInstance.movieIdArray.append(idApi)
            print(Helper.sharedInstance.movieIdArray)
            savedButtonOutlet.image = UIImage(named: K.savedImgFilled)
        }
    }
}

//
//  AboutViewController.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 09.02.22.
//

import UIKit
import CoreData

class AboutVC: UIViewController, MovieDetailedDelegate{
    
    // var fromHomeVC: Bool? = true
    
    var idApi: String?
    var posterApi: String?
    var titleApi: String?
    
    
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
                
        movieManagerStruct.delegateDetailed = self
        movieManagerStruct.performRequest(idApi!)
        movieManagerStruct.performDetailedRequest(idApi ?? "")
        
        // we just could write code here without Notification center, it also would work.
        NotificationCenter.default.addObserver(self, selector: #selector(checking), name: NSNotification.Name("passData"), object: nil)
    }
    
    
    @objc func checking() {
        if Helper.sharedInstance.movieIdArray?.contains(idApi ?? "") ?? false {
            savedButtonOutlet.image = UIImage(named: K.savedImgFilled)
        }else {
            savedButtonOutlet.image = UIImage(named: K.savedImgEmpty)
        }
    }
    
    func didDetailedUpdate(_ movieManager: MovieManager, movieSecond: MovieDetailedData) {
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
        guard let titleApi = titleApi else { return }
        guard let posterApi = posterApi else { return }
        
        // check save. if there is not movie with spesific id save move and if there is id in the array, delete the movie
        if Helper.sharedInstance.movieIdArray?.contains(idApi) ?? false {

            guard let index = Helper.sharedInstance.movieIdArray?.firstIndex(of: idApi) else {return}
            Helper.sharedInstance.movieIdArray?.remove(at: index)
            guard let index2 = Helper.sharedInstance.movieTitleArray?.firstIndex(of: titleApi) else {return}
            Helper.sharedInstance.movieTitleArray?.remove(at: index2)
            guard let index3 = Helper.sharedInstance.moviePosterArray?.firstIndex(of: posterApi) else {return}
            Helper.sharedInstance.moviePosterArray?.remove(at: index3)
            
            savedButtonOutlet.image = UIImage(named: K.savedImgEmpty)
            
        }else {
            
            Helper.sharedInstance.movieIdArray?.append(idApi)
            Helper.sharedInstance.moviePosterArray?.append(posterApi)
            Helper.sharedInstance.movieTitleArray?.append(titleApi)
            
            savedButtonOutlet.image = UIImage(named: K.savedImgFilled)
            
            //            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { Timer in
            //                self.navigationController?.popViewController(animated: true)
            //            }
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("passData"), object: nil)
        
    }
}

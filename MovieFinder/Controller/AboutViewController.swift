//
//  AboutViewController.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 09.02.22.
//

import UIKit

class AboutViewController: UIViewController, MovieSecondDelegate{
    
    
    
    var id:String?
    
    var movieSecondManager = MovieManager()
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
        
        movieSecondManager.delegateSecond = self
        movieSecondManager.performRequest(id!)
        movieSecondManager.performSecondRequest(id ?? "")
        //fetchDetailedData(by: id)
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
//        view.addSubview(scrollView)
//        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2000)
//        scrollView.contentOffset = CGPoint(x: 50, y: 40)
//
//    }
    
    func didSecondUpdate(_ movieManager: MovieManager, movieSecond: MovieSecondData) {
        DispatchQueue.main.async {
            
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
            print(movieSecond.imdbRating)
        }
    }
}

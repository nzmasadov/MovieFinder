//
//  UserVC.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 04.02.22.
//

import UIKit
import SDWebImage

class UserVC: UIViewController {
    
    @IBOutlet weak var collectionViewSaved: UICollectionView!
    
    var movie: Movie?
    var movieManager = MovieManager()
    var movieSecondData: MovieSecondData?
    
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSaved.dataSource = self
        collectionViewSaved.delegate = self
        movieManager.delegateSecond = self
        print("huucumun")
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
            
            for idMovie in Helper.sharedInstance.movieIdArray {
              
                    movieManager.performSecondRequest(idMovie)
                }
            }
        }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        print("huuDisappear")
//    }

extension UserVC: MovieManagerDelegate, MovieSecondDelegate {
    func didSecondUpdate(_ movieManager: MovieManager, movieSecond: MovieSecondData) {
        // movieSecondData'ya protokol ile datalari oturduk
        movieSecondData = movieSecond
        guard let movieSecondData = movieSecondData else {return}
        
        Helper.sharedInstance.savedDataArray.append(movieSecondData)
        
        DispatchQueue.main.async {
            self.collectionViewSaved.reloadData()
        }
    }
    
    func didUpdateMovie(_ movieManager: MovieManager, movieData: Movie) {
        movie = movieData
        DispatchQueue.main.async {
            self.collectionViewSaved.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("ERROR")
    }
}


extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Helper.sharedInstance.savedDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewSaved.dequeueReusableCell(withReuseIdentifier: "SavedCollectionViewCell", for: indexPath) as! SavedCollectionViewCell
        DispatchQueue.main.async {
            cell.savedMovieTitle.text = Helper.sharedInstance.savedDataArray[indexPath.row].title
             let imgUrl = Helper.sharedInstance.savedDataArray[indexPath.row].poster
            cell.savedImgView.sd_setImage(with: URL(string: imgUrl))
   
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2.0 - 7, height: 330)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let aboutVC = board.instantiateViewController(withIdentifier: "about") as! AboutViewController
        
        aboutVC.idApi = Helper.sharedInstance.movieIdArray[indexPath.row]
                
        // check save. if there is not movie with spesific id save move and if there is id in the array, delete the movie
        if Helper.sharedInstance.movieIdArray.contains(aboutVC.idApi ?? "") {
            Helper.sharedInstance.movieIdArray.append(aboutVC.idApi ?? "")
            print(Helper.sharedInstance.movieIdArray)
            aboutVC.savedButtonOutlet.image = UIImage(named: K.savedImgFilled)
            
        }else {
            guard let indeh = Helper.sharedInstance.movieIdArray.firstIndex(of: aboutVC.idApi ?? "") else {return}
            Helper.sharedInstance.movieIdArray.remove(at: indeh)
            aboutVC.savedButtonOutlet.image = UIImage(named: K.savedImgEmpty)
        }
        
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
}

//
//  UserVC.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 04.02.22.
//

import UIKit
import SDWebImage

class SavedVC: UIViewController {
    
    @IBOutlet weak var collectionViewSaved: UICollectionView!
    
    
    var movieManager = MovieManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSaved.dataSource = self
        collectionViewSaved.delegate = self
        
        // when user press the save button, the saved data come here.
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("passData"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        DispatchQueue.main.async {
            self.collectionViewSaved.reloadData()
        }
    }
    
    @objc func getData() {
        if let movie = Helper.sharedInstance.movieIdArray {
            for idMovie in movie {
                // saved id came here one by one then progressing start and move to movieManager for decoding. then we gain pure data.
                movieManager.performDetailedRequest(idMovie)
            }
        }
    }
   
}



extension SavedVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Helper.sharedInstance.movieIdArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewSaved.dequeueReusableCell(withReuseIdentifier: "SavedCollectionViewCell", for: indexPath) as! SavedCollectionViewCell
        DispatchQueue.main.async {
            cell.savedMovieTitle.text = Helper.sharedInstance.movieTitleArray?[indexPath.row]
            guard let imgUrl = Helper.sharedInstance.moviePosterArray?[indexPath.row] else {return}
            cell.savedImgView.sd_setImage(with: URL(string: imgUrl))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2.0 - 7, height: 330)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let board = UIStoryboard(name: "Main", bundle: nil)
        let aboutVC = board.instantiateViewController(withIdentifier: "about") as! AboutVC
        
        // pass the data
        aboutVC.idApi = Helper.sharedInstance.movieIdArray?[indexPath.row]
        aboutVC.titleApi = Helper.sharedInstance.movieTitleArray?[indexPath.row]
        aboutVC.posterApi = Helper.sharedInstance.moviePosterArray?[indexPath.row]
        
        
        // Button Checking
        if Helper.sharedInstance.movieIdArray?.contains(aboutVC.idApi ?? "") ?? false {
            aboutVC.savedButtonOutlet.image = UIImage(named: K.savedImgFilled)
            
        }else {
            aboutVC.savedButtonOutlet.image = UIImage(named: K.savedImgEmpty)
        }
        
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
}


// method for unique elements of array.

//extension Sequence where Iterator.Element: Hashable {
//    func unique() -> [Iterator.Element] {
//        var seen: Set<Iterator.Element> = []
//        return filter { seen.insert($0).inserted }
//    }
//}

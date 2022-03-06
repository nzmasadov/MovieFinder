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
    
    
    var movieManager = MovieManager()
    var movieSecondData: MovieSecondData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewSaved.dataSource = self
        collectionViewSaved.delegate = self
        movieManager.delegateSecond = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name("passData"), object: nil)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionViewSaved.reloadData()
        }
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollection), name: NSNotification.Name("passSavedData"), object: nil)
    }
    
    @objc func getData() {
        if let movie = Helper.sharedInstance.movieIdArray {
            for idMovie in movie {
                movieManager.performSecondRequest(idMovie)
                print("HuuID\(idMovie)")
            }
        }
    }
    
    //    @objc func reloadCollection() {
    //        collectionViewSaved.reloadData()
    //    }
}


//    override func viewWillDisappear(_ animated: Bool) {
//        print("huuDisappear")
//    }

extension UserVC: MovieManagerDelegate, MovieSecondDelegate {
    func didSecondUpdate(_ movieManager: MovieManager, movieSecond: MovieSecondData) {
        // movieSecondData'ya protokol ile datalari oturduk
        movieSecondData = movieSecond
        guard let movieSecondData = movieSecondData else {return}
        if Helper.sharedInstance.savedDataArray.contains(movieSecondData) != true {
            Helper.sharedInstance.savedDataArray.append(movieSecondData)
            print("I append \(Helper.sharedInstance.savedDataArray)")
        }else {
            print("hi")
        }
        DispatchQueue.main.async {
            self.collectionViewSaved.reloadData()
        }
        
    }
    
    func didUpdateMovie(_ movieManager: MovieManager, movieData: Movie) {
        print("hi movie")
    }
    
    func didFailWithError(error: Error) {
        movieSecondData = nil
        print("ERROR")
    }
}


extension UserVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Helper.sharedInstance.movieIdArray?.count ?? 0
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
        aboutVC.idApi = Helper.sharedInstance.movieIdArray?[indexPath.row]
        aboutVC.savedData = Helper.sharedInstance.savedDataArray[indexPath.row]
        
        if Helper.sharedInstance.movieIdArray?.contains(aboutVC.idApi ?? "") ?? false {
            aboutVC.savedButtonOutlet.image = UIImage(named: K.savedImgFilled)
            
        }else {
            //            collectionView.deleteItems(at: [indexPath])
            aboutVC.savedButtonOutlet.image = UIImage(named: K.savedImgEmpty)
        }
        
        navigationController?.pushViewController(aboutVC, animated: true)
    }
    
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

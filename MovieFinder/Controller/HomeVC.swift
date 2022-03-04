//
//  ViewController.swift
//  MovieExamle
//
//  Created by Nazim Asadov on 04.02.22.
//

import UIKit
import SDWebImage
import CoreData

class HomeVC: UIViewController {
    
    // var searching = false
    // var searchedMovies = [MovieData]()
    // let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var movieManager = MovieManager()
    var movie: Movie?
    var movieSecondData: MovieSecondData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieManager.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        collectionView.dataSource = self
        collectionView.delegate = self
  //      collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        searchTextField.delegate = self
        searchTextField.backgroundColor = #colorLiteral(red: 0.9372549653, green: 0.9372549057, blue: 0.9372549057, alpha: 1)
        searchTextField.layer.borderWidth = 0.1
        searchTextField.layer.cornerRadius = 15
        searchTextField.layer.masksToBounds = true
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
    }
    }

extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width/2.0 - 10, height: 300)
    }
}

extension HomeVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.search.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        DispatchQueue.main.async {
            cell.movieTitleLbl.text = self.movie?.search[indexPath.row].title

         //   cell.movieRatingLbl.text = self.movie?.search[indexPath.row].year
            if let poster = self.movie?.search[indexPath.row].poster {
                cell.movieImageView.sd_setImage(with: URL(string: (poster)))
            }
        }
        return cell
    }
}

extension HomeVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let movieId = movie?.search[indexPath.row].imdbID {
                let board = UIStoryboard(name: "Main", bundle: nil)
                let aboutVC = board.instantiateViewController(withIdentifier: "about") as! AboutViewController
                aboutVC.idApi = movieId
  //              aboutVC.fromHomeVC = true
                // Button control

                self.navigationController?.pushViewController(aboutVC, animated: true)
//                present(aboutVC, animated: true, completion: nil)
        }
    }
}

extension HomeVC: MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movieData: Movie) {
        movie = movieData
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        print("lastError")
        movie = nil
        DispatchQueue.main.async {
            
            self.collectionView.reloadData()
        }
    }
    func didSecondUpdate(_ movieManager: MovieManager, movieSecond: MovieSecondData) {
        movieSecondData = movieSecond
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeVC: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField:UITextField) {
        if let searchName = textField.text {
            print(searchName)
            movieManager.performRequest(searchName)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


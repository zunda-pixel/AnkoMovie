//
//  RepositoryViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var ProfileImage:  UIImageView!
    @IBOutlet weak var TitleLabel:    UILabel!
    @IBOutlet weak var OriginalTitle:    UILabel!
    @IBOutlet weak var Evaluation: UILabel!
    @IBOutlet weak var StartDate:    UILabel!
    
    @IBOutlet weak var OpenInSafari: UIButton!
    
    @IBAction func OpenInSafari(_ sender: Any) {
        let githubURL: String = "https://api.themoviedb.org/3/movie/\(searchView.movies[searchView.index]["id"]!)?api_key=e2c0f4b151ce58888ccc6bf509b249dd"
        
        let url = URL(string:githubURL)
        if( UIApplication.shared.canOpenURL(url!) ) {
            UIApplication.shared.open(url!)
        }
    }
    
    var searchView: ViewController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OpenInSafari.layer.cornerRadius = 10.0

        let movie = searchView.movies[searchView.index]
        
        OriginalTitle.text     = "オリジナルタイトル: \(movie["original_title"] as? String ?? "")"
        Evaluation.text  = "評価: \(movie["vote_average"]! as? String ?? "zero")"
        print(movie["vote_average"]!)
        StartDate.text     = "開始日: \(movie["release_date"] as? String ?? "")"
        getImage()
        
    }
    
    func getImage(){
        
        let movie = searchView.movies[searchView.index]
        
        TitleLabel.text = movie["title"] as? String
        
        if let imgURL = movie["poster_path"] as? String {
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w500/\(imgURL)")!) { (data, res, err) in
                let img = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.ProfileImage.image = img
                }
            }.resume()
        }
        
    }
    
}

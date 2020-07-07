//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var SearchBar: UISearchBar!
    
    var movies: [[String: Any]] = []
    
    var task: URLSessionTask?
    var word: String = ""
    var url: String  = ""
    var index: Int   = 0
    let apiKey: String = "e2c0f4b151ce58888ccc6bf509b249dd"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        // Viewが読み込まれた後の処理
        SearchBar.text = "映画検索"
        SearchBar.delegate = self
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 初期のテキストを消す
        searchBar.text = ""
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // キャンセルボタンの追加
        task?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // search(Enter)が押された際の挙動
        word = searchBar.text!
        
        if word.count != 0 {
            url = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(word)"
            guard let url: URL = URL(string: url) else {
                print("URL not constructed")
                return
            }
            
            task = makeTack(url: url)
            task?.resume()
        }
        
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 各Cellへの遷移
        if segue.identifier == "Detail"{
            let destination = segue.destination as! MovieDetailViewController
            destination.searchView = self
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Cellの数を設定
        return movies.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        let movie = movies[indexPath.row]
        cell.setCell(cell, movie)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
        
    }
    func makeTack(url:URL) -> URLSessionTask {
        let task: URLSessionTask = URLSession.shared.dataTask(with: url) { [weak self] (data, res, err) in
            do {
                if let error = err {
                    throw error
                }
                guard let jsonData = data else {
                    print("data is nil")
                    throw MyError.dataNil
                }
                guard let obj = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
                    print("JSON Serialization failed")
                    throw MyError.badData
                }

                guard let results = obj["results"] as? [[String: Any]] else {
                    print("items is not much type")
                    throw MyError.badData
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else {
                        print("self is already deallocated")
                        return
                    }
                    weakSelf.movies = results
                    weakSelf.tableView.reloadData()
                }
            }catch {
                 print(error)
            }
        }
        return task
    }
}

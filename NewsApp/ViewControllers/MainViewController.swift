//
//  MainViewController.swift
//  NewsApp
//
//  Created by Websutra  on 8/25/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import Kingfisher


class MainViewController: UIViewController {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var newsFeedTableView: UITableView!
    

    var newsFeed = NewsFeed()
    var articles = [Article]()
    let categories = Categories().categories
    var selectedCountry = "us"
    var selectedCategory = "All"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" ")
        // Do any additional setup after loading the view.
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.newsFeedTableView.delegate = self
        self.newsFeedTableView.dataSource = self
        self.getNewsHeadlines(country: self.selectedCountry, category: self.selectedCategory)
    }
    
    func getNewsHeadlines (country:String , category : String){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkRequest().getHeadlines(country: country, category: category) { (isSuccess, message, data) in
            if isSuccess{
                self.newsFeed = data
                if self.newsFeed.totalResults == 0 {
                    self.articles = []
                }else{
                    self.articles.removeAll()
                    self.articles = self.newsFeed.articles!
                }
                DispatchQueue.main.async(execute: {
                    
                    self.newsFeedTableView.reloadData()
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                })
            }else{
                DispatchQueue.main.async(execute: {
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(ac, animated: true, completion: nil)
                    
                })
            }
        }
    }
    // refresh the data
    @IBAction func refreshActionButton(_ sender: UIBarButtonItem) {
        self.getNewsHeadlines(country: self.selectedCountry, category: self.selectedCategory)
    }
    /*
    //parse data
    func parseData(articles:JSON) -> [NewsInfo]{
        var newslist = [NewsInfo]()
        for i in 0...articles.count - 1 {
            let source = articles[i]["source"]
            let id = source["id"] != JSON.null ? source["id"].stringValue : ""
            let name = source["name"] != JSON.null ? source["name"].stringValue : ""
            let title = articles[i]["title"] != JSON.null ? articles[i]["title"].stringValue : ""
            let author = articles[i]["author"] != JSON.null ? articles[i]["author"].stringValue : ""
            let description = articles[i]["description"] != JSON.null ? articles[i]["description"].stringValue : ""
            let content = articles[i]["content"] != JSON.null ? articles[i]["content"].stringValue : ""
            let publishedAt = articles[i]["publishedAt"] != JSON.null ? articles[i]["publishedAt"].stringValue : ""
            let urlToImage = articles[i]["urlToImage"] != JSON.null ? articles[i]["urlToImage"].stringValue : ""
            let url = articles[i]["url"] != JSON.null ? articles[i]["url"].stringValue : ""
          //  print(title)
            
            newslist.append(NewsInfo(source: NewsSource(id: id, name: name), author: author, title: title, description: description,content: content , publishedat: publishedAt, imageurl: urlToImage, newsurl: url))
            
        }
        return newslist
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newsdetail" {
            let vc = segue.destination as! WebViewController
            vc.url = sender as! String
        }
    }
    

}
extension MainViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.articles.count == 0 {

            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = "No News "
            emptyLabel.textAlignment = NSTextAlignment.center
            self.newsFeedTableView.backgroundView = emptyLabel
            self.newsFeedTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            return 0
        }else{
            self.newsFeedTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            return self.articles.count
        }
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsFeedTableView.dequeueReusableCell(withIdentifier: "newsfeedcell", for: indexPath) as! NewsFeedTableViewCell

        cell.titleLabel.text = self.articles[indexPath.row].title != nil ? self.articles[indexPath.row].title : ""
        let content = self.articles[indexPath.row].content != nil ?
            self.articles[indexPath.row].content : cell.titleLabel.text!
        cell.descriptionLabel.text = self.articles[indexPath.row].description != nil ? self.articles[indexPath.row].description : content
        cell.publishedAtLabel.text = self.articles[indexPath.row].publishedAt != nil ? self.articles[indexPath.row].publishedAt : ""

        let iurl = self.articles[indexPath.row].urlToImage != nil ? self.articles[indexPath.row].urlToImage : ""
        let imageurl = URL(string:iurl!)
        cell.urlImageView.kf.indicatorType = .activity

        cell.urlImageView.kf.setImage(with: imageurl, placeholder: UIImage(named: "defaultimage"), options: .none, progressBlock: .none) { (image, err, cache, url) in
            if err != nil {
                print(err.debugDescription)
                cell.urlImageView.image = UIImage(named: "defaultimage")
            }else{
                cell.urlImageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if url is not nil pass to web view
        if self.articles[indexPath.row].url != nil{
             self.performSegue(withIdentifier: "newsdetail", sender: self.articles[indexPath.row].url!)
        }else{
            DispatchQueue.main.async(execute: {
                let ac = UIAlertController(title: "Sorry", message: "News Detail not available", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                
            })
        }
       
    }
    
}
// collection view delegates
extension MainViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categorycell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryNameLabel.text = self.categories[indexPath.item]
        cell.categoryImageView.image = UIImage(named: self.categories[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let selectedCategory = self.categories[indexPath.item]
        self.selectedCategory = selectedCategory
        print("selct ",indexPath.item)
        self.getNewsHeadlines(country: self.selectedCountry, category: selectedCategory)
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("deselct ",indexPath.item)

    }
    
    
}

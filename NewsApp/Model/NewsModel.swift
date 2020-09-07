//
//  NewsModel.swift
//  NewsApp
//
//  Created by Websutra  on 8/25/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation

struct NewsFeed : Codable{
    var status:String = ""
    var totalResults:Int = 0
    var articles:[Article]?
}
struct Article : Codable{
    var source: Source?
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var urlToImage: String?
    var publishedAt:String?
    var content:String?
}
struct Source : Codable {
    var id : String?
    var name: String?
}
/*
struct NewsInfo {
    var source: NewsSource
    var author:String!
    var title:String!
    var description:String!
    var content:String!
    var publishedat:String!
    var imageurl: String!
    var newsurl:String!
}
struct NewsSource {
   var id : String!
    var name: String!
    
} */

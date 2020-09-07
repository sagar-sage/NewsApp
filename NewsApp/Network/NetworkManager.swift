//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Websutra  on 8/25/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation

class NetworkRequest {
    private  let apiKey = "0e6ad1c0ff9a44d9a5d56ae908046982"
    private let endpointURL = "https://newsapi.org/v2/top-headlines?"
    
    
    //MARK : get news headlines
    func getHeadlines(country : String , category :String , completion: @escaping (_ isSucess:Bool , _ message:String , _ data:NewsFeed) -> ()){
        var stringUrl = ""
        //check if category is selected or not
        if category == "All"{
            stringUrl = endpointURL + "country=\(country)&apiKey=\(apiKey)"
        }else{
            stringUrl = endpointURL + "country=\(country)&category=\(category)&apiKey=\(apiKey)"
        }
        var request = URLRequest(url: URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        request.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: request, completionHandler: {
                data, response, error in
                var newsfeed = NewsFeed()
                if error != nil {
                    
                    if (error?._code)! == -1009{
                       
                       completion(false , "Problem with internet connection" ,newsfeed  )
                    }
                    else if (error?._code)! == -1002
                    {
                        completion(false , "Something went wrong",newsfeed  )
                    }
                    return
                }

                let responseString = JSON(data: data!, options: [])
                //print(responseString)
               if responseString["status"].exists(){
                    if responseString["status"].stringValue == "ok"{
                        let decoder = JSONDecoder()
                        do {
                            newsfeed = try decoder.decode(NewsFeed.self, from: data!)
                            print(newsfeed)
                            completion(true  , "Success" ,newsfeed )
                        }catch{
                            print("Json parsing error ")
                            completion(false  , "Json parsing error " ,newsfeed )
                        }
                        
                        
                    }else{
                        completion(false  , responseString["message"].stringValue ,newsfeed )
                    }
                 
               }else{
                completion(false , "something went wrong" ,newsfeed )
   
                }

                
        
            })
            task.resume()
    }
    
}

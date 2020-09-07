//
//  WebViewController.swift
//  NewsApp
//
//  Created by Websutra  on 8/26/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController ,WKNavigationDelegate{
    @IBOutlet weak var webView: WKWebView!
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        if verifyUrl(urlString: self.url){
            let searchurl = URL(string: url)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            webView.load(URLRequest(url: searchurl!))
        }else{
            DispatchQueue.main.async(execute: {
                let ac = UIAlertController(title: "", message: "News does not exist ", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
                
            })
           
        }
        
        
    }
    // verify url 
    func verifyUrl(urlString: String?) -> Bool {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return false
        }

        return UIApplication.shared.canOpenURL(url)
    }
    //
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        DispatchQueue.main.async(execute: {
            MBProgressHUD.hide(for: self.view, animated: true)
            
        })
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  PDFGrid
//
//  Created by Clay Tinnell on 2/15/15.
//  Copyright (c) 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        loadPDFInWebView(generatePDF())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generatePDF() -> String {
        // http://stats.nba.com/league/player/#!/?sort=PTS&dir=1&PerMode=Totals
        let columnTitles = ["Player", "Games", "Minutes", "FG PCT", "Rebounds", "Assists", "Points"]
        let detailValues = [["James Harden", "53", "1940", "45.5", "50", "360", "1451"],
                            ["Stephen Curry", "51", "1695", "48.1", "240", "402", "1203"]]
        
        let document = PDFGridDocument(columnTitles: columnTitles, detailValues: detailValues, gridBackgroundColor: UIColor.lightGrayColor(), fileName: "NBAStats")
        
        return document.generate()
    }
    
    func loadPDFInWebView(filePath: String) {
        if let fileURL = NSURL(fileURLWithPath: filePath) {
            var request = NSURLRequest(URL: fileURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 20.0)
            
            webView.loadRequest(request)
            webView.scalesPageToFit = true
            webView.sizeToFit()
        }
    }


}


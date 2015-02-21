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
    
    func testData() -> (String, [String],[[String]]) {
        //Attribution: Test data shamelessly scraped from here:
        //http://stats.nba.com/league/player/#!/?sort=PTS&dir=1&PerMode=Totals

        let title = "2014-2015 NBA Player Statistics"
        let columnTitles = ["Player", "Games", "Minutes", "FG PCT", "Rebounds", "Assists", "Points"]
        var detailValues = [["James Harden", "53", "1940", "45.5", "50", "360", "1451"]]
        detailValues.append(["Stephen Curry", "51", "1695", "48.1", "240", "402", "1203"])
        detailValues.append(["LeBron James",  "46", "1675", "49.1", "257", "334", "1195"])
        detailValues.append(["Kyrie Irving", "53", "1992", "46.6", "175", "284", "1153"])
        detailValues.append(["Blake Griffin", "51", "1800", "50.1", "385", "262", "1149"])
        detailValues.append(["Anthony Davis", "47", "1683", "54.7", "486", "80", "1142"])
        detailValues.append(["Damian Lillard", "53", "1925", "43.3", "243", "333", "1138"])
        detailValues.append(["LaMarcus Aldridge", "47", "1693", "46.3", "486", "85", "1108"])
        detailValues.append(["Klay Thompson", "50", "1623", "47.1", "171", "147", "1104"])
        detailValues.append(["Monta Ellis", "56", "1884", "45.0", "132", "251", "1094"])
        detailValues.append(["Gordon Hayward", "53", "1865", "46.0", "264", "227", "1024"])
        detailValues.append(["Russell Westbrook", "40", "1312", "43.3", "252", "307", "1041"])
        detailValues.append(["Jimmy Butler", "50", "1966", "46.2", "291", "164", "1028"])
        detailValues.append(["Nikola Vucevic", "51", "1754", "53.5", "578", "95", "999"])

        detailValues.append(["Kyle Lowry", "54", "1883", "42.3", "255", "391", "998"])
        detailValues.append(["Chris Paul", "55", "1911", "47.0", "268", "540", "978"])
        detailValues.append(["Marc Gasol", "53", "1796", "49.1", "427", "197", "968"])
        detailValues.append(["Carmelo Anthony", "40", "1428", "44.4", "264", "122", "966"])
        detailValues.append(["John Wall", "55", "1960", "46.1", "246", "555", "956"])
        detailValues.append(["Rudy Gay", "48", "1695", "44.4", "283", "186", "955"])
        detailValues.append(["Pau Gasol", "52", "1820", "49.1", "627", "153", "952"])
        detailValues.append(["DeMarcus Cousins", "40", "1381", "46.5", "498", "133", "950"])
        detailValues.append(["Dirk Nowitzki", "52", "1550", "46.5", "311", "101", "946"])
        detailValues.append(["Chris Bosh", "44", "1556", "46.0", "310", "95", "928"])
        
        return (title,columnTitles,detailValues)
    }
    
    func color(red: Float, green: Float, blue: Float) -> UIColor {
        return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
    }
    
    func generatePDF() -> String {
        let (title, columnTitles, detailValues) = testData()
        let h1Color = color(70.0, green: 170.0, blue: 200.0)
        let h2Color = color(136.0, green: 136.0, blue: 136.0)
        let rowColor = color(239.0, green: 239.0, blue: 239.0)
        
        let document = PDFGridDocument(columnTitles: columnTitles, detailValues: detailValues, gridBackgroundColor: rowColor, fileName: "NBAStats")
        
        document.addHeader(0, title: title, height: 35.0, startingColumn: 0, endingColumn: columnTitles.count-1, backgroundColor: h1Color)

        document.addHeader(1, title: "Time On The Court", height: 25.0, startingColumn: 0, endingColumn: 2, backgroundColor: h2Color)
        document.addHeader(1, title: "Key Stats", height: 25.0, startingColumn: 3, endingColumn: 4, backgroundColor: h2Color)
        document.addHeader(1, title: "Scoring", height: 25.0, startingColumn: 5, endingColumn: 6, backgroundColor: h2Color)

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


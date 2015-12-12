# PDFGrid
Easily create a grid-based PDF document for iOS.

## Motivation
It is still very common in apps for people to want a phsyical document that they can email or save, especially in 
corporate applications. This project will give you a simple way to create a grid, or spreadsheet-like interface.

## Sample Code
```swift

let columnTitles = ["Player", "Games", "Minutes", "FG PCT", "Rebounds", "Assists", "Points"]
var detailValues = [["James Harden", "53", "1940", "45.5", "50", "360", "1451"],
                    ["Stephen Curry", "51", "1695", "48.1", "240", "402", "1203"]]

let document = PDFGridDocument(columnTitles: columnTitles, 
                               detailValues: detailValues, 
                        gridBackgroundColor: rowColor, 
                                   fileName: "NBAStats")
                                   
document.addHeader(0, title: "2014-2015 NBA Player Statistics", 
                     height: 35.0, 
             startingColumn: 0, 
               endingColumn: columnTitles.count-1, 
            backgroundColor: h1Color)
            
document.addHeader(1, title: "Time On The Court", 
                     height: 25.0, 
             startingColumn: 0, 
               endingColumn: 2, 
            backgroundColor: h2Color)
            
document.addHeader(1, title: "Key Stats", 
                     height: 25.0, 
             startingColumn: 3, 
               endingColumn: 4, 
            backgroundColor: h2Color)

document.addHeader(1, title: "Scoring", 
                     height: 25.0, 
             startingColumn: 5, 
               endingColumn: 6, 
            backgroundColor: h2Color)

let filePath = document.generate()
```

## Sample
![Sample](Documentation/SampleGrid.png "Sample Grid")

## License
Copyright (c) 2015 Clay Tinnell.

Use of the code provided on this repository is subject to the MIT License.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

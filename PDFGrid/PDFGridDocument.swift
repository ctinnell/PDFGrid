//
//  pdfGridDocument.swift
//  PDFGrid
//
//  Created by Clay Tinnell on 2/15/15.
//  Copyright (c) 2015 Clay Tinnell. All rights reserved.
//

import UIKit

class PDFGridDocument {
    
    let gridBackgroundColor: UIColor
    
    let columnTitles: [String]
    let detailValues: [[String]]
    
    let headerHeight: CGFloat
    let headerBackgroundColor: UIColor
    
    let footerHeight: CGFloat
    let footerBackgroundColor: UIColor
    
    private let fileName: String
    private let filePath: String
    
    private let numberOfColumns: Int
    private let columnWidth: CGFloat
    private let rowHeight = CGFloat(25.0)
    private let pageSize = CGSizeMake(792.0, 612.0)
    
    private var currentPage = 0;
    private var currentRow = 0;
    
    private let borderInset = CGFloat(20.0)
    private let lineWidth   = CGFloat(1.0)
    private let borderColor = UIColor.blackColor().CGColor

    private let font = UIFont.systemFontOfSize(12.0)
    
    init(columnTitles: [String], detailValues: [[String]], headerHeight: CGFloat, footerHeight: CGFloat, headerBackgroundColor: UIColor, gridBackgroundColor: UIColor, footerBackgroundColor: UIColor, fileName: String) {
        self.columnTitles = columnTitles
        self.detailValues = detailValues
        self.numberOfColumns = columnTitles.count
        self.columnWidth = (pageSize.width - ((borderInset + lineWidth) * 2.0)) / CGFloat(numberOfColumns)
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.gridBackgroundColor = gridBackgroundColor
        self.headerBackgroundColor = headerBackgroundColor
        self.footerBackgroundColor = footerBackgroundColor
        self.fileName = fileName
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        self.filePath = documentsDirectory.stringByAppendingPathComponent(fileName).stringByAppendingPathExtension(".pdf")!
    }
    
    func generate() -> String {
        UIGraphicsBeginPDFContextToFile(self.filePath, CGRectZero, nil);
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil)
        
        var nextYPosition = borderInset + lineWidth
        addTheBorder()
        nextYPosition = addTheColumnTitles(nextYPosition)
        nextYPosition = addTheDetailValues(nextYPosition)
        
        UIGraphicsEndPDFContext();
        
        return filePath
    }
    
    private func addTheBorder() {
        let frameWidth = pageSize.width - (borderInset * 2.0)
        let frameHeight = pageSize.height - (borderInset * 2.0)
        let frame = CGRectMake(borderInset, borderInset, frameWidth, frameHeight)
        drawRectangle(frame)
    }
    
    private func addTheColumnTitles(yPosition: CGFloat) -> CGFloat {
        return drawRow(columnTitles, startingYPosition: yPosition, backgroundColor: UIColor.grayColor())
    }
    
    private func addTheDetailValues(yPosition: CGFloat) -> CGFloat {
        var nextYPosition = yPosition
        for detailRow in self.detailValues {
            nextYPosition = drawRow(detailRow, startingYPosition: nextYPosition, backgroundColor: gridBackgroundColor)
        }
        return nextYPosition
    }
    
    private func drawRow(rowValues: [String], startingYPosition: CGFloat, backgroundColor: UIColor) -> CGFloat {
        var xPosition = borderInset + lineWidth
        for value in rowValues {
            let rect = CGRectMake(xPosition, startingYPosition, columnWidth, rowHeight)
            drawRectangle(rect)
            fillRectangle(rect, fillColor: backgroundColor)
            drawText(value, frame: rect)
            xPosition += columnWidth
        }
        return startingYPosition + rowHeight
    }
    
    private func drawRectangle(frame: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(context, borderColor)
        CGContextSetLineWidth(context, lineWidth)
        CGContextStrokeRect(context, frame)
    }
    
    private func fillRectangle(frame: CGRect, fillColor: UIColor) {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, fillColor.CGColor)
        CGContextFillRect(context, frame)
    }
    
    private func drawText(text: String, frame: CGRect) {
        let size = (text as NSString).sizeWithAttributes([NSFontAttributeName:font])
        let textFrame = centerFrame(CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height))
        
        (text as NSString).drawInRect(textFrame, withAttributes: [NSFontAttributeName : font,
            NSForegroundColorAttributeName: UIColor.blackColor()])
    }
    
    private func centerFrame(frame: CGRect) -> CGRect {
        let width = (frame.size.width > columnWidth) ? columnWidth : frame.size.width
        let xPosition = (width == columnWidth) ? frame.origin.x : frame.origin.x + ((columnWidth - width) / 2)
        
        let height = (frame.size.height > rowHeight) ? rowHeight : frame.size.height
        let yPosition = (height == rowHeight) ? frame.origin.y : frame.origin.y + ((rowHeight - height) / 2)
        
        return CGRectMake(xPosition, yPosition, width, height)
     }
    
    //TODO: Calculate column widths into an array instead of evenly distributing them.
    //TODO: Add a page break. Possibly a canFitAnotherRow method and a createNewPage method.
    //TODO: What about multiple page types within a document? Is this necessary?

}

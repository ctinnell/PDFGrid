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
    var multiLineColumnTitles: Bool = true
    let detailValues: [[String]]
    
    let headerHeight: CGFloat
    let headerBackgroundColor: UIColor
    
    let footerHeight: CGFloat
    let footerBackgroundColor: UIColor
    
    private let fileName: String
    private let filePath: String
    
    private let numberOfColumns: Int

    private var columnWidths: [Float]
    private var columnTitleWidths: [Float]
    
    private let rowHeight = CGFloat(25.0)
    private var titleRowHeight = CGFloat(25.0)
    private var pageSize = CGSizeMake(792.0, 612.0)
    
    private var currentPage = 0;
    private var currentRow = 0;
    
    private let borderInset = CGFloat(20.0)
    private let lineWidth   = CGFloat(1.0)
    private let borderColor = UIColor.blackColor().CGColor

    private let font = UIFont.systemFontOfSize(12.0)
    
    init(columnTitles: [String], detailValues: [[String]], gridBackgroundColor: UIColor, fileName: String) {
        self.columnTitles = columnTitles
        self.detailValues = detailValues
        self.numberOfColumns = columnTitles.count
        self.headerHeight = 0.0
        self.footerHeight = 0.0
        self.gridBackgroundColor = gridBackgroundColor
        self.headerBackgroundColor = UIColor.grayColor()
        self.footerBackgroundColor = UIColor.grayColor()
        self.fileName = fileName
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = paths[0] as String
        self.filePath = documentsDirectory.stringByAppendingPathComponent(fileName).stringByAppendingPathExtension(".pdf")!
        self.columnWidths = []
        self.columnTitleWidths = []
        (self.columnTitleWidths, self.columnWidths) = calculateColumnWidths()
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
        return drawRow(columnTitles, startingYPosition: yPosition, backgroundColor: headerBackgroundColor, isColumnHeader: true)
    }
    
    private func addTheDetailValues(yPosition: CGFloat) -> CGFloat {
        var nextYPosition = yPosition
        for detailRow in self.detailValues {
            nextYPosition = drawRow(detailRow, startingYPosition: nextYPosition, backgroundColor: gridBackgroundColor, isColumnHeader: false)
        }
        return nextYPosition
    }
    
    private func drawRow(rowValues: [String], startingYPosition: CGFloat, backgroundColor: UIColor, isColumnHeader: Bool) -> CGFloat {
        var xPosition = borderInset + lineWidth
        var column = 0
        var thisRowHeight = (isColumnHeader) ? titleRowHeight : rowHeight
        for value in rowValues {
            let rect = CGRectMake(xPosition, startingYPosition, CGFloat(columnWidths[column]), thisRowHeight)
            drawRectangle(rect)
            fillRectangle(rect, fillColor: backgroundColor)
            if isColumnHeader {
                drawHeaderText(value, frame: rect, column: column)
            }
            else {
                drawDetailText(value, frame: rect, column: column)
            }
            xPosition += CGFloat(columnWidths[column])
            column++
        }
        return startingYPosition + thisRowHeight
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
    
    private func drawHeaderText(text: String, frame: CGRect, column: Int) {
        if multiLineColumnTitles {
            var adjustedFrame = (text as NSString).boundingRectWithSize(CGSizeMake(CGFloat(columnTitleWidths[column]), CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil)
            
            adjustedFrame = CGRectMake(frame.origin.x, frame.origin.y, adjustedFrame.width, adjustedFrame.height)
            drawText(text, frame: adjustedFrame, column: column, adjustedRowHeight: titleRowHeight)
        }
        else {
            drawDetailText(text, frame: frame, column: column)
        }
    }
    
    private func drawDetailText(text: String, frame: CGRect, column: Int) {
        var size = (text as NSString).sizeWithAttributes([NSFontAttributeName:font])
        let adjustedFrame = CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)
        
        drawText(text, frame: adjustedFrame, column: column, adjustedRowHeight: rowHeight)
    }
    
    private func drawText(text: String, frame: CGRect, column: Int, adjustedRowHeight: CGFloat) {
        let context = UIGraphicsGetCurrentContext()
        
        let outerFrameSize = CGSizeMake(CGFloat(columnWidths[column]), adjustedRowHeight)
        var textFrame = centerFrame(frame, outerFrameSize: outerFrameSize)
        (text as NSString).drawWithRect(textFrame, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font,
            NSForegroundColorAttributeName: UIColor.blackColor()], context: nil)
    }
    
    private func centerFrame(frameToCenter: CGRect, outerFrameSize: CGSize) -> CGRect {
        // constrain w,h to outer bounds
        let newWidth = (frameToCenter.size.width > outerFrameSize.width) ? outerFrameSize.width : frameToCenter.size.width
        //let newHeight = (frameToCenter.size.height > outerFrameSize.height) ? outerFrameSize.height : frameToCenter.size.height
        let newHeight = frameToCenter.size.height
        // calculate new x,y
        let xPosition = (newWidth == outerFrameSize.width) ? frameToCenter.origin.x : frameToCenter.origin.x + ((outerFrameSize.width - newWidth) / 2)
        let yPosition = (newHeight == outerFrameSize.height) ? frameToCenter.origin.y : frameToCenter.origin.y + ((outerFrameSize.height - newHeight) / 2)
        
        return CGRectMake(xPosition, yPosition, newWidth, newHeight)
     }
    
    private func calculateColumnWidths() -> ([Float],[Float]) {
        var widths: [Float] = []
        var titleWidths: [Float] = []
        // start with the column titles
        for (var x=0; x<countElements(columnTitles); x++) {
            // for multi-line column titles, we need to loop through each word in the title to determine width.
            // In this case, we will use titleWidths to draw the text for the column titles.
            if multiLineColumnTitles {
                let titleWords = split(columnTitles[x], { $0 == " "}, maxSplit: Int.max, allowEmptySlices: false)
                var oldWidth = Float(0.0)
                widths.append(Float(0.0)) // ensure a value
                for (var y=0; y<countElements(titleWords); y++) {
                    widths[x] = (newWidth(titleWords[y], oldWidth: oldWidth))
                }
                let wordHeight = sizeForString(columnTitles[x], width: CGFloat(widths[x])).height
                titleRowHeight = (wordHeight > titleRowHeight) ? wordHeight : titleRowHeight
            }
            else {
                widths.append(newWidth(columnTitles[x], oldWidth: 0.0))
            }
            titleWidths.append(widths[x])
        }
        
        // loop through detail items
        for detail in detailValues {
            for (var x=0; x<numberOfColumns; x++) {
                widths[x] = newWidth(detail[x], oldWidth: widths[x])
            }
        }
        
        // pad all columns evenly to full length of grid
        let sumOfColumnWidths = widths.reduce(0) {$0 + $1}
        
        let lineWidthAndBorderInsetWidth = ((lineWidth + borderInset) * 2.0)
        let gridWidth = Float(pageSize.width - lineWidthAndBorderInsetWidth)
        if CGFloat(sumOfColumnWidths) < CGFloat(gridWidth) {
            let columnPadding = (gridWidth - sumOfColumnWidths) / Float(numberOfColumns)
            for (var x=0; x<countElements(columnTitles); x++) {
                widths[x] = widths[x] + columnPadding
            }
        }
        else {
            // the grid size is now bigger than the original specified size
            pageSize = CGSizeMake(CGFloat(sumOfColumnWidths) + lineWidthAndBorderInsetWidth, pageSize.height)
        }
        
        return (titleWidths, widths)
    }
    
    private func sizeForString(value: String, width: CGFloat) -> CGSize {
        //return (value as NSString).sizeWithAttributes([NSFontAttributeName:font])
        return (value as NSString).boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
    }
    
    private func newWidth(value: String, oldWidth: Float) -> Float {
        let size = sizeForString(value, width: CGFloat(0.0))
        return ((Float(size.width)) > oldWidth) ? Float(size.width) + 10.0 : oldWidth
    }
    
    //TODO: Add prefers Multi-line header option using:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSString_AppKitAdditions/index.html#//apple_ref/occ/instm/NSString/boundingRectWithSize:options:attributes:
    // and: let arr = split(str, { $0 == " "}, maxSplit: Int.max, allowEmptySlices: false)
    //TODO: Add a page break. Possibly a canFitAnotherRow method and a createNewPage method.
    //TODO: What about multiple page types within a document? Is this necessary?

}

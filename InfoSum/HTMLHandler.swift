//////////////////////////////////////////////////////////////////////
// Created by Wezley Sherman on 6/8/16.                             //
// Copyright © 2016 Wezley Sherman. All rights reserved.            //
//                                                                  //
// This class is responsible for processing the initial input       //
// from the user and return the page body and title, or to see that //
// the user has previously summarized the page. In the case that    //
// the page has already been summarized, we will return that object //
//////////////////////////////////////////////////////////////////////

import UIKit

class HTMLHandler : SearchInput {
    // Create our strings for the page title and body.
    var pageBody = "empty_body"
    var pageTitle = "empty_title"
    
    // Initiate the object, and use the parent to determine of it is a link or search item.
    init(initLink : String) {
        super.init(sInput: initLink)
        parsePage(initLink)
    }
    
    // This function processes the page and determines if we summarize a new page, or look at an old summary.
    func parsePage(pageLink : String){
        let inType = super.checkInput()
        if (inType == inputType.LINK) {
            let htmlSource = fetchHTMLSource(NSURL(string: pageLink)!)
            pageTitle = fetchPageTitle(htmlSource)
            pageBody = fetchPageBody(htmlSource)
        } else if(inType == inputType.SEARCH_ITEM) {
            searchForItem(pageLink)
        }
    }
    
    // This function searches previous summaries for an already existing term.
    func searchForItem(item: String) {
        for summ in textSummarizer.summarys {
            if(summ.title.lowercaseString.containsString(item.lowercaseString)) {
                currentSummary = summ
                pageTitle = summ.title
                pageBody = summ.summary
                break;
            } else {
                pageTitle = "Can't find search item. Please try again."
            }
        }
    }
    
    // This function looks at the page's source and returns the body text.
    func fetchPageBody(pageSource: String) -> String {
        let htmlToText = pageSource.dataUsingEncoding(NSUTF8StringEncoding)!
        do {
            return try NSAttributedString(data: htmlToText, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,        NSCharacterEncodingDocumentAttribute:NSUTF8StringEncoding], documentAttributes: nil).string
        } catch {
            return "I am unable to process this link. Please provide a different link"
        }
    }
    
    // This function looks at the page's source and returns its title.
    func fetchPageTitle(pageSource: String) -> String {
        let startIndexs = pageSource.rangeOfString("<title>")
        let endIndexs = pageSource.rangeOfString("</title>")
        if (startIndexs != nil && endIndexs != nil) {
            return pageSource[startIndexs!.endIndex..<endIndexs!.startIndex]
        }
        return "Unable to get page title."
    }
    
    // This function will return the html source of the given url.
    func fetchHTMLSource(urlLink: NSURL) -> String {
        do {
            let myHTMLString = try NSString(contentsOfURL: urlLink, encoding: NSUTF8StringEncoding)
            return myHTMLString as String
        } catch {
            return "nil"
        }
    }
    
    // Getter functions
    func getPageBody() -> String {
        return pageBody
    }
    
    func getPageTitle() -> String {
        return pageTitle
    }
}


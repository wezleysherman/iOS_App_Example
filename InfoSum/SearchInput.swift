///////////////////////////////////////////////////////////////
// Created by Wezley Sherman on 6/8/16.                      //
// Copyright © 2016 Wezley Sherman. All rights reserved.     //
///////////////////////////////////////////////////////////////

import UIKit

enum inputType {case LINK, SEARCH_ITEM}

class SearchInput : NSObject {
    var sInput = "empty_link"
    
    init (sInput: String) {
        self.sInput = sInput
    }
    
    // Checks to see if the input is a link or search term
    func checkInput() -> inputType{
        do {
            try NSString(contentsOfURL: NSURL(string: sInput)!, encoding: NSUTF8StringEncoding)
            return inputType.LINK
        } catch {
            return inputType.SEARCH_ITEM
        }
    }
}

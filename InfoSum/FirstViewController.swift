//////////////////////////////////////////////////////////////////////
// Created by Wezley Sherman on 6/8/16.                             //
// Copyright © 2016 Wezley Sherman. All rights reserved.            //
//                                                                  //
// This class handles the main search view. It takes in the         //
// search input, user preferences, and begins the summarizing       //
// process.                                                         //
//////////////////////////////////////////////////////////////////////


import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    // Define UI Elements for use
    @IBOutlet var keyWordText : UILabel!
    @IBOutlet var sentenceText : UILabel!
    @IBOutlet var searchInput : UITextField!
    
    // String that stores the item given to the input bar
    var searchTerm = "empty_term"
    
    /* `sentenceCount` and `keywordCount` are integers used
     * to determine user preferences for the length and
     * accuracy of their summaries
     */
    var sentenceCount = 4
    var keywordCount = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Handle changes to slider value for number of sentences in summary
    @IBAction func sentenceSliderValueChanged(sender: UISlider) {
        self.view.endEditing(true)
        sentenceCount = Int(sender.value)
        sentenceText.text = "Sentences: \(sentenceCount)"
    }
    
    // Handle changes to slider value for number of keywords used to create an accurate summary
    @IBAction func keywordSliderValueChanged(sender: UISlider) {
        self.view.endEditing(true)
        keywordCount = Int(sender.value)
        keyWordText.text = "Keywords: \(keywordCount)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Close keyboard when user taps on the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Close keyboard when `return` is hit. Do not search, because user must input preferences
    func textFieldShouldReturn(searchText: UITextField) -> Bool {
        searchText.resignFirstResponder()
        return true
    }

    /* Called when `Summarize` is pressed.
     * This function sends the userinput to our `textSummarizer` object.
     * The textSummarizer object handles processing, sorting, and summarizing.
     *
     * Go to detailed view after summary is created and reset the input box.
     */
    @IBAction func searchButtonClicked(sender: UIButton) {
        textSummarizer.summarize(searchInput.text!, sentenceCount: sentenceCount, keyWordCount: keywordCount)
        searchInput.text = ""
        self.tabBarController?.selectedIndex = 2
    }

}


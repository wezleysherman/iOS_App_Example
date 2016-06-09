///////////////////////////////////////////////////////////////
// Created by Wezley Sherman on 6/8/16.                      //
// Copyright © 2016 Wezley Sherman. All rights reserved.     //
///////////////////////////////////////////////////////////////

import UIKit


class ThirdViewController: UIViewController {
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Set the detailed view's lable and textview objects to the currently selected summary
    override func viewWillAppear(animated: Bool) {
        titleText.text = currentSummary.title
        descriptionText.text = currentSummary.summary
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
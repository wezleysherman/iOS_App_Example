//////////////////////////////////////////////////////////////////////
// Created by Wezley Sherman on 6/8/16.                             //
// Copyright © 2016 Wezley Sherman. All rights reserved.            //
//                                                                  //
// This class is responsible for handling user input on our table   //
// as well as processing new summaries.                             //
//                                                                  //
//////////////////////////////////////////////////////////////////////

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var summaryTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Update list every time we view this scene
    override func viewWillAppear(animated: Bool) {
        summaryTable.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textSummarizer.summarys.count
    }
    
    /* When an element in the list is pressed,
     * set `currentSummary` equal to that object
     * and jump to the detailed view scene.
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentSummary = textSummarizer.summarys[indexPath.row]
        self.tabBarController?.selectedIndex = 2
    }
    
    // Handle deleting objects from our summary list
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            textSummarizer.summarys.removeAtIndex(indexPath.row)
            summaryTable.reloadData()
        }
    }
    
    // Create the list of available summaries.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "History")
        cell.textLabel!.text = textSummarizer.summarys[indexPath.row].title
        cell.detailTextLabel!.text = textSummarizer.summarys[indexPath.row].summary
        return cell
    }
}


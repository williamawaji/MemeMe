//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by William Awaji on 09/01/2018.
//  Copyright © 2018 WA. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // MARK: Properties
    var memes: [Meme]!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 100 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    // MARK: Actions
    @IBAction func addNewMeme(_ sender: Any) {
        performSegue(withIdentifier: "presentMemeEditorViewController", sender: sender)
    }
    
    
    // MARK: TableView Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell", for: indexPath)
        let meme = self.memes[(indexPath as IndexPath).row]
        
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = "\(meme.topText)...\(meme.bottomText)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        detailController.memeIndex = indexPath.row
        
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.remove(at: indexPath.row)
            self.memes = appDelegate.memes
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

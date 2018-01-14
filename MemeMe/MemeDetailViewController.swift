//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by William Awaji on 09/01/2018.
//  Copyright © 2018 WA. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // MARK: Properties
    var memeIndex: Int!
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide bar item
        self.tabBarController?.tabBar.isHidden = true
        
        // Add edit button to edit Meme
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
        self.navigationItem.rightBarButtonItem = edit
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.imageView!.image = appDelegate.memes[memeIndex].memedImage
        self.imageView.reloadInputViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    @objc func editMeme() {
        performSegue(withIdentifier: "presentMemeEditorViewController", sender: self.memeIndex)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentMemeEditorViewController" {
            let memeIndex = (sender as! Int)
            let editorViewController = segue.destination as! MemeEditorViewController
            editorViewController.memeEditIndex =  memeIndex
        }
    }
}

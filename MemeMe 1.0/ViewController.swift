//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by William Awaji on 27/11/2017.
//  Copyright © 2017 WA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var shareButtom: UIBarButtonItem!
    
    // MARK: Properties
    let textFieldDelegate = MememeTextFieldDelegate()
    let memeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4.0]
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField(textField: topTextField, text: "TOP")
        configureTextField(textField: bottomTextField, text: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButtom.isEnabled = imagePickerView.image != nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Functions
    func configureTextField(textField: UITextField, text: String) {
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = textFieldDelegate
    }
    
    func configureBars(hidden: Bool) {
        topToolBar.isHidden = hidden
        bottomToolBar.isHidden = hidden
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationHandler(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationHandler(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardNotificationHandler(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            if notification.name == .UIKeyboardWillShow {
                view.frame.origin.y -= getKeyboardHeight(notification)
            } else if notification.name == .UIKeyboardWillHide {
                view.frame.origin.y = 0
            }
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        configureBars(hidden: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(hidden: false)
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView
            .image!, memedImage: memedImage)
    }
    
    // MARK: Functions - Actions
    @IBAction func pickAnImage(_ sender: Any) {
        if let barButton = sender as? UIBarButtonItem {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = barButton == cameraButton ? .camera : .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelMemeImage(_ sender: Any) {
        configureTextField(textField: topTextField, text: "TOP")
        configureTextField(textField: bottomTextField, text: "BOTTOM")
        imagePickerView.image = nil
        shareButtom.isEnabled = false
    }
    
    @IBAction func shareMemeImage(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            (_,successful,_,_) in
            if successful{
                self.save(memedImage: memedImage);
            }
        }
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    // MARK: Delegates
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            imagePickerView.image = editedImage
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
}


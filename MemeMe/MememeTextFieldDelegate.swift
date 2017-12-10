//
//  MememeTextFieldDelegate.swift
//  MemeMe 1.0
//
//  Created by William Awaji on 29/11/2017.
//  Copyright © 2017 WA. All rights reserved.
//

import Foundation
import UIKit

class MememeTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
}

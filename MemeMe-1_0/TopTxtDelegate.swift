//
//  TopTxtDelegate.swift
//  MemeMe-1_0
//
//  Created by Mike Huffaker on 12/2/16.
//  Copyright © 2016 Mike Huffaker. All rights reserved.
//

import Foundation
import UIKit

class TopTxtDelegate : NSObject, UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print( "TopTxtFieldDelegate::textFieldDidBeginEditing()")

        // Only if the text field has is initial value, then null
        // out when the user starts editing
         print( "Before If")
        if textField.text == "TOP"
        {
            print( "Inside If")

            textField.text = ""
            print( "Text Field cleared")

        }
        
        print( "Exiting textFieldDidBeginEditing")

        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        print( "TopTxtFieldDelegate::textFieldShouldReturn()")
        
        textField.resignFirstResponder()
        
        return true
    }
}

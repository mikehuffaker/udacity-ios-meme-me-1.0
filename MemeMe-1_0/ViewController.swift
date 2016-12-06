//
//  ViewController.swift
//  MemeMe-1_0
//
//  Created by Mike Huffaker on 11/30/16.
//  Copyright © 2016 Mike Huffaker. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtBottom: UITextField!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!

    let memeTxtAttributes:[String:Any] =
    [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont( name: "HelveticaNeue-CondensedBlack", size: 40 )!,
        NSStrokeWidthAttributeName: NSNumber( value: -2.0 )
    ]
    
    let topTxtDelegate = TopTxtDelegate()
    let bottomTxtDelegate = BottomTxtDelegate()
    
    override func viewDidLoad()
    {
        print( "ViewController::viewDidLoad()" )
        
        super.viewDidLoad()

        // Setup top meme text field
        print( "At 1" )

        txtTop.defaultTextAttributes = memeTxtAttributes
        txtTop.textAlignment = NSTextAlignment.center
        txtTop.text = "TOP"

        print( "At 4" )

        txtTop.delegate = topTxtDelegate
        
        // Setup bottom meme text field
        print( "At 5" )

        txtBottom.defaultTextAttributes = memeTxtAttributes
        txtBottom.textAlignment = NSTextAlignment.center
        txtBottom.text = "BOTTOM"

        print( "At 8" )

        txtBottom.delegate = bottomTxtDelegate
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        print( "ViewController::viewDidAppear()" )
        
        // Test if device has camera or not and enable/disable button accordingly
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        print( "ViewController::viewWillAppear()" )
        
        super.viewWillAppear( animated )
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        print( "ViewController::viewWillDisappear()" )
        
        super.viewWillDisappear( animated )
        unsubscribeFromKeyboardNotifications()
    }
    
    // Keyboard shifting code
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil )
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil )
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver( self, name: .UIKeyboardWillShow, object: nil )
    }
    
    func keyboardWillShow(_ notification:Notification)
    {
        if txtBottom.isFirstResponder
        {
            view.frame.origin.y -= getKeyboardHeight( notification )
        }
    }
    
    func keyboardWillHide(_ notification:Notification)
    {
        if txtBottom.isFirstResponder
        {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Image picker code
    // User cancelled instead of picking an image
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController )
    {
        print( "ViewController::imagePickerControllerDidCancel()" )

        dismiss( animated: true, completion: nil )
    }

    // User actually picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        print( "ViewController::imagePickerController() - picked image Delegate" )

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imgView.contentMode = .scaleAspectFit
            imgView.image = image
        }
        else
        {
            print( "ViewController::imagePickerController: error passing picked image to view controller image." )
        }
        
        dismiss( animated: true, completion: nil )
    }

    @IBAction func pickImageFromCamera(_ sender: AnyObject)
    {
        print( "ViewController::pickImageFromCamera()" )

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present( pickerController, animated: true, completion: nil )
    }
    
    @IBAction func pickImageFromAlbum(_ sender: AnyObject)
    {
        print( "ViewController::pickImageFromAlbum()" )

        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present( pickerController, animated: true, completion: nil )
    }
}


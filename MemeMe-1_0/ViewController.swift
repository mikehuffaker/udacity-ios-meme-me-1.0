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

    // Top toolbar and buttons
    @IBOutlet weak var tbSocial: UIToolbar!
    @IBOutlet weak var btnSocial: UIBarButtonItem!
    @IBOutlet weak var btnCancel: UIBarButtonItem!
    
    // Text fields and image
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtBottom: UITextField!
    
    // Bottom toolbar and buttons
    @IBOutlet weak var tbImage: UIToolbar!
    @IBOutlet weak var btnCamera: UIBarButtonItem!
    @IBOutlet weak var btnAlbum: UIBarButtonItem!

    let memeTxtAttributes:[String:Any] =
    [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont( name: "HelveticaNeue-CondensedBlack", size: 40 )!,
        NSStrokeWidthAttributeName: NSNumber( value: -4.0 )
    ]
    
    let topTxtDelegate = TopTxtDelegate()
    let bottomTxtDelegate = BottomTxtDelegate()
    
    var theMeme: MemeImage!
    
    override func viewDidLoad()
    {
        print( "ViewController::viewDidLoad()" )
        
        super.viewDidLoad()
        
        // initially disable top toolbar share button, until the user picks an image for a meme
        btnSocial.isEnabled = false
        //btnCancel.isEnabled = false

        // Setup top meme text field
        txtTop.defaultTextAttributes = memeTxtAttributes
        txtTop.textAlignment = NSTextAlignment.center
        txtTop.text = "TOP"
        txtTop.delegate = topTxtDelegate
        
        // Setup bottom meme text field
        txtBottom.defaultTextAttributes = memeTxtAttributes
        txtBottom.textAlignment = NSTextAlignment.center
        txtBottom.text = "BOTTOM"
        txtBottom.delegate = bottomTxtDelegate
        
        // Setting Aspect Fit so image expands and fits the screen
        imgView.contentMode = UIViewContentMode.scaleAspectFit
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
        
        //tbSocial.barTintColor = UIColor.lightGray
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
    print( "ViewController::subscribeToKeyboardNotifications()" )

        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil )
        NotificationCenter.default.addObserver( self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil )
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        print( "ViewController::unsubscribeFromKeyboardNotifications()" )

        NotificationCenter.default.removeObserver( self, name: .UIKeyboardWillShow, object: nil )
    }
    
    func keyboardWillShow(_ notification:Notification)
    {
        print( "ViewController::keyboardWillShow()" )

        if txtBottom.isFirstResponder
        {
            view.frame.origin.y -= getKeyboardHeight( notification )
        }
    }
    
    func keyboardWillHide(_ notification:Notification)
    {
        print( "ViewController::keyboardWillHide()" )

        if txtBottom.isFirstResponder
        {
            view.frame.origin.y = 0.0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat
    {
        print( "ViewController::getKeyboardHeight()" )

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Image picker code section
    
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
            btnSocial.isEnabled = true
            btnCancel.isEnabled = true
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
    
    // User pressed cancel, reset application
    @IBAction func cancelMeme(_ sender: AnyObject)
    {
        print( "ViewController::cancelMeme()" )

        btnSocial.isEnabled = false
        txtTop.text = "TOP"
        txtBottom.text = "BOTTOM"
        imgView.image = nil
        
        // per Apple docs, I think this is ok, it will set the structures reference to nil
        // and via ARC functionallity, memory will be freed up automatically, similar to Java
        // garbage collection.
        theMeme = nil
    }
    
    // Meme sharing/processing code
    
    // generate and then share the meme by launching the activity view
    @IBAction func shareMeme(_ sender: AnyObject)
    {
        print( "ViewController::shareMeme()" )
        
        let memedImage = generateMemedImage()
        let socialController = UIActivityViewController( activityItems: [memedImage], applicationActivities: nil )

        socialController.completionWithItemsHandler =
        {
            activityType, completion, items, error in
            
            if completion
            {
                print ( "User performed activity:" + activityType!.rawValue )
                // Save meme
                self.saveMemedImage( memedImage: memedImage )
            }
            else
            {
                print ( "User cancelled or other error" )
            }
            
            self.dismiss( animated: true, completion: nil )
        }
        
        self.present( socialController, animated: true, completion: nil )
    }
    
    // generate a new Memed image
    func generateMemedImage() -> UIImage
    {
        print( "ViewController::generateMemedImage()" )
        
        tbSocial.isHidden = true
        tbImage.isHidden = true
        
        UIGraphicsBeginImageContext( self.view.frame.size )
        view.drawHierarchy( in: self.view.frame, afterScreenUpdates: true )
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        tbSocial.isHidden = false
        tbImage.isHidden = false

        return memedImage
    }
    
    // Note - slight variation on lesson example - memed image is local to calling function,
    // But other values are already objects in the view controller class, so I think
    // its better to pass in the memedImage as it is not a class variable at this point.
    func saveMemedImage( memedImage: UIImage )
    {
        print( "ViewController::saveMemedImage()" )
        
        self.theMeme = MemeImage.init( topText: self.txtTop.text!, bottomText: self.txtBottom.text!, origImage: self.imgView.image!, memedImage: memedImage )
    }
}


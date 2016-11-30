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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtTop.text = "Top"
        txtBottom.text = "Bottom"
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        // Test if device has camera or not and enable/disable button accordingly
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    // User cancelled instead of picking an image
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController )
    {
        dismiss( animated: true, completion: nil )
    }

    // User actually picked an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
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
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present( pickerController, animated: true, completion: nil )
    }
    
    @IBAction func pickImageFromAlbum(_ sender: AnyObject)
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present( pickerController, animated: true, completion: nil )
    }
}


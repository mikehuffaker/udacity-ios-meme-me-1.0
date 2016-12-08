//
//  MemeImage.swift
//  MemeMe-1_0
//
//  Created by Mike Huffaker on 12/6/16.
//  Copyright © 2016 Mike Huffaker. All rights reserved.
//

import Foundation
import UIKit

// Structure for storing Meme Image information
struct MemeImage
{
    var topText: String
    var bottomText: String
    var origImage: UIImage
    var memedImage: UIImage
    
    init( topText text1: String, bottomText text2: String, origImage image1: UIImage, memedImage image2: UIImage )
    {
        topText = text1
        bottomText = text2
        origImage = image1
        memedImage = image2
    }
}


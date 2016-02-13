//
//  MemeConstants.swift
//  memeMe
//
//  Created by Manson Jones on 2/13/16.
//  Copyright © 2016 Manson Jones. All rights reserved.
//

import UIKit

struct MemeConstants {
    
    // This defines a font that closely resembles the classic meme font
    struct FontStyles {
        static let Meme = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size:40.0)!,
            NSStrokeWidthAttributeName: -3.0
        ]
    }

}

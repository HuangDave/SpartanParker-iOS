//
//  AuthenticationViewController.swift
//  SpartanParker-iOS
//
//  Created by DAVID HUANG on 8/8/18.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    @IBOutlet weak private var segmentedController: SegmentedController!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        segmentedController.delegate = self
        segmentedController.titleColor = UIColor.spartanGray
        segmentedController.highlightColor = UIColor.spartanBlue
        segmentedController.addBottomBorder(width: 0.5, color: UIColor.lightGray, opacity: 0.5)
    }

}

extension AuthenticationViewController: SegmentedControllerDelegate {
    
    func segmentedController(_ segmentedController: SegmentedController, didSelectSegmentAtIndex index: Int) {
        
    }
}

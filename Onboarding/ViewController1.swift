//
//  ViewController.swift
//  Onboarding
//
//  Created by Sachin Agrawal on 3/8/24.
//

import UIKit

class ViewController1: UIViewController {

    @IBOutlet weak var startOver: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer to the label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        startOver.isUserInteractionEnabled = true
        startOver.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {
        // Perform the segue when the label is tapped
        performSegue(withIdentifier: "toBeginning", sender: self)
    }

}


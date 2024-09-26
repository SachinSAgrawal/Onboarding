//
//  ViewController.swift
//  Onboarding
//
//  Created by Sachin Agrawal on 3/8/24.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var begin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer to the label
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        begin.isUserInteractionEnabled = true
        begin.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {
        // Perform the segue when the label is tapped
        performSegue(withIdentifier: "toOnboarding", sender: self)
    }

}


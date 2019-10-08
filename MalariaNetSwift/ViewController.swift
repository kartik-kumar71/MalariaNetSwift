//
//  ViewController.swift
//  MalariaNetSwift
//
//  Created by Kartik Kumar on 05/10/19.
//  Copyright © 2019 Kartik Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cellImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Image Source", message: "Choose an image", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}


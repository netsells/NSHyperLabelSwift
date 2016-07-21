//
//  ViewController.swift
//  NSHyperLabelSwift
//
//  Created by Jack Colley on 07/20/2016.
//  Copyright (c) 2016 Jack Colley. All rights reserved.
//

import UIKit
import NSHyperLabelSwift

class ViewController: UIViewController {

    @IBOutlet var testLabel: HyperLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.text = "YES NETSELLS... WE'RE DOING IT FOR YOU"
        testLabel.setLinkForSubstring("NETSELLS", attributes: testLabel.linkAttributeDefault, url: NSURL(string: "http://netsells.co.uk")!) { (label, substring) in
            print("YES NETSELLS")
        }
        
        testLabel.setLinkForSubstring("YOU", attributes: testLabel.linkAttributeDefault, url: NSURL(string: "http://jackcolley.co.uk")!) { (label, substring) in
            print("YES ME")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


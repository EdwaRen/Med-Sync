//
//  HubViewController.swift
//  MedSync4.0
//
//  Created by - on 2017/01/24.
//  Copyright © 2017 Danth. All rights reserved.
//

import UIKit

class HubViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    //@IBOutlet weak var detailDescription: UITextView!
    
    //@IBOutlet weak var detailTitle: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    var sentData1: String!
    var sentData2: String!
    var sentData3: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //detailTitle.text = sentData1
        detailImageView.image = UIImage(named: sentData2)
        //detailDescription.text = sentData3
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 200, 0)
        self.navigationItem.title = "My Report"
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

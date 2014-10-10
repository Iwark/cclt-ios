//
//  ViewController.swift
//  cclt
//
//  Created by Kohei Iwasaki on 10/9/14.
//  Copyright (c) 2014 Donuts. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Alamofire.request(CcltRoute.Summaries()).response {
            (request, response, data, error) in
            
            if let json = data as? NSData {
                let summaries = JSON(data: json)
                println(summaries[0]["title"])
            }
            println(request)
            println(response)
            println(error)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


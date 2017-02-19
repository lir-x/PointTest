//
//  ViewController.swift
//  PointTest
//
//  Created by Lir-x on 12.02.17.
//  Copyright © 2017 Lir-x. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var path: Path!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let point1 = CGPoint(x: 0, y: 0)
        let point2 = CGPoint(x: self.view.bounds.maxX, y: self.view.bounds.maxY)
        
        let node1 = Node(name: "A", position: point1)
        let node2 = Node(name: "B", position: point2)
        
        self.path = Path(first: node1, last: node2)
        
        let myView = ViewForNodes(frame: self.view.bounds, path: self.path)
        self.view.addSubview(myView)
        
        }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func test(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PointsTable") as! PointsDetailTableleViewControllerTableViewController
        vc.path = path
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//
//  PointsDetailTableleViewControllerTableViewController.swift
//  PointTest
//
//  Created by Lir-x on 16.02.17.
//  Copyright © 2017 Lir-x. All rights reserved.
//

import UIKit

class PointsDetailTableleViewControllerTableViewController: UITableViewController {
    
    var path: Path!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return path.allNodes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        self.customize(cell: cell, indexPath: indexPath)

        return cell
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "total distance: \(path.totalDistance)"
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let index1 = self.path.allNodes.index(of: self.path.firstNode),
            let index2 = self.path.allNodes.index(of: self.path.lastNode){
            if indexPath.row == index1 || indexPath.row == index2 {
                return false
            }
        }
        
        return true
    }
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.path.remove(node: self.path.allNodes[indexPath.row])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.beginUpdates()
            let indexPathForPreviousRow = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if let cell = tableView.cellForRow(at: indexPathForPreviousRow) {
                self.customize(cell: cell, indexPath: indexPathForPreviousRow)
            }
            let footer = tableView.footerView(forSection: indexPath.section)
            footer?.textLabel?.text = "total distance: \(path.totalDistance)"
            footer?.textLabel?.sizeToFit()
            
            tableView.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    func customize(cell: UITableViewCell, indexPath: IndexPath) {
        let node = self.path.allNodes[indexPath.row]
        let distanceToNextNode = self.path.distance[indexPath.row]
        
        let x = NSString(format: "%.2f", node.position.x)
        let y = NSString(format: "%.2f", node.position.y)
        
        cell.textLabel?.text = "\(node.name) position: \(x): \(y)"
        cell.detailTextLabel?.text = "Distance: \(distanceToNextNode)"
        if distanceToNextNode < 10 {
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let node = self.path.allNodes[indexPath.row]
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EditNodeVC") as! EditNodeViewController
        vc.node = node
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

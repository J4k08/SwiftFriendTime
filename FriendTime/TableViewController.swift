//
//  TableViewController.swift
//  FriendTime
//
//  Created by Jakob Haglöf on 2017-03-13.
//  Copyright © 2017 Jakob Haglöf. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var numberOfFriends : [Friend] = []
    var image : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfFriends = DatabaseController.getAllFriends()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
     
        numberOfFriends = DatabaseController.getAllFriends()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return numberOfFriends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        
        if let name = numberOfFriends[indexPath.row].firstName {
            
            cell.firstNameLabel.text = name
        }
        if let surName = numberOfFriends[indexPath.row].surName {
            cell.surNameLabel.text = surName
        }
        
        
        
        let nameOfPerson = "\(numberOfFriends[indexPath.row].firstName!)\(numberOfFriends[indexPath.row].surName!)"
        
        print(nameOfPerson)
        
        let path = CameraController.imagePath(nameOfImage: nameOfPerson)
        
        let recievedImage = CameraController.getPicture(imagePath: path)
        
        cell.profileImage.image = recievedImage
        
        
        //let recievedImage = CameraController.getPicture(imagePath: path)
        
        //cell.profileImage.image = recievedImage
        

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            
            DatabaseController.removeFriend(firstName: numberOfFriends[indexPath.row].firstName!, surName: numberOfFriends[indexPath.row].surName!)
            
            //numberOfFriends.remove(at: indexPath.row)
            
            numberOfFriends = DatabaseController.getAllFriends()
            
            
            
           DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let cell = sender as? CustomTableViewCell{
            
            let clickedCell = segue.destination as! FriendViewController
            
            clickedCell.firstNameOfFriend = cell.firstNameLabel.text!
            clickedCell.surNameOfFriend = cell.surNameLabel.text!
            
        }
    
    }
    

}
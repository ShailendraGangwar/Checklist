//
//  CheckListViewController.swift
//  CheckList
//
//  Created by Shailendra Gangwar on 24/10/18.
//  Copyright © 2018 Shailendra Gangwar. All rights reserved.
//

import UIKit

class CheckListViewController: UIViewController {

    // MARK: - IBOutlets
    // MARK: -
    
    //Tableview for showing item added to be purchased from grocery store.
    @IBOutlet weak var checkListTableView: UITableView!
    
    //Button to add item in list
    @IBOutlet weak var addItemButton: UIButton!
    
    //text field to enter item
    @IBOutlet weak var addItemTextField: UITextField!
    // MARK: - Variables
    // MARK: -
    
    ///Array list with item to be purchased
    var checkListArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting datasource and delegate for tableview
        self.checkListTableView.delegate = self
        self.checkListTableView.dataSource = self
        self.getCheckListFromUserDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addItemToList(_ sender: Any) {
        let itemEntered = self.addItemTextField.text!
        //Adding item to list only if there is text in text field
        if itemEntered.count > 0 {
            self.checkListArray.add(itemEntered)
            self.checkListTableView.reloadData()
            self.addItemTextField.text = ""
            self.saveListToUserDefaults()
        }
    }
    
    //Saving list to Userdefault
    func saveListToUserDefaults() {
        let kUserDefault = UserDefaults.standard
        let checkListData = NSKeyedArchiver.archivedData(withRootObject: self.checkListArray)
        kUserDefault.set(checkListData, forKey: "checkListArray")
        kUserDefault.synchronize()
    }
    
    //Getting list to Userdefault
    func getCheckListFromUserDefaults() {
        let kUserDefault = UserDefaults.standard
        let checkListData = kUserDefault.object(forKey: "checkListArray") as? NSData
        if let checkListData = checkListData {
            self.checkListArray = (NSKeyedUnarchiver.unarchiveObject(with: checkListData as Data) as? NSMutableArray)!
        }
    }
}



// MARK: - UITableViewDataSource
// MARK: -

extension CheckListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StringConstants.checkListTableViewCell, for: indexPath)
        let currentItem = self.checkListArray[indexPath.row] as? String
        cell.textLabel?.text = currentItem
        return cell
    }
}

// MARK: - UITableViewDelegate
// MARK: -

extension CheckListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MathConstants.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= 0 && indexPath.row < self.checkListArray.count {
            self.checkListArray.removeObject(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveListToUserDefaults()
        }
    }
}


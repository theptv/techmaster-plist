//
//  ViewController.swift
//  Plist
//
//  Created by Lucio Pham on 10/30/17.
//  Copyright © 2017 Lucio Pham. All rights reserved.
//

import UIKit

struct User {
  var name: String
  var dob: String
  var profileImage: UIImage? {
    return UIImage.init(named: "\(name)")
  }
  
  init(_ name: String, dob: String) {
    self.name = name
    self.dob = dob
  }
}


class ViewController: UIViewController {
  
  @IBOutlet weak var usersTableView: UITableView!
  
  fileprivate let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
  
  fileprivate lazy var documentDirURL = URL.init(fileURLWithPath: self.documentDirectory)
  fileprivate let fileManager = FileManager.default
  
  fileprivate var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    setupTableView()
    loadUserFromBundlePlist()
  }
  
  fileprivate func setupTableView() {
    usersTableView.dataSource = self
    usersTableView.delegate = self
    usersTableView.register(UINib.init(nibName: "UserProfileCell", bundle: nil), forCellReuseIdentifier: "UserProfileCell")
  }
  
  
  // Create plist
  @IBAction func addMoreUser(_ sender: UIBarButtonItem) {
    insertUserIntoPlist()
    usersTableView.reloadData()
  }
  
  // Remove data from plist
  func removeUserFromPlist(_ index: Int) {
    users.remove(at: index)
  }
  
  // Load data from plist
  
  fileprivate func parsingPlist(_ urlDocument: URL) {
    guard let plistData = try? Data.init(contentsOf: URL.init(fileURLWithPath: urlDocument.path)) else { return }
    
    guard let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else { return }
    guard let resultArray = result!["Users"] as? [[String: String]] else { return }
    
    for userInformation in resultArray {
      let user = User.init(userInformation["userName"]!, dob: userInformation["dob"]!)
      users.append(user)
    }
  }
  
  func loadUserFromBundlePlist() {
    let urlDocument = documentDirURL.appendingPathComponent("DataUser.plist")
    
    if !fileManager.fileExists(atPath: urlDocument.path) {
      if let bundleURL = Bundle.main.path(forResource: "DataUser", ofType: "plist") {
        try? fileManager.copyItem(atPath: bundleURL, toPath: urlDocument.path)
        parsingPlist(urlDocument)
      }
    } else {
      parsingPlist(urlDocument)
    }
  }
  
  // Insert data into plist
  func insertUserIntoPlist() {
    let newUser = User.init("Lucio", dob: "15-5-1994")
    users.insert(newUser, at: 0)
    usersTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
    updatePlistFile()
  }
  
  
  // Function update Plist File after update user's datasource
  fileprivate func updatePlistFile() {
    let urlDocument = documentDirURL.appendingPathComponent("DataUser").appendingPathExtension("plist")
    var newUsersArray = [[String: String]]()
    for user in users {
      let pureUser = ["userName":user.name, "dob": user.dob, "profileImage":user.name]
      newUsersArray.append(pureUser)
    }
    
    if fileManager.fileExists(atPath: urlDocument.path) {
      try? fileManager.removeItem(at: urlDocument)
      let newDataUser = ["Users": newUsersArray] as NSMutableDictionary
      newDataUser.write(to: urlDocument, atomically: true)
    }
  }
  
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let userProfileCell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell", for: indexPath) as? UserProfileCell else { return UITableViewCell() }
    
    let user = users[indexPath.row]
    
    userProfileCell.user = user
    
    return userProfileCell
  }
}

extension ViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 65.0
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      removeUserFromPlist(indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
      updatePlistFile()
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
}

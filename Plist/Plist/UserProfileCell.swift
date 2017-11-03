//
//  UserProfileCell.swift
//  Plist
//
//  Created by Lucio Pham on 10/30/17.
//  Copyright © 2017 Lucio Pham. All rights reserved.
//

import UIKit

class UserProfileCell: UITableViewCell {
  
  @IBOutlet weak var userProfileImageView: UIImageView!
  @IBOutlet weak var userProfileNameLabel: UILabel!
  @IBOutlet weak var userProfileDOBLabel: UILabel!
  
  var user: User? {
    didSet{
      guard let user = user else { return }
      userProfileNameLabel.text = user.name
      userProfileDOBLabel.text = user.dob
      userProfileImageView.image = user.profileImage
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    configureCellUI()
  }
  
  fileprivate func configureCellUI() {
    userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.width / 2.0
    userProfileImageView.clipsToBounds = true
  }
  
}

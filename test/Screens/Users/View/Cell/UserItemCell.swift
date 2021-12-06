//
//  UserItemCell.swift
//  test
//
//  Created by Admin on 03/12/2021.
//

import UIKit
import Kingfisher

class UserItemCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var htmlURLLabel: UILabel!
    
    var data: UserItemViewModel? {
        didSet {
            loginLabel.text = data?.login
            htmlURLLabel.text = data?.htmlURL
            
            guard let avatar = data?.avatar, let avatarURL = URL(string: avatar) else { return }
            avatarImageView.kf.setImage(with: avatarURL, options: [.transition(.fade(0.2))])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageView.layer.cornerRadius = 40
        avatarImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        loginLabel.text = nil
        htmlURLLabel.text = nil
    }
}

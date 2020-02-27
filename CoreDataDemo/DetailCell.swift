//
//  DetailCell.swift
//  CoreDataDemo
//
//  Created by Sky Pro on 26/02/20.
//  Copyright © 2020 Sky Pro. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    // MARK: - Properties
    static let reuseIdentifier = "OrderCell"
    
    // MARK: -
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblOrder: UILabel!
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

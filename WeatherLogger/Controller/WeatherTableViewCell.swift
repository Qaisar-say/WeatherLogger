//
//  WeatherTableViewCell.swift
//  WeatherLogger
//
//  Created by Qaisar Rizwan on 1/14/20.
//  Copyright © 2020 Qaisar Rizwan. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet var temprature: UILabel!
    @IBOutlet var country: UILabel!
    @IBOutlet var city: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data:WeatherData) {
        temprature.text = String("\(data.temprature)°C")
        country.text = data.country
        city.text = data.city
        dateLabel.text = data.date
    }
}

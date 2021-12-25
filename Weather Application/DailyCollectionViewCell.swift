//  DailyCollectionViewCell.swift
//  Weather Application

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
        
    func daySetting(day: String, image: UIImage, min: String, max: String){
            dayLabel.text = day
            weatherImage.image = image
            minLabel.text = "min: \(min)°"
            maxLabel.text = "max: \(max)°"
        }
}

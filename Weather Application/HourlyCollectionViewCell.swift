//  HourlyCollectionViewCell.swift
//  Weather Application

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
      
    func hourSetting(degree: String, hour: String){
         degreeLabel.text = "\(degree)°"
         hourLabel.text = hour
      }
}

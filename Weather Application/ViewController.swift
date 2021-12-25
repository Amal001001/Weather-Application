//  ViewController.swift
//  Weather Application

import UIKit

class ViewController: UIViewController {
    
    ////////////// ui
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var generalWatherLabel: UILabel!
    @IBOutlet weak var weatherDetailsLabel: UILabel!

    @IBOutlet weak var hourlyCV: UICollectionView!
    @IBOutlet weak var dailyCV: UICollectionView!
    
    /////////// variables
    var current: Current? = nil
    var weather: WeatherElement? = nil
    var hoursList: [Current]? = []
    var daysList: [Daily]? = []
    var wDescription = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hourlyLayout = UICollectionViewFlowLayout()
        hourlyLayout.scrollDirection = .horizontal
        hourlyLayout.itemSize = CGSize(width: hourlyCV.frame.size.width/4, height: hourlyCV.frame.size.height)
        hourlyCV.collectionViewLayout = hourlyLayout
        hourlyCV.dataSource = self
        
        let dailyLayout = UICollectionViewFlowLayout()
        dailyLayout.itemSize = CGSize(width: dailyCV.frame.size.width/4, height: dailyCV.frame.size.height)
        dailyLayout.scrollDirection = .horizontal
        dailyCV.collectionViewLayout = dailyLayout
        dailyCV.dataSource = self
        
        showData()
    }
    
    func showData(){
        wModel.getAllData(completionHandler: {
            data, response, error in
                    // We get data, response, and error back. Data contains the JSON data,
                    // Response contains the headers and other information about the response,
                    // and Error contains an error if one occured
                    
                    // A "Do-Try-Catch" block involves a try statement with some catch block for catching any errors thrown by the try statement.
                    do {
                        let result = try JSONDecoder().decode(Weather.self, from: data!)
                        
                        self.current = result.current
                        self.weather = (self.current?.weather[0])!
                        self.daysList = result.daily
                        
                        for hour in result.hourly{
                              if self.hoursList?.count == 24{
                                 break
                              }else{
                                  self.hoursList?.append(hour)}
                        }
                        
                        guard let weatherDescription = self.weather else { return }
                        self.wDescription = "\(weatherDescription)"
                        
                           DispatchQueue.main.async {
                               // Do something here to update the UI
                               self.cityLabel.text = result.timezone
                               self.generalWatherLabel.text = "\(String(describing: weatherDescription.main.rawValue))"
                               self.weatherDetailsLabel.text! = "Temp: \(result.current.temp)°\nPressure: \(result.current.pressure)\nHumidity: \(result.current.humidity)\nWind speed: \(result.current.windSpeed)"
                               self.weatherMain()
                               
                               self.hourlyCV.reloadData()
                               self.dailyCV.reloadData()
                               
                               print(self.weatherDetailsLabel.text!)
                               print(self.hoursList?.count)
                           }
                        
                     }catch{
                            print(error)
                     }
        })
    }
    
    func weatherMain(){
        var dayImage = UIImage(named: "sunny")
        
        if wDescription == "Rain"{
            dayImage = UIImage(named: "rainy")
        }else if wDescription == "Clouds"{
            dayImage = UIImage(named: "cloudy")
        }
        
        currentWeatherImage.image = dayImage
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == dailyCV{
           return daysList?.count ?? 0
        }else{
            return hoursList?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == hourlyCV{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourCell", for: indexPath) as! HourlyCollectionViewCell
            
            cell.hourSetting(degree: "\(hoursList![indexPath.row].temp)", hour: formatingdate(timestamp: hoursList?[indexPath.row].dt, format: "h a"))

            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath) as! DailyCollectionViewCell
            
            guard let day = daysList?[indexPath.row] else { return cell }
            var dayImage = UIImage(named: "sunny")
        
            if day.weather[0].main.rawValue == "Rain"{
                dayImage = UIImage(named: "rainy")
            }else if day.weather[0].main.rawValue == "Clouds"{
                dayImage = UIImage(named: "cloudy")
            }
            
            cell.daySetting(day: formatingdate(timestamp: day.dt, format: "EE"), image: dayImage!, min: "\(day.temp.min)", max: "\(day.temp.max)")
            return cell
        }
    }
        
    /////////////UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return CGFloat(5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
    }
    ////////////////UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        if collectionView == dailyCV{
            return CGSize(width: dailyCV.frame.size.width, height: dailyCV.frame.size.height)
        }else{
            return CGSize(width: hourlyCV.frame.size.width, height: hourlyCV.frame.size.width)
        }
    }
    //////////
    func formatingdate(timestamp: Int?, format: String)-> String{
            let date = Date(timeIntervalSince1970: Double(timestamp ?? 0))
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: date)
        }
}

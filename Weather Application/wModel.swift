//  wModel.swift
//  Weather Application

import Foundation

class wModel {
    //This function will allow the ViewController that calls this method to dictate what runs upon completion
    static func getAllData(completionHandler: @escaping(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        // Specify the url that we will be sending the GET Request to
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=33.44&lon=-94.04&appid=50474509880cf98e6416c170b12c3ded")
        // Create a URLSession to handle the request tasks
        let session = URLSession.shared
        // Create a "data task" which 'll request some data from a URL & then run the completion handler that we're passing into the getAllTasks func
        let task = session.dataTask(with: url!, completionHandler: completionHandler)
        // This is the line that makes the request that we set up above
        task.resume()
    }
    
}

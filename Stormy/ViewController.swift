//
//  ViewController.swift
//  Stormy
//
//  Created by Taylor Martin on 12/15/15.
//  Copyright © 2015 Taylor Martin. All rights reserved.
//

import UIKit
import Crashlytics

class ViewController: UIViewController {
    
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHumidityLabel: UILabel?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentWeatherSummary: UILabel?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    private let forecastAPIKey = "9466d082aa862b4002a3342da46bb71b"
    let coordinate: (lat: Double, long: Double) = (37.8267, -122.423)
    let transBlue = UIColor(red: 116/255.0, green: 201/255.0, blue: 1, alpha: 0.75)
    let solidBlue = UIColor(red: 116/255.0, green: 201/255.0, blue: 1, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CLSLogv("Username %@", getVaList(["tmartin"]))
        retrieveWeatherForecast()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func refreshWeather() {
        toggleRefreshAnimation(true)
        delay(1) {
            self.retrieveWeatherForecast()
        }
    }
    
    func toggleRefreshAnimation(on: Bool) {
        refreshButton?.hidden = on
        if on {
            activityIndicator?.startAnimating()
            view.backgroundColor = transBlue
            CLSLogv("crashed at line %d", getVaList([52]))
            Crashlytics.sharedInstance().crash()
        } else {
            activityIndicator?.stopAnimating()
            view.backgroundColor = solidBlue
        }
    }
    
    func retrieveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        
        forecastService.getForecast(coordinate.lat, lon: coordinate.long) {
            (let currently) in
            if let currentWeather = currently {
                dispatch_async(dispatch_get_main_queue()) {
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    if let humidity = currentWeather.humidity {
                        self.currentHumidityLabel?.text = "\(humidity)%"
                    }
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                    }
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    if let summary = currentWeather.summary {
                        self.currentWeatherSummary?.text = summary
                    }
                    self.toggleRefreshAnimation(false)
                }
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}

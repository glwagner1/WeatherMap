//
//  ViewController.swift
//  WeatherMap
//
//  Created by Gary Wagner on 5/3/17.
//  Copyright © 2017 Gary Wagner. All rights reserved.
//

/*
 http://api.openweathermap.org/data/2.5/weather?q=Richardson,tx&appid=96627ebc10368971763c0e602f9633f7
 
 {"coord":{"lon":-96.73,"lat":32.95},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":295.84,"pressure":1009,"humidity":53,"temp_min":294.15,"temp_max":297.15},"visibility":16093,"wind":{"speed":8.7,"deg":330,"gust":13.4},"clouds":{"all":75},"dt":1493846100,"sys":{"type":1,"id":2592,"message":0.0315,"country":"US","sunrise":1493811386,"sunset":1493860282},"id":4722625,"name":"Richardson","cod":200}
 
 */
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var stateName: UITextField!
    @IBOutlet weak var weatherInfo: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    
    // MARK: - Variable Properties
    
    var weatherData: WeatherData?
    
    fileprivate enum Item: Int {
        case description
        case temperature
        case humidity
        case pressure
        case degrees
        case speed
        case gust
        case lastEntry
        
        var title: String {
            
            switch self {
            case .description:
                return "Current Weather"
            case .temperature:
                return "Temperature"
            case .humidity:
                return "Humidity"
            case .pressure:
                return "Baro Pressure"
            case .degrees:
                return "Wind Direction"
            case .speed:
                return "wind Speed"
            case .gust:
                return "Gust"
            case .lastEntry:
                return ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.weatherInfo.dataSource = self
        self.weatherInfo.delegate = self
        self.infoLabel.text = NSLocalizedString("enterData", comment: "")
        self.weatherIcon.contentMode = .scaleAspectFit
        
        // is there a saved city and state?
        if let cityName = UserDefaults.standard.string(forKey: "cityName"),
            let stateCode = UserDefaults.standard.string(forKey: "stateCode") {
            // request weather information
            self.cityName.text = cityName
            self.stateName.text = stateCode
            self.fetchWeatherData(cityName: cityName, stateCode: stateCode)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func getCurrentWeather(_ sender: Any) {
        // edit input fields
        self.infoLabel.text = ""
        guard let cityName = self.cityName.text, cityName.characters.count > 3
        else {
            self.infoLabel.text = NSLocalizedString("cityInvalid", comment: "")
            return
        }
        guard let stateCode = self.stateName.text?.lowercased(), stateCode.characters.count == 2
        else {
            self.infoLabel.text = NSLocalizedString("stateInvalid", comment: "")
            return
        }
        self.stateName.text = stateCode
        
        // request weather information
        self.fetchWeatherData(cityName: cityName, stateCode: stateCode)
        // update current weather
    }
    
 func fetchWeatherData(cityName: String, stateCode: String) {
        
    // Send HTTP GET Request
    
    // Define server side script URL
    let requestUrl = "http://api.openweathermap.org/data/2.5/weather"
    let appid = "96627ebc10368971763c0e602f9633f7"
    
    // Add one parameter
    var urlWithParams = requestUrl + "?q=\(cityName),\(stateCode)&appid=\(appid)"
    // remove spaces from the URL
    let components = urlWithParams.components(separatedBy: .whitespaces)
    urlWithParams = components.joined(separator: "")

    // Create NSURL object
    let myUrl = NSURL(string: urlWithParams);
    
    // Creaste URL Request
    let request = NSMutableURLRequest(url:myUrl! as URL);
    
    // Set request HTTP method to GET. It could be POST as well
    request.httpMethod = "GET"
    
    // Excute HTTP Request
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        // Check for error
        if error != nil
        {
            print("error=\(error)")
            return
        }
        
        // Print out response string
        //let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        //print("responseString = \(responseString)")
        
        
        // Convert server json response to NSDictionary
        do {
            if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                
                // Print out dictionary
                print(convertedJsonIntoDict)
                
                // Get value by key
                let returnCode = convertedJsonIntoDict["cod"] as! Int64
                print(returnCode)
                if returnCode == 200 {
                    // process good return
                    self.weatherData = WeatherData(dictionary: convertedJsonIntoDict as? [String : Any])
                    // save current selection
                    UserDefaults.standard.set(self.weatherData?.name, forKey: "cityName")
                    UserDefaults.standard.set(stateCode, forKey: "stateCode")
                
                    if let icon = self.weatherData?.icon, let iconURL = URL(string: "http://openweathermap.org/img/w/\(icon).png") {
                        self.downloadImage(url: iconURL)
                    }
                    DispatchQueue.main.async {[weak self] in
                        self?.cityName.text = self?.weatherData?.name
                        self?.stateName.text = stateCode
                        self?.weatherInfo.reloadData()
                    }
                }
                else {
                    self.weatherData = nil
                    DispatchQueue.main.async {[weak self] in
                        if let message = convertedJsonIntoDict["message"] as? String {
                            self?.infoLabel.text = message
                            self?.weatherInfo.reloadData()
                        }
                    }
                    
                }
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    task.resume()
    
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { () -> Void in
                self.weatherIcon.image = UIImage(data: data)
            }
        }
    }

}

//MARK: - UITableViewDataSource methods

extension ViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let _ = self.weatherData else {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let _ = self.weatherData else {
            return 0
        }
        return Item.lastEntry.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherCell

        let item = Item(rawValue: indexPath.item)!
        cell.titleLabel.text = item.title
        
        switch item {
        case .description:
            cell.dataLabel.text = weatherData?.description
        case .temperature:
            cell.dataLabel.text = "\(weatherData!.temperature)"
        case .humidity:
            cell.dataLabel.text = "\(weatherData!.humidity)"
        case .pressure:
            cell.dataLabel.text = "\(weatherData!.pressure)"
        case .degrees:
            cell.dataLabel.text = "\(weatherData!.degrees)"
        case .speed:
            cell.dataLabel.text = "\(weatherData!.speed)"
        case .gust:
            cell.dataLabel.text = "\(weatherData!.gust)"
        case .lastEntry:
            break
        }
        
        return cell
    }
    
}

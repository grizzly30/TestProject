//
//  ForecastViewController.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 18.6.21..
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    
    var sections: [String] = []
    var weatherDataDictionary: [String: [CurrentWeatherModel]] = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = WeatherData.shared.fiveWeatherData?.city.name
        NotificationCenter.default.addObserver(self, selector: #selector(weatherDataDidChange), name: Notification.Name("fiveWeatherDataDidChange"), object: nil)


        // Setup table view delegates
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
        weatherTableView.rowHeight = UITableView.automaticDimension
        weatherTableView.estimatedRowHeight = 100
        
        // Register nib view for sections
        let nib = UINib(nibName: "ForecastSectionView", bundle: nil)
        weatherTableView.register(nib, forHeaderFooterViewReuseIdentifier: "forecastSectionView")
        
        sections = WeatherData.shared.sections
    }
    
    @objc func weatherDataDidChange() {
        DispatchQueue.main.async {
            self.weatherTableView.reloadData()
        }
    }
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "forecastSectionView") as? ForecastSectionView else { return UIView() }
        let sectionDate = sections[section]
        view.sectionTitle.text = UtilityHelper.isDateToday(date: sectionDate) ? "TODAY" : sectionDate.dateFormater(inputFormat: "MM/dd/yyyy", outputFormat: "EEEE").uppercased()

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = WeatherData.shared.sections
        weatherDataDictionary = WeatherData.shared.createWeatherdataDictonary()
        return weatherDataDictionary[sections[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherCell,
            let section = weatherDataDictionary[sections[indexPath.section]]
            else { return UITableViewCell() }
        
        /* Since we know that API returns first element
         in range that contains current time
         we are coloring only frist cell border in the forst section
         */
        
        if
            indexPath.section == 0,
            indexPath.row == 0 {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.blue.cgColor
        }
        
        let weatherModel = section[indexPath.row]
        cell.weatherImage.image = UtilityHelper.unwrapImage(with: weatherModel.weather[0].icon)
        cell.timeLabel.text = weatherModel.dt_txt.dateFormater(outputFormat: "HH:mm")
        cell.weatherLabel.text = weatherModel.weather[0].description
        cell.temperatureLabel.text = "\(String(round(weatherModel.main.temp))) °C "
        
        return cell
    }
}

class WeatherCell: UITableViewCell {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func prepareForReuse() {
        layer.borderColor = UIColor.clear.cgColor
    }
}

class ForecastSectionView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var sectionTitle: UILabel!
}

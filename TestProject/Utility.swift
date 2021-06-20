//
//  Utility.swift
//  TestProject
//
//  Created by Mihailo Jovanovic on 19.6.21..
//

import UIKit

class UtilityHelper {
    static func unwrapImage(with name: String) -> UIImage {
        guard let image = UIImage(named: name) else { return UIImage(named: "01d")!}
        return image
    }
    
    static func compareDates(first: String, second: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"

        guard
            let firstDate = dateFormatter.date(from: first),
            let secondDate = dateFormatter.date(from: second)
        else { return false }
        
        return Calendar.current.isDate(firstDate, equalTo: secondDate, toGranularity: .day)
    }
    
    static func isDateToday(date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        guard let formattedDate = dateFormatter.date(from: date) else { return false }
        return Calendar.current.isDateInToday(formattedDate)
    }
}

extension String {
    func dateFormater(inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String = "MM/dd/yyyy") -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = inputFormat
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = outputFormat

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}

protocol LoadingViewDelegate {
    func presentLoader(loader: UIViewController)
    func hideLoader(loader: UIViewController)
}

extension UIViewController: LoadingViewDelegate {
    // MARK: - LoadingViewDelegate methods
    
    func presentLoader(loader: UIViewController) {
        loader.modalPresentationStyle = .overFullScreen
        loader.modalTransitionStyle = .crossDissolve
               
        present(loader, animated: true, completion: nil)
    }
    
    func hideLoader(loader: UIViewController) {
        DispatchQueue.main.async {
            loader.dismiss(animated: true)
        }
    }
    
    func presentOKAlert(with title: String = "TestProject", message: String) {
        defer {
            // Delayed for 1s in order to remove the loader first
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.present(alert, animated: true)
            }
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

    }
}

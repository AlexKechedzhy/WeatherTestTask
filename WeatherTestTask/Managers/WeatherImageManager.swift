//
//  WeatherImageManager.swift
//  WeatherTestTask
//
//  Created by Alex173 on 25.09.2022.
//

import UIKit

final class WeatherImageManager {
    
    public static let instance = WeatherImageManager()
    
    func getWeatherImage(conditionId: Int) -> UIImage? {
        switch conditionId {
        case 200...299:
            return R.image.icon_white_day_thunder()
        case 300...399:
            return R.image.icon_white_day_rain()
        case 500...599:
            return R.image.icon_white_day_shower()
        case 600...699:
            return UIImage(systemName: "cloud.snow")
        case 700...799:
            return  UIImage(systemName:  "cloud.fog")
        case 800:
            return R.image.icon_white_day_bright()
        case 801...810:
            return R.image.icon_white_day_cloudy()
        default:
            return R.image.icon_white_day_cloudy()
        }
    }
        func getWindDirectionImage(windDirection: Int) -> UIImage? {
            switch windDirection {
            case 0...22:
                return R.image.icon_wind_s()
            case 23...67:
                return R.image.icon_wind_ws()
            case 68...112:
                return R.image.icon_wind_w()
            case 113...157:
                return R.image.icon_wind_wn()
            case 158...202:
                return R.image.icon_wind_n()
            case 203...247:
                return R.image.icon_wind_ne()
            case 248...292:
                return R.image.icon_wind_e()
            case 293...337:
                return R.image.icon_wind_se()
            case 337...359:
                return R.image.icon_wind_s()
            default:
                return R.image.icon_wind_s()
            }
        }
}

//
//  Connectivity.swift
//  WeatherLogger
//
//  Created by Qaisar Rizwan on 1/21/20.
//  Copyright © 2020 Qaisar Rizwan. All rights reserved.
//

import Foundation
import Alamofire


class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

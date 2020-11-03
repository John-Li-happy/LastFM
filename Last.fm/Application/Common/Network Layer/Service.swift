//
//  Service.swift
//  Last.fm
//
//  Created by Shawn Li on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import Alamofire
import Foundation
import SwiftHash

class Service {
    
    static let `shared` = Service()
    
    private init() {}
    
    private func getAppSig(userName: String, password: String) -> String {
        let apiSig = MD5("api_key\(AppConstants.LastFMAPI.apiKey)method\(AppConstants.LastFMAPIMethod.getMobileSession)password\(password)username\(userName)\(AppConstants.LastFMAPI.sharedSecret)")
        return apiSig
    }
    
    func postUserAuthentication(userName: String, password: String, handler: @escaping (String?, Bool) -> Void) {
        var loginStatus = false
        let apiSig = getAppSig(userName: userName, password: password)
        let para = [
            "method": AppConstants.LastFMAPIMethod.getMobileSession,
            "username": userName,
            "password": password,
            "api_key": AppConstants.LastFMAPI.apiKey,
            "api_sig": apiSig,
            "format": "json"
        ]
        
        AF.request(AppConstants.LastFMAPI.apiRootUrl, method: .post, parameters: para).responseJSON { response in
            if let json = response.value as? [String: Any],
                let session = json["session"] as? [String: Any],
                let sessionKey = session["key"],
                let urlResponse = response.response,
                (200...299).contains(urlResponse.statusCode) {
                loginStatus = true
                handler(sessionKey as? String, loginStatus)
            } else {
                handler(nil, loginStatus)
            }
        }
    }
    
    func fetchData(url: String, parameters: [String: String], completionHandler: @escaping (Data?, Error?) -> Void) {
        guard var components = URLComponents(string: url) else { return }
        components.queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        
        guard let completeURL = components.url else { return }
        
        let task = URLSession.shared.dataTask(with: completeURL) { data, response, error in
            guard error == nil else { completionHandler(nil, error); return }
            let success = true
            guard let httpResponse = response as? HTTPURLResponse else { return }
            if success == (200 ..< 399).contains(httpResponse.statusCode) {
                completionHandler(data, nil)
            } else {
                let failResponse = NSError(domain: "Failed to get the response! Please check your authorization", code: httpResponse.statusCode, userInfo: nil)
                completionHandler(nil, failResponse)
            }
        }
        
        task.resume()
    }
}

// *** For future use when API become correctly
//        urlComponents?.queryItems = [
//            URLQueryItem(name: "method", value: "chart.getTopTracks"),
//            URLQueryItem(name: "api_key", value: "10c7415af33eaa8126c57e3046b62ed8"),
//            URLQueryItem(name: "format", value: "json")
//        ]

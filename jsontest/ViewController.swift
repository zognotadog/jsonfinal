//
//  ViewController.swift
//  jsontest
//
//  Created by Alex Asher on 23/07/2019.
//  Copyright © 2019 Appsher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        guard let url = URL(string: "https://placeumlocations.s3-eu-west-1.amazonaws.com/locations.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                /*here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
 */             //var locations = [Locations]()
                let decoder = JSONDecoder()
                var locations: [Locations]
                locations = try decoder.decode(Array<Locations>.self, from: dataResponse)
                
                print(locations.count)
                //Output - EMT
            } catch { print(error) }
            
        }
        task.resume()
        
    }
}
/*
struct Location: Codable {
    
    let locTitle: String
    let description: String
    let latitude: Double
    let longitude: Double
    let recordings: [Recordings]
    
}

struct Recordings: Codable {
    
    let category: String
    let audio: [Recording]
    
}

struct Recording: Codable {
    
    let recTitle: String
    let recDesc: String
    let recURL: URL
    
}

*/
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let locations = try? newJSONDecoder().decode(Locations.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.locationTask(with: url) { location, response, error in
//     if let location = location {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - Location
struct Location: Codable {
    let locTitle, locationDescription: String
    let latitude, longitude: Double
    let recordings: [Recording]
    
    enum CodingKeys: String, CodingKey {
        case locTitle
        case locationDescription = "description"
        case latitude, longitude, recordings
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.recordingTask(with: url) { recording, response, error in
//     if let recording = recording {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Recording
struct Recording: Codable {
    let category: String?
    let audio: [Audio]
    let name: String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.audioTask(with: url) { audio, response, error in
//     if let audio = audio {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Audio
struct Audio: Codable {
    let recTitle, recDesc: String
    let recURL: String
}

typealias Locations = [Location]

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func locationsTask(with url: URL, completionHandler: @escaping (Locations?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


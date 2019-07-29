// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let locations = try? newJSONDecoder().decode(Locations.self, from: jsonData)

//
// To read values from URLs:
//
   

import Foundation

class LocationParser {
    
    typealias completionHandler = (_success: Bool, _locations: Locations)
    
    static func getLocations(completion: @escaping (Locations) -> ()) {
        var locationsArray: Locations?
        let url = URL(string: "https://placeumlocations.s3-eu-west-1.amazonaws.com/locations.json")
        print("getting locations")
        let task = URLSession.shared.locationsTask(with: url!) { location, response, error in
            if let locationData = location {
                completion(locationData)
            } else if let error = error {
                print(error)
            } else if let response = response {
                print(response)
            }
        }
        task.resume()
        
        //Returns this but empty because returns before URLSession has completed
        
    }
}
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

// MARK: - Recording
struct Recording: Codable {
    let category: String
    let audio: [Audio]
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

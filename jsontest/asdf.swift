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
class Location: Codable {
    let locTitle, locationDescription: String
    let latitude, longitude: Double
    let recordings: [Recording]
    
    enum CodingKeys: String, CodingKey {
        case locTitle
        case locationDescription = "description"
        case latitude, longitude, recordings
    }
    
    init(locTitle: String, locationDescription: String, latitude: Double, longitude: Double, recordings: [Recording]) {
        self.locTitle = locTitle
        self.locationDescription = locationDescription
        self.latitude = latitude
        self.longitude = longitude
        self.recordings = recordings
    }
    
    static func getLocations(completion: @escaping (([Location])->())) {
        guard let url = URL(string: "https://placeumlocations.s3-eu-west-1.amazonaws.com/locations.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                let decoder = JSONDecoder()
                var locations: Locations
                locations = try newJSONDecoder().decode(Locations.self, from: dataResponse)
                
                print(locations.count)
                //Output - EMT
            } catch { print(error) }
            
        }
        task.resume()
        
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
class Recording: Codable {
    let category: String
    let audio: [Audio]
    
    init(category: String, audio: [Audio]) {
        self.category = category
        self.audio = audio
    }
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
class Audio: Codable {
    let recTitle, recDesc: String
    let recURL: String
    
    init(recTitle: String, recDesc: String, recURL: String) {
        self.recTitle = recTitle
        self.recDesc = recDesc
        self.recURL = recURL
    }
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

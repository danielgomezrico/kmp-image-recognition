//
//  OCRReader.swift
//  iosApp
//
//  Created by Juan del Valle on 21/07/24.
//  Copyright © 2024 orgName. All rights reserved.
//

import UIKit
import Vision

enum OCRError: Error {
    case cgImageParseError
    case errorGettingText
    case noTextFound
}

class OCRReader {
    static func recognizeText(in image: UIImage, completionHandler: @escaping (Result<[String], OCRError>) -> Void) {
        guard let cgImage = image.cgImage else {
            completionHandler(.failure(.cgImageParseError))
            return
        }
        
        var result: [String] = []
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { (request, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error)")
                    completionHandler(.failure(.errorGettingText))
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation], !observations.isEmpty else {
                    print("No text found")
                    completionHandler(.failure(.noTextFound))
                    return
                }
                
                for observation in observations {
                    guard let topCandidate = observation.topCandidates(1).first else {
                        continue
                    }
                    
                    result.append(topCandidate.string)
                    print("Recognized text: \(topCandidate.string)")
                }
                completionHandler(.success(result))
            }
        }
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error: \(error)")
        }
    }
}

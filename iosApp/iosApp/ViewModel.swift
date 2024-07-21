//
//  ViewModel.swift
//  iosApp
//
//  Created by Juan del Valle on 21/07/24.
//  Copyright © 2024 orgName. All rights reserved.
//

import SwiftUI

@MainActor
final class ViewModel: ObservableObject {
    @Published private(set) var identifiedTexts: [String] = []
    @Published private(set) var errorMessage: String?
    
    func getTextsFromImage(image: UIImage) {
        OCRReader.recognizeText(in: image) { [weak self] result in
            switch result {
            case .success(let texts):
                self?.identifiedTexts = texts
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
}

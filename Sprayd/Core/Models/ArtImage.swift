//
//  ArtImage.swift
//  Sprayd
//
//  Created by User on 04.04.2026.
//

import Foundation
import SwiftData

@Model
final class ArtImage {
    var urlString: String
    @Transient var img: Data? = nil
    @Transient var date: Date = .now
    @Transient var timeStamp: TimeInterval = Date().timeIntervalSince1970
    @Transient var userId: UUID = UUID()

    init(
        img: Data? = nil,
        urlString: String = "",
        date: Date = .now,
        timeStamp: TimeInterval = Date().timeIntervalSince1970,
        userId: UUID = UUID()
    ) {
        self.img = img
        self.urlString = urlString
        self.date = date
        self.timeStamp = timeStamp
        self.userId = userId
    }
}

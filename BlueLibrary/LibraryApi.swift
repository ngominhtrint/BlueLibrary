//
//  LibraryApi.swift
//  BlueLibrary
//
//  Created by TriNgo on 9/18/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import Foundation

final class LibraryAPI {
    
    static let shared = LibraryAPI()
    
    private let persistencyManager = PersistencyManager()
    private let httpClient = HTTPClient()
    private let isOnline = false
    
    private init() {
        
    }
    
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(_ album: Album, at index: Int) {
        persistencyManager.addAlbum(album, at: index)
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(at index: Int) {
        persistencyManager.deleteAlbum(at: index)
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: "\(index)")
        }
    }
}

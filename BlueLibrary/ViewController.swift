//
//  ViewController.swift
//  BlueLibrary
//
//  Created by TriNgo on 9/18/17.
//  Copyright © 2017 CoderSchool. All rights reserved.
//

import UIKit

fileprivate enum Constants {
    static let CellIdentifier = "Cell"
}

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet var trashBarButtonItem: UIBarButtonItem!
    
    fileprivate var currentAlbumIndex = 0
    fileprivate var currentAlbumData: [AlbumData]?
    fileprivate var allAlbums = [Album]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allAlbums = LibraryAPI.shared.getAlbums()
        tableView.dataSource = self
        showDataForAlbum(at: currentAlbumIndex)
    }
    
    fileprivate func showDataForAlbum(at index: Int) {
        if index < allAlbums.count && index > -1 {
            let album = allAlbums[index]
            currentAlbumData = album.tableRepresentation
        } else {
            currentAlbumData = nil
        }
        
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let albumData = currentAlbumData else { return 0 }
        return albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier, for: indexPath)
        if let albumData = currentAlbumData {
            let row = indexPath.row
            cell.textLabel!.text = albumData[row].title
            cell.detailTextLabel!.text = albumData[row].value
        }
        return cell
    }
}


//
//  StorageVC.swift
//  LexiconFinal
//
//  Created by Alexi Kaland on 21.05.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation


final class StorageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        coreData.loadData(tableView: tableView)
    }
    
    private func TappingAnimation(button: UIButton){
        dismiss(animated: true, completion: {
            let scaleTransform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            button.transform = scaleTransform
            UIView.animate(withDuration: 0.2, delay: 0.1, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: [], animations: {
                button.transform = .identity
                button.alpha = 1
            }, completion: nil)})
    }
}


//MARK: Table View
extension StorageVC: TableViewMethods{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordBookCell", for: indexPath) as! wordBookCell
        cell.audioButtonOutlet.tintColor = UIColor.white
        let item = savedArray[indexPath.row]
        cell.word.text = item.word
        cell.def?.text = item.definition
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            context.delete(savedArray[indexPath.row])
            savedArray.remove(at: indexPath.row)
            coreData.saveData()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "xmark")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
}


extension StorageVC: savedAudioCellDelegate {
    func playButtonTapped(cell: wordBookCell, Button: UIButton ) {
        TappingAnimation(button: Button)
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            var player = AVPlayer()
            let item   = savedArray[indexPath.row]
            let url    = URL.init(string: item.audio!)
            let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
            player = AVPlayer(playerItem: playerItem)
            _ = AVPlayerLayer(player: player)
            // Perform sound with Silent mode on
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            player.play()
        }
    }
}



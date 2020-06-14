//
//  ViewController.swift
//  Lexicon
//
//  Created by Alexi Kaland on 26.04.2020.
//  Copyright © 2020 Aleksi Kalandia. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import CoreData


final class SearchVC: UIViewController{
    
    // MARK: Outlets & Vars
    @IBOutlet weak var tableView:       UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var SearchButton:    UIButton!
    @IBOutlet weak var SearchField:     UITextField!{
        didSet{ // Only english keyboard
            SearchField.keyboardType =  UIKeyboardType.alphabet
        }
    }
    @IBOutlet weak var WarningLabel:    UILabel!{
        didSet{
            WarningLabel.alpha = 0
            WarningLabel.font  = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    
    private var Result               = [ result.definitionPart, result.examplePart, result.audioPart ]
    private var alreadySearchedWord  = ""
    private var bookMarkedRow        = [Bool]()
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SearchField.delegate = self
        setupHideKeyboardOnTap()
        decoration()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // (bug fix) Update UI when deleting row in storage and switching screen back to SearchVC
        if Result[0].count != 0 {
            for (index, strings) in Result[0].enumerated() {
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: Names.Entity)
                request.returnsObjectsAsFaults = false
                do {
                    let result = try context.fetch(request)
                    
                    for data in result as! [NSManagedObject] {
                        if strings == (data.value(forKey: Names.defAttribute) as! String){
                            bookMarkedRow[index] = true
                        }else{
                            bookMarkedRow[index] = false
                        }
                    }
                } catch {
                    print("Failed")
                }
            }
            tableView.reloadData()
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: Search Button
    @IBAction func SearchAction(_ sender: UIButton) {
        TappingAnimation(button: SearchButton)
        // Loading animation
        let loading = NVActivityIndicatorView(frame: .zero, type: .semiCircleSpin, color: .white, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 55),
            loading.heightAnchor.constraint(equalToConstant: 55),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        loading.startAnimating()
        
        if ValidationService.ValidateWord(SearchField: SearchField, WarningLabel: WarningLabel) == false {
            loading.stopAnimating()
        }else{
            // If the word was previously searched
            if alreadySearchedWord == SearchField.text!{
                loading.stopAnimating()
                return
            }
            //Assigning current word
            self.alreadySearchedWord = self.SearchField.text!
            WarningLabel.alpha = 0
            setupHideKeyboardOnTap()
            //Nullifying previous result
            if Networking.apiCallFlow == true {
                for i in 0...2{
                    self.Result[i] = [String]()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
            //Making the Call
            Networking.apiCall(Word: SearchField.text!){ [weak self] Result in
                
                guard let self = self else { return }
                
                // Nullifying previously saved rows
                self.bookMarkedRow = [Bool]()
                
                // Nullifying previous result
                if Networking.apiCallFlow == false {
                    for i in 0...2{
                        self.Result[i] = [String]()
                    }
                }
                guard let Result = Result else {
                    DispatchQueue.main.async {
                        Animations.warningAnimation(Label: (self.WarningLabel)!, Text: "Search failed!")
                        loading.stopAnimating()
                    }
                    return
                }
                
                self.Result = Result
                
                // Generating new array based on current result
                let a = self.Result[0].count
                self.bookMarkedRow.append(contentsOf: Array(repeating: false, count: a))

                DispatchQueue.main.async {
                    loading.stopAnimating()
                    self.tableView.reloadData()
                }
            }
        }
    }
}


//MARK: TableView
extension SearchVC: TableViewMethods {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if Result[0] != [String]() && Result[1] != [String]() {
            return Result.count
        }else if Result[1] == [String]() { //When examples in the sentence = 0
            return Result.count - 1
        }else{
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView = Bundle.main.loadNibNamed(Names.SectionHeader, owner: self, options: nil)?.first as! customSectionHeaderView
        
        let sectionLabels      = ["Definition" , "Example in a sentence", "Pronunciation"]
        let sectionImages      = [UIImage(named: Names.DefinitionImage),
                                  UIImage(named: Names.ExampleImage),
                                  UIImage(named: Names.AudioImage)]
        
        func backgroundBlurr(i:Int) {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            headerView.Backk.addSubview(blurEffectView)
            headerView.sectionLabel.text = sectionLabels[i]
            //Definition
            headerView.sectionImage.image = sectionImages[i]
            headerView.tintColor = UIColor.white
        }
        
        switch section {
            case 0:
                if Result[0] != [String](){
                    backgroundBlurr(i: 0)
                    return headerView
            }
            case 1:
                if Result[1] != [String](){
                    backgroundBlurr(i: 1)
                    return headerView
                }
                // Cosidering case when there are no examples in a sentence
                if Result[2] != [String](){
                    backgroundBlurr(i: 2)
                    return headerView
            }
            case 2:
                if Result[2] != [String](){
                    backgroundBlurr(i: 2)
                    return headerView
            }
            default:
                fatalError()
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return Result[0].count
            case 1:
                if  Result[1].count != 0 {
                    return Result[1].count
                }
                var a:Int { self.Result[2].count == 0 ?  0 :  1 }
                return a  // When there are no examples in a sentence
            case 2:
                // Displaying only 1 cell for Audio player
                var a:Int { self.Result[2].count == 0 ?  0 :  1 }
                return a
            default:
                return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: Names.definitioncell, for: indexPath) as! DefinitionCell
                //Black shadow on
                Decorations.textsBackgroundShadow(for: cell.MainTextLabel)
                let text = Result[0][indexPath.row]
                cell.MainTextLabel.text = text
                //Marking already saved definitions
                coreData.checkAlreadySavedRows(text: text, bookMarked: &bookMarkedRow, i: indexPath.row)
                cell.bookMarkImage.isHidden = !self.bookMarkedRow[indexPath.row]
                return cell
            case 1:
                if Result[1].count != 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier:Names.definitioncell, for: indexPath) as! DefinitionCell
                    //Black shadow
                    Decorations.textsBackgroundShadow(for: cell.MainTextLabel)
                    let text = Result[1][indexPath.row]
                    cell.MainTextLabel.text = text
                    cell.bookMarkImage.isHidden = true
                    return cell
                }
                //Cosidering case when there are no examples in a sentence
                let cell = tableView.dequeueReusableCell(withIdentifier: Names.audiocell, for: indexPath) as! audioCell
                //Black shadow
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: Names.audiocell, for: indexPath) as! audioCell
                //Black shadow
                Decorations.textsBackgroundShadow(for: cell.playText)
                cell.delegate = self
                return cell
            default:
                fatalError("Failed to instantiate")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 40
    }
    
    
    //MARK: Saving definition
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let saveAction = UIContextualAction(style: .normal, title: "") { (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! DefinitionCell
            
            switch indexPath.section{
                case 0:
                    self.bookMarkedRow[indexPath.row] = (self.bookMarkedRow[indexPath.row]) ? false : true
                    let newItem = TheWord(context: context)
                    if self.bookMarkedRow[indexPath.row]{
                        cell.bookMarkImage.isHidden = false
                        newItem.definition = self.Result[0][indexPath.row]
                        newItem.audio      = self.Result[2][0]
                        newItem.word       = self.SearchField.text
                        savedArray.append(newItem)
                    }
                    coreData.saveData()
                default: print("err")
            }
            
            completionHandler(true)
        }
        
        saveAction.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.0)
        saveAction.image = UIImage(systemName: "checkmark")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [saveAction])
        //Unabling swiping for 1&2 row and for already swiped rows
        if indexPath.section == 1 || indexPath.section == 2 || self.bookMarkedRow[indexPath.row] == true  {
            return UISwipeActionsConfiguration(actions: [])
        }else{
            return swipeConfiguration
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    // MARK: Keyboard
    
    // Dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        SearchField.keyboardType = UIKeyboardType.alphabet // Only english keyboard
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    // Dismisses the keyboard from self.view
    func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    //Enter -> Search Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchAction(UIButton())
        TappingAnimation(button: SearchButton)
        textField.resignFirstResponder()
        return true
    }
    
    
    //  MARK: func's
    private func decoration(){
        Decorations.styleFilledButton(SearchButton)
        Decorations.styleTextField(SearchField)
        let color = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 0.42)
        let text = "Word to look up"
        SearchField.attributedPlaceholder = NSAttributedString(string: text ,attributes: [NSAttributedString.Key.foregroundColor: color])
        self.tableView.tableFooterView = UIView(frame: .zero)
        let moveUpTransform = CGAffineTransform.init(translationX: -200, y: 0)
        WarningLabel.transform = moveUpTransform
        
    }
    
    private func TappingAnimation(button: UIButton){
        dismiss(animated: true, completion: {
            let scaleTransform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
            button.transform = scaleTransform
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.9, options: [], animations: {
                button.transform = .identity
                button.alpha = 1
            }, completion: nil)})
    }
}


//MARK: Play sound
extension SearchVC: AudioCellDelegate{
    func playButtonTapped(Button: UIButton) {
        TappingAnimation(button: Button)
        DispatchQueue.global(qos: .userInitiated).async {
            var player = AVPlayer()
            let url  = URL.init(string: self.Result[2][0])
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



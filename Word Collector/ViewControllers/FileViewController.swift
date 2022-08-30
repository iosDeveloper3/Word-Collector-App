//
//  FileViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 25/08/2022.
//

import UIKit
import AVFoundation
//import SwiftAudioPlayer

class FileViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: TappedWordsRecognizingTextView!
    @IBOutlet weak var textFormatView: UIView!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var fontWeightSlider: UISlider!
    @IBOutlet weak var defaultSchemeButton: UIButton!
    @IBOutlet weak var blackOnWhiteSchemeButton: UIButton!
    @IBOutlet weak var whiteOnBlackSchemeButton: UIButton!
    @IBOutlet weak var readingSchemeButton: UIButton!
    @IBOutlet weak var termViewHeight: NSLayoutConstraint!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var dictionaryTermLabel: UILabel!
    @IBOutlet weak var termPronunciationButton: UIButton!
    @IBOutlet weak var definitionsTableView: UITableView!
    
    let defaultFontSize: Float = 14
    let defaultFontWeight: Float = 3
    
    var fileName: String?
    var term: DictionaryTerm?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBorderColorForMarkedButtons()
        setTextFormat()
        contentTextView.handleWordAndPosition = { [weak self] (word) in
            guard self?.term?.word != word else { return }
            self?.dictionaryTermLabel.text = word
            NetworkManager.shared.fetchEntries(for: word ?? "") { [weak self] (result) in
                switch result {
                case .success(let entries):
                    self?.setNewDictionaryTerm(newTerm: DictionaryTerm(entries, for: word))
                case .failure(let error):
                    self?.setNewDictionaryTerm(newTerm: nil)
                    print(error)
                }
            }
        }
        contentTextView.undoWordAndPosition = { [weak self] () in
            self?.hideTermView()
        }
        definitionsTableView.register(UINib(nibName: DefinitionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DefinitionTableViewCell.identifier)
        hideTermView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            contentTextView.text = try StorageManager.readFile(fileName: fileName)
            title = fileName
        } catch {
            title = "Error"
            contentTextView.text = error.localizedDescription
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateOrEditViewController {
            vc.fileName = title
            vc.fileContent = contentTextView.text
        }
    }
    
    // based on https://developer.apple.com/videos/play/wwdc2019/214/
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setBorderColorForMarkedButtons()
        }
    }
    
    func setTextFormat() {
        fontSizeSlider.value = UserDefaults.standard.fontSize ?? defaultFontSize
        fontWeightSlider.value = UserDefaults.standard.fontWeight ?? defaultFontWeight
        contentTextView.font = contentTextView.font?.withSize(CGFloat(fontSizeSlider.value)).withWeight(UIFont.Weight.allValues[Int(fontWeightSlider.value)])
        let colorScheme = ColorScheme(rawValue: UserDefaults.standard.colorScheme) ?? .defaultScheme
        switch colorScheme {
        case .blackOnWhite:
            markSchemeColorButton(blackOnWhiteSchemeButton)
        case .whiteOnBlack:
            markSchemeColorButton(whiteOnBlackSchemeButton)
        case .bestForReading:
            markSchemeColorButton(readingSchemeButton)
        default:
            markSchemeColorButton(defaultSchemeButton)
        }
        view.backgroundColor = colorScheme.backgroundColor
        contentTextView.textColor = colorScheme.fontColor
    }
    
    func markSchemeColorButton(_ button: UIButton) {
        defaultSchemeButton.layer.borderWidth = 0
        blackOnWhiteSchemeButton.layer.borderWidth = 0
        whiteOnBlackSchemeButton.layer.borderWidth = 0
        readingSchemeButton.layer.borderWidth = 0
        button.layer.borderWidth = 2
    }
    
    func setBorderColorForMarkedButtons() {
        defaultSchemeButton.layer.borderColor = UIColor.label.cgColor
        blackOnWhiteSchemeButton.layer.borderColor = UIColor.label.cgColor
        whiteOnBlackSchemeButton.layer.borderColor = UIColor.label.cgColor
        readingSchemeButton.layer.borderColor = UIColor.label.cgColor
    }
    
    func setNewDictionaryTerm(newTerm: DictionaryTerm?) {
        term = newTerm
        if let term = term {
            termPronunciationButton.setTitle(term.phonetic, for: .normal)
            termPronunciationButton.isHidden = false
        } else {
            dictionaryTermLabel.text = "No translation found"
            termPronunciationButton.isHidden = true
        }
        definitionsTableView.reloadData()
        showTermView()
    }
    
    func hideTermView() {
        termView.isHidden = true
        termViewHeight = termViewHeight.setMultiplier(multiplier: 0.01)
    }
    
    func showTermView() {
        termViewHeight = termViewHeight.setMultiplier(multiplier: 0.6)
        termView.isHidden = false
    }

    @IBAction func textFormatClicked(_ sender: Any) {
        hideTermView()
        textFormatView.isHidden = false
    }
    
    @IBAction func closeTextFormatClicked(_ sender: Any) {
        textFormatView.isHidden = true
    }
    
    @IBAction func fontSizeChanged(_ sender: UISlider) {
        contentTextView.font = contentTextView.font?.withSize(CGFloat(sender.value))
        UserDefaults.standard.fontSize = sender.value
    }
    
    @IBAction func fontWeightChanged(_ sender: UISlider) {
        contentTextView.font = contentTextView.font?.withWeight(UIFont.Weight.allValues[Int(sender.value)])
        UserDefaults.standard.fontWeight = sender.value
    }
    
    @IBAction func shemeButtonClicked(_ sender: UIButton) {
        var colorScheme = ColorScheme.defaultScheme
        switch sender {
        case blackOnWhiteSchemeButton:
            colorScheme = .blackOnWhite
        case whiteOnBlackSchemeButton:
            colorScheme = .whiteOnBlack
        case readingSchemeButton:
            colorScheme = .bestForReading
        default:
            colorScheme = .defaultScheme
        }
        view.backgroundColor = colorScheme.backgroundColor
        contentTextView.textColor = colorScheme.fontColor
        markSchemeColorButton(sender)
        UserDefaults.standard.colorScheme = colorScheme.rawValue
    }
    
    @IBAction func setToDefaultButtonClicked(_ sender: Any) {
        UserDefaults.standard.fontSize = defaultFontSize
        UserDefaults.standard.fontWeight = defaultFontWeight
        UserDefaults.standard.colorScheme = ColorScheme.defaultScheme.rawValue
        setTextFormat()
    }
    
    @IBAction func pronunciationButtonTapped(_ sender: Any) {
        term?.playPronunciation()
    }
}

extension FileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return term?.partsOfSpeach.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return term?.partsOfSpeach[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return term?.information[section].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DefinitionTableViewCell.identifier) as? DefinitionTableViewCell else {
            fatalError()
        }
        cell.setup(definition: term?.information[indexPath.section][indexPath.row] ?? Definition())
        return cell
    }
}

//
//  FileViewController.swift
//  Word Collector
//
//  Created by Dawid Herman on 25/08/2022.
//

import UIKit

class FileViewController: UIViewController {

    @IBOutlet weak var wordCollectionView: UICollectionView!
    @IBOutlet weak var textFormatView: TextFormatView!
    @IBOutlet weak var termViewHeight: NSLayoutConstraint!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var dictionaryTermLabel: UILabel!
    @IBOutlet weak var termPronunciationButton: UIButton!
    @IBOutlet weak var definitionsTableView: UITableView!
    @IBOutlet weak var addToVocabularyButton: UIButton!

    var fileName: String?
    var content: TextContent?
    var textFormat = TextFormat()
    var wordCollection = [String]()
    var word: String?
    var wordLocation: IndexPath?
    var term: DictionaryTerm?
    let vocabulary = Vocabulary.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        textFormatView.delegate = self
        definitionsTableView.register(UINib(nibName: DefinitionTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DefinitionTableViewCell.identifier)
        hideTermView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        do {
            content = TextContent(try StorageManager.readFile(fileName: fileName))
            title = fileName
        } catch {
            title = ""
            content = TextContent("")
            let alert = UIAlertController(title: error.localizedDescription, message: "Do you want to leave?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
        }
        wordCollectionView.reloadData()
        if let word = word, let location = wordLocation {
            self.word = nil
            openTermInspector(selectedWord: word, indexPath: location)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CreateOrEditViewController {
            vc.fileName = title
            vc.fileContent = content?.text
        }
    }

    func setNewDictionaryTerm(newTerm: DictionaryTerm?, newWord: String?) {
        term = newTerm
        word = newWord
        if let term = term {
            termPronunciationButton.setTitle(term.phonetic, for: .normal)
            termPronunciationButton.isHidden = false
            addToVocabularyButton.isHidden = false
        } else {
            dictionaryTermLabel.text = "No translation found"
            termPronunciationButton.isHidden = true
            addToVocabularyButton.isHidden = true
        }
        definitionsTableView.reloadData()
        showTermView()
    }

    func hideTermView() {
        termView.isHidden = true
        termViewHeight = termViewHeight.setMultiplier(multiplier: 0.01)
        if let location = wordLocation, let cell = wordCollectionView.cellForItem(at: location) as? WordCollectionViewCell {
            cell.wordLabel.removeUnderline()
            wordLocation = nil
        }
    }

    func showTermView() {
        UIAccessibility.post(notification: .layoutChanged, argument: termView)
        termViewHeight = termViewHeight.setMultiplier(multiplier: 0.6)
        termView.isHidden = false
    }

    func openTermInspector(selectedWord: String?, indexPath: IndexPath?) {
        wordLocation = indexPath
        addToVocabularyButton.isSelected = vocabulary.contains(word: SavedWord(word: selectedWord, fileName: fileName, paragraphNumber: indexPath?.section, wordNumber: indexPath?.row))

        guard selectedWord != word else { return }

        word = selectedWord
        dictionaryTermLabel.text = selectedWord
        NetworkManager.shared.fetchEntries(for: selectedWord ?? "") { [weak self] (result) in
            switch result {
            case .success(let entries):
                self?.setNewDictionaryTerm(newTerm: DictionaryTerm(entries), newWord: selectedWord)
            case .failure(let error):
                self?.setNewDictionaryTerm(newTerm: nil, newWord: nil)
                print(error)
            }
        }
    }

    @IBAction func textFormatClicked(_ sender: Any) {
        hideTermView()
        textFormatView.isHidden = false
        UIAccessibility.post(notification: .layoutChanged, argument: textFormatView)
    }

    @IBAction func pronunciationButtonTapped(_ sender: Any) {
        term?.playPronunciation()
    }

    @IBAction func saveWordButtonTapped(_ sender: Any) {
        if let word = word, let fileName = fileName, let locationInFile = wordLocation {
            if addToVocabularyButton.isSelected {
                vocabulary.remove(word: SavedWord(word: word, fileName: fileName, paragraphNumber: locationInFile.section, wordNumber: locationInFile.row))
            } else {
                vocabulary.add(word: SavedWord(word: word, fileName: fileName, paragraphNumber: locationInFile.section, wordNumber: locationInFile.row))
            }
            addToVocabularyButton.isSelected = !addToVocabularyButton.isSelected
        }
    }

    @IBAction func closeTermInspectorButtonTapped(_ sender: Any) {
        hideTermView()
    }
}

extension FileViewController: TextFormatViewDelegate {

    func updateFormatText(_ textFormatView: TextFormatView, scheme: TextFormat) {
        textFormat = scheme
        view.backgroundColor = scheme.colorScheme.backgroundColor
        wordCollectionView.reloadData()
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

extension FileViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return content?.paragraphs.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content?.paragraphs[section].count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCollectionViewCell.identifier, for: indexPath) as? WordCollectionViewCell else {
            fatalError()
        }
        cell.wordLabel.font = cell.wordLabel.font.withSize(CGFloat(textFormat.fontSize)).withWeight(UIFont.Weight.allValues[Int(textFormat.fontWeight)])
        cell.wordLabel.textColor = textFormat.colorScheme.fontColor
        cell.setup(word: content?.paragraphs[indexPath.section][indexPath.row])
        if let location = wordLocation, location.section == indexPath.section && location.row == indexPath.row {
            cell.wordLabel.addUnderline()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let location = wordLocation, let cell = collectionView.cellForItem(at: location) as? WordCollectionViewCell {
            cell.wordLabel.removeUnderline()
        }
        if let cell = collectionView.cellForItem(at: indexPath) as? WordCollectionViewCell {
            cell.wordLabel.addUnderline()
        }
        openTermInspector(selectedWord: content?.paragraphs[indexPath.section][indexPath.row], indexPath: indexPath)
    }
}

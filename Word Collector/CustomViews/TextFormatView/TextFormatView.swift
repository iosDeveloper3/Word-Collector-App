//
//  TextFormatView.swift
//  Word Collector
//
//  Created by Dawid Herman on 17/09/2022.
//

import UIKit

protocol TextFormatViewDelegate: AnyObject {

    func updateFormatText(_ textFormatView: TextFormatView, scheme: TextFormat)
}

class TextFormatView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var fontSizeSlider: UISlider!
    @IBOutlet weak var fontWeightSlider: UISlider!
    @IBOutlet weak var defaultSchemeButton: UIButton!
    @IBOutlet weak var blackOnWhiteSchemeButton: UIButton!
    @IBOutlet weak var whiteOnBlackSchemeButton: UIButton!
    @IBOutlet weak var readingSchemeButton: UIButton!

    weak var delegate: TextFormatViewDelegate?

    private var textFormat = TextFormat()

    // based on https://betterprogramming.pub/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed(TextFormatView.identifier, owner: self)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateViewControls()
        setBorderColorForMarkedButtons()
    }

    // based on https://developer.apple.com/videos/play/wwdc2019/214/
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            setBorderColorForMarkedButtons()
        }
    }

    func updateViewControls() {
        fontSizeSlider.value = textFormat.fontSize
        fontWeightSlider.value = textFormat.fontWeight
        switch textFormat.colorScheme {
        case .blackOnWhite:
            markSchemeButtonAsSelected(blackOnWhiteSchemeButton)
        case .whiteOnBlack:
            markSchemeButtonAsSelected(whiteOnBlackSchemeButton)
        case .bestForReading:
            markSchemeButtonAsSelected(readingSchemeButton)
        default:
            markSchemeButtonAsSelected(defaultSchemeButton)
        }
        delegate?.updateFormatText(self, scheme: textFormat)
    }

    func markSchemeButtonAsSelected(_ button: UIButton) {
        defaultSchemeButton.layer.borderWidth = 0
        defaultSchemeButton.accessibilityTraits.remove(.selected)
        blackOnWhiteSchemeButton.layer.borderWidth = 0
        blackOnWhiteSchemeButton.accessibilityTraits.remove(.selected)
        whiteOnBlackSchemeButton.layer.borderWidth = 0
        whiteOnBlackSchemeButton.accessibilityTraits.remove(.selected)
        readingSchemeButton.layer.borderWidth = 0
        readingSchemeButton.accessibilityTraits.remove(.selected)
        button.layer.borderWidth = 2
        button.accessibilityTraits.insert(.selected)
    }

    func setBorderColorForMarkedButtons() {
        defaultSchemeButton.layer.borderColor = UIColor.label.cgColor
        blackOnWhiteSchemeButton.layer.borderColor = UIColor.label.cgColor
        whiteOnBlackSchemeButton.layer.borderColor = UIColor.label.cgColor
        readingSchemeButton.layer.borderColor = UIColor.label.cgColor
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        isHidden = true
    }

    @IBAction func fontSizeValueChanged(_ sender: UISlider) {
        textFormat.fontSize = sender.value
        delegate?.updateFormatText(self, scheme: textFormat)
    }

    @IBAction func fontWeightValueChanged(_ sender: UISlider) {
        textFormat.fontWeight = sender.value
        delegate?.updateFormatText(self, scheme: textFormat )
    }

    @IBAction func schemeButtonTapped(_ sender: UIButton) {
        switch sender {
        case blackOnWhiteSchemeButton:
            textFormat.colorScheme = .blackOnWhite
        case whiteOnBlackSchemeButton:
            textFormat.colorScheme = .whiteOnBlack
        case readingSchemeButton:
            textFormat.colorScheme = .bestForReading
        default:
            textFormat.colorScheme = .defaultScheme
        }
        delegate?.updateFormatText(self, scheme: textFormat)
        markSchemeButtonAsSelected(sender)
    }

    @IBAction func setToDefaultButtonTapped(_ sender: Any) {
        textFormat.setToDefault()
        updateViewControls()
    }
}

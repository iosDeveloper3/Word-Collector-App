//
//  Vobulary_Tests.swift
//  Word Collector Tests
//
//  Created by Dawid Herman on 11/09/2022.
//

@testable import Word_Collector
import XCTest

class VocabularyUnitTests: XCTestCase {

    let file1: String = "file1"

    let randomSavedWords: [SavedWord] = [
        SavedWord(word: "example", fileName: "file1", paragraphNumber: 2, wordNumber: 5),
        SavedWord(word: "word", fileName: "file2", paragraphNumber: 1, wordNumber: 42),
        SavedWord(word: "another", fileName: "file1", paragraphNumber: 4, wordNumber: 23),
        SavedWord(word: "a", fileName: "file3", paragraphNumber: 3, wordNumber: 77),
        SavedWord(word: "an", fileName: "file4", paragraphNumber: 5, wordNumber: 2)
    ]

    var vocabulary: Vocabulary!

    override func setUp() {
        vocabulary = Vocabulary.shared
    }

    override func tearDown() {
        vocabulary = nil
    }

    func test_adding_one_element() {
        let testSavedWord = randomSavedWords[0]

        vocabulary.add(word: testSavedWord)

        XCTAssertTrue(vocabulary.contains(word: testSavedWord))

        vocabulary.remove(word: testSavedWord)

        XCTAssertFalse(vocabulary.contains(word: testSavedWord))
    }

    func test_getting_different_parts_of_SavedWord() {
        let testSavedWord = randomSavedWords[0]

        vocabulary.add(word: testSavedWord)

        XCTAssertEqual(vocabulary.savedWord(at: 0), testSavedWord)
        XCTAssertEqual(vocabulary.word(at: 0), testSavedWord.word)
        XCTAssertEqual(vocabulary.fileName(at: 0), testSavedWord.fileName)
        XCTAssertEqual(vocabulary.paragraphNumber(at: 0), testSavedWord.paragraphNumber)
        XCTAssertEqual(vocabulary.wordNumber(at: 0), testSavedWord.wordNumber)

        vocabulary.remove(word: testSavedWord)
    }

    func test_not_adding_the_same_SavedWord_twice() {
        let testSavedWord = randomSavedWords[0]

        vocabulary.add(word: testSavedWord)
        vocabulary.add(word: testSavedWord)

        XCTAssertEqual(vocabulary.count, 1)

        vocabulary.remove(word: testSavedWord)

        XCTAssertEqual(vocabulary.count, 0)
    }

    func test_removing_SavedWords_of_specific_file() {
        for savedWord in randomSavedWords {
            vocabulary.add(word: savedWord)
        }

        XCTAssertTrue(vocabulary.containsWords(from: file1))
        XCTAssertEqual(vocabulary.count, 5)

        vocabulary.removeAllFor(fileName: file1)

        XCTAssertFalse(vocabulary.containsWords(from: file1))
        XCTAssertEqual(vocabulary.count, 3)

        while vocabulary.count > 0 {
            let savedWord = vocabulary.savedWord(at: 0)
            vocabulary.remove(word: savedWord)
        }
    }

    func test_nil_values_as_arguments() {
        vocabulary.add(word: nil)

        XCTAssertEqual(vocabulary.count, 0)

        let testSavedWord = randomSavedWords[0]

        vocabulary.add(word: testSavedWord)
        vocabulary.remove(word: nil)

        XCTAssertEqual(vocabulary.count, 1)

        vocabulary.removeAllFor(fileName: nil)

        XCTAssertEqual(vocabulary.count, 1)
        XCTAssertFalse(vocabulary.containsWords(from: nil))
        XCTAssertFalse(vocabulary.contains(word: nil))
    }
}

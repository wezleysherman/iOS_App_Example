////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Created by Wezley Sherman on 6/8/16.                                                                       //
// Copyright © 2016 Wezley Sherman. All rights reserved.                                                      //
//                                                                                                            //
// The Summarizer class is built to take in a large body of text and summarize                                //
// down to a given number of sentences.                                                                       //
//                                                                                                            //
// First, the class takes  the body of text and breaks down down to an array of words                         //
// It then counts how many times each word occurs in the text and stores it in a dictionary.                  //
// The class then takes that dictonary and sorts it -- grabbing `totalKeyWords` number of items               //
// from the top.                                                                                              //
//                                                                                                            //
// Finally, the class breaks down the textbody into sentences, finds how many times a keyword appears         //
// in the sentence, and then grabs the most heabily weighted sentences.                                       //
// The class will then assign a new `summary` object with the `link`, `title`, and `summary`.                 //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


import UIKit

// Create a global `textSummarizer` object for the program to call when needed.
var textSummarizer : Summarizer = Summarizer()

// Create the `summary` struct to store information for each summary that is created
struct summary {
    var link = "empty_link"
    var title = "empty_title"
    var summary = "empty_summary"
}

// Global `currentSummary` object for the detailed view.
var currentSummary = summary()

class Summarizer {
    // Define our variables and constants for the object
    var MIN_WORD_LENGTH = 4;
    var summarys = [summary]()
    var articleKeyWords = [String]()
    var totalSentences = 0
    var totalKeyWords = 0
    var wordCount = 0
    
    /* `summarize` is responsible for summarizing a given link, to the parameters
     * defined with `sentenceCount` and `keyWordCount`
     *
     * The summarization algorithm is as follows:
     * 1. We process the given link/search item to determine if we are to summarize a new object
     *              or if we can fetch a previously summarized article.
     * 2. If we must summarize a new article, we will get the textbody of the webpage.
     * 3. We split the textbody into an array of each word and count their reoccurrences.
     * 4. We then return the highest occurrances of `keyWordCount` number of words.
     * 5. After that, we break down the textbody to an array of sentences.
     * 6. We then look through each sentence and rate it depending on the number of keywords it contains.
     * 7. The highest rated sentences will be processed and turned into a single string.
     * 8. We then set the `newSummary` attributes and store it in `summarys` array
     */
    func summarize (link: String, sentenceCount: Int, keyWordCount: Int) {
        totalSentences = sentenceCount
        totalKeyWords = keyWordCount
        var newSummary = summary()
        let linkHandler : HTMLHandler = HTMLHandler(initLink: link)
        let textBody = linkHandler.getPageBody()
        let textTitle = linkHandler.getPageTitle()
        
        let tagsInText = findTagWords(textBody)
        let topSentences = getMostCommonSentences(tagsInText, text: textBody)
        

        newSummary.summary = processSummary(topSentences)
        newSummary.link = link
        newSummary.title = textTitle
        currentSummary = newSummary
        summarys.append(newSummary)
    }
    
    /* The `findTagWords` function is responsible for splitting our textbody into an array of words
     * We then use our `textWords` dictionary to determine the number of reoccurrences each word has.
     *
     * After we get the dictionary of words, we sort them from highest reoccurrences to lowest.
     * Finally we check to make sure the given words are larger than `MIN_WORD_LENGTH` characters
     *          (This elemenates heavily repeated words such as: `The`, `a`, `an`, `and`, ect.)
     * Once we have compiled an array of the most common words in the textbody we return it to `summarize`.
     */
    func findTagWords(text: String) -> [String] {
        let textWords = text.characters.split(" ").map(String.init)
        let wordsCounted: [String: Int] = countWordReoccurrence(textWords)
        let wordsSorted = (wordsCounted as NSDictionary).keysSortedByValueUsingComparator { ($1 as! NSNumber).compare($0 as!NSNumber) }
        var tagWords = [String]()
        
        for word in wordsSorted {
            let wordAsString = word as! String
            if(wordAsString.characters.count >= MIN_WORD_LENGTH && wordCount < totalKeyWords) {
                tagWords.append(wordAsString)
                wordCount = wordCount + 1
            } else if (wordCount > totalKeyWords) {
                break
            }
        }
        return tagWords
    }
    
    // The `countWordReoccurrence` is responsible for counting how many times a 
    // given word reoccurres in the array.
    func countWordReoccurrence(textWords: [String]) -> [String: Int] {
        var wordCount: [String: Int] = [:]

        for word in textWords {
            if (wordCount[word] != nil) {
                wordCount[word] = wordCount[word]! + 1
            } else {
                wordCount[word] = 0
            }
        }
        return wordCount
    }
    
    /* The `getMostCommonSentences` function takes in the `tagWords` array as well as the text body,
     * and returns an array of the highest rated sentences of `totalSentences` amount.
     *
     * First, this function splits the textbody into sentences using linguistic processing.
     * It then checks each sentence and gives it a rating based on how many keywords exist in the sentence.
     *
     * Finally the sentences are sorted based on their rating and `totalSentences` amount is added to an array
     * and returned to `summarize`.
     */
    func getMostCommonSentences(tagWords: [String], text: String) -> [String] {
        var mostReleventSentences = [String]()
        let sentences = splitTextToSentences(text)
        let scoredSentences = findTagsInSentences(sentences, tags: tagWords)
        let sentencesSorted = (scoredSentences as NSDictionary).keysSortedByValueUsingComparator { ($1 as! NSNumber).compare($0 as!NSNumber) }
        var senCount = 0
        
        for sentence in sentencesSorted {
            if(senCount < totalSentences) {
                mostReleventSentences.append(sentence as! String)
                senCount = senCount + 1
            }
        }
        return mostReleventSentences
    }
    
    // Use linguistic processing to split the textbody down to an array of sentences.
    func splitTextToSentences(text: String) -> [String]{
        var sentences = [String]()
        var tRanges = [Range<String.Index>]()
        let langTags = text.linguisticTagsInRange(text.characters.indices, scheme:  NSLinguisticTagSchemeLexicalClass, tokenRanges: &tRanges)
        let filterSen = langTags.enumerate().filter { $0.1 == "SentenceTerminator" }.map {tRanges[$0.0].startIndex}
        var pSen = text.startIndex
        
        for sentence in filterSen {
            sentences.append(text[pSen...sentence].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
            pSen = sentence.advancedBy(1)
        }
        return sentences
    }
    
    // Search through the array of sentences and give each sentence a rating based on how many keywords exist.
    func findTagsInSentences(sen: [String], tags: [String]) -> [String: Int]{
        var sentencesScored: [String: Int] = [:]
        for sentence in sen {
            var senScore = 0
            for tagWord in tags {
                if sentence.containsString(tagWord) {
                    senScore = senScore + 1
                }
            }
            sentencesScored[sentence] = senScore
        }
        return sentencesScored
    }
    
    // Take in the array of sentences and turn them into a single string.
    func processSummary(sentences: [String]) -> String{
        var finalSum = ""
        for sentence in sentences {
            finalSum = finalSum + sentence + " "
        }
        return finalSum
    }

}

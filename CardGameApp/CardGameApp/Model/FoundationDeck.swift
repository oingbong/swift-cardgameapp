//
//  FoundationDeck.swift
//  CardGameApp
//
//  Created by Mrlee on 2018. 3. 9..
//  Copyright © 2018년 Napster. All rights reserved.
//

import Foundation

class FoundationDeck {
    private var foundationDeck = Array.init(repeating: Deck(cards: [Card]()), count: 4)
    
    private func calculateEmptyPlace() -> Int? {
        return foundationDeck.index(where: { $0.isEmptyDeck() })
    }
    
    private func calculateSameGroup(_ card: Card) -> Int? {
        for index in 0..<foundationDeck.count {
            if foundationDeck[index].isSameGroup(card) {
                return index
            }
        }
        return nil
    }
    
    func isContinuousCard(_ card: Card) -> Bool {
        for index in 0..<foundationDeck.count {
            guard let baseCard = foundationDeck[index].lastCard() else { return false }
            if baseCard.isSameSuit(card) && baseCard.isContinuousCardRankFoundation(card) {
                return true
            }
        }
        return false
    }
    
    func pushAce(_ card: Card) {
        guard let emptyIndex = calculateEmptyPlace() else { return }
        foundationDeck[emptyIndex].pushCard(card)
        NotificationCenter.default.post(name: .pushFoundation, object: self, userInfo: [Notification.Name.cardLocation: emptyIndex,
                                                                                        Notification.Name.cardName: card.getCardName()])
    }
    
    func pushCard(_ card: Card) {
        guard let sameGroupIndex = calculateSameGroup(card) else { return }
        foundationDeck[sameGroupIndex].pushCard(card)
        NotificationCenter.default.post(name: .pushFoundation, object: self, userInfo: [Notification.Name.cardLocation: sameGroupIndex,
                                                                                        Notification.Name.cardName: card.getCardName()])
    }
}

/*
 NotificationCenter.default.post(name: .cardName,
 object: self,
 userInfo: [Notification.Name.pushCardFoundationFromOpenDeck: index])
 */

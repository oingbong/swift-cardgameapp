//
//  TableauViewModel.swift
//  CardGameApp
//
//  Created by oingbong on 14/11/2018.
//  Copyright © 2018 oingbong. All rights reserved.
//

import Foundation

class TableauViewModel {
    private var tableauModels: [CardStack]
    
    init() {
        var modelList = [CardStack]()
        for _ in 0..<Unit.tableauCount {
            let tableauModel = CardStack()
            modelList.append(tableauModel)
        }
        self.tableauModels = modelList
    }
    
    var count: Int {
        return self.tableauModels.count
    }
    
    func isEmpty(index: Int) -> Bool {
        return self.tableauModels[index].list().count == 0 ? true : false
    }
    
    func isOneStepHigher(with card: Card, at index: Int) -> Bool {
        guard tableauModels[index].hasCard() else { return false }
        guard let lastCard = tableauModels[index].lastCard else { return false }
        return card.isOneStepHigherWithAnotherShape(with: lastCard)
    }
    
    func selectedCard(at index: Int, sub subIndex: Int) -> Card {
        let card = self.tableauModels[index][subIndex]
        return card
    }
}

extension TableauViewModel {
    subscript(index: Int) -> CardStack {
        return tableauModels[index]
    }
}

extension TableauViewModel: MultipleDataSource {
    func card(_ handler: (Card, Int) -> Void) {
        for index in 0..<tableauModels.count {
            for card in tableauModels[index].list() {
                handler(card, index)
            }
        }
    }
}

extension TableauViewModel: DeliverableViewModeling {
    func postNotification() {
        let key = Notification.Name(NotificationKey.name.tableau)
        NotificationCenter.default.post(name: key, object: nil)
    }
    
    func push(_ card: Card, at index: Int?) {
        guard let idx = index else { return }
        tableauModels[idx].push(card)
        postNotification()
    }
    
    func removeAll() {
        for index in 0..<tableauModels.count {
            tableauModels[index].removeAll()
        }
        postNotification()
    }
    
    func pop(at index: Int?, sub subIndex: Int?) -> Card? {
        guard let idx = index else { return nil }
        // 기본으로 해당 CarStack 의 마지막 index 를 세팅해주며 subIndex 가 존재하면 세팅해줍니다.
        var subIdx = tableauModels[idx].count - 1
        if let tempIndex = subIndex {
            subIdx = tempIndex
        }
        postNotification()
        return tableauModels[idx].specifiedPop(at: subIdx)
    }
    
    func info(at index: Int?) -> Card? {
        guard let idx = index else { return nil }
        return tableauModels[idx].info()
    }
    
    func lastCard(at index: Int?) -> Card? {
        guard let idx = index else { return nil }
        return tableauModels[idx].lastCard
    }
    
    func hasCard(at index: Int?) -> Bool {
        guard let idx = index else { return false }
        return tableauModels[idx].count > 0 ? true : false
    }
}

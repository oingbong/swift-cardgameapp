//
//  TableauContainerView.swift
//  CardGameApp
//
//  Created by oingbong on 12/11/2018.
//  Copyright © 2018 oingbong. All rights reserved.
//

import UIKit

class TableauContainerView: UIView, CardContainerView {
    var dataSource: MultipleDataSource?
    // 카드몰드는 배열에도 속하지 않고 그냥 모양을 나타내기 위해 addSubView만 합니다.
    private var container = [UIView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        var xValue = Unit.space
        for _ in 0..<Unit.cardCountNumber {
            let mold = cardMold(x: xValue, y: 0)
            // 모델에서 추가할 때는 인덱스를 보고 추가하기 위해 배열에 넣어 사용합니다.
            self.addSubview(mold)
            let rect = CGRect(x: xValue, y: 0, width: Unit.imageWidth * Unit.widthRatio, height: self.frame.height)
            let container = UIView(frame: rect)
            self.addSubview(container)
            self.container.append(container)
            let newXValue = xValue + mold.frame.width + Unit.space
            xValue = newXValue
        }
    }
    
    private func cardMold(x xValue: CGFloat, y yValue: CGFloat) -> UIView {
        let rect = CGRect(x: xValue, y: yValue, width: Unit.imageWidth * Unit.widthRatio, height: Unit.imageWidth * Unit.heightRatio)
        let mold = UIView(frame: rect)
        mold.layer.borderWidth = Unit.foundationBorderWidth
        mold.layer.borderColor = Unit.foundationBorderColor
        return mold
    }
    
    override func layoutSubviews() {
        removeAllSubView()
        addAllSubView()
    }
    
    private func removeAllSubView() {
        for containerView in self.container {
            for subView in containerView.subviews {
                subView.removeFromSuperview()
            }
        }
    }
    
    private func addAllSubView() {
        dataSource?.card {
            let count = self.container[$1].subviews.count
            let yValue = CGFloat(count) * Unit.cardSpace
            if count == $1 {
                $0.flipCondition(with: .front)
            }
            let cardView = CardImageView(frame: CGRect(x: 0, y: yValue, width: Unit.imageWidth * Unit.widthRatio, height: Unit.imageWidth * Unit.heightRatio))
            cardView.image = $0.image()
            self.container[$1].addSubview(cardView)
            addGestureCardView(with: cardView, index: $1)
        }
    }
}

extension TableauContainerView {
    private func addGestureCardView(with view: CardImageView, index: Int) {
        let doubleTapGesture = CustomUITapGestureRecognizer(target: view, action: #selector(view.dobuleTapActionTableau(tapGestureRecognizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.index = index
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(doubleTapGesture)
    }
}

extension TableauContainerView: DeliverableView {
    func drawSubView() {
        setNeedsLayout()
    }
}

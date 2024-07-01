//
//  CalendarCollectionViewCell.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

final class CalendarCollectionViewCell: BaseCollectionViewCell {
    enum CellRoundedType {
        case top, bottom, all, notRounded
    }
    
    private let label = BaseLabel()
    private let categoryImage = UIImageView()
    
    override class var reuseIdentifier: String {
        String(describing: CalendarCollectionViewCell.self)
    }
    
    override func configure(_ parametr: Any) {
        guard let item = parametr as? TodoItem else {
            print(#function, "Не удалось конфигурировать CalendarCollectionViewCell")
            return
        }
        label.text = item.text
        let attributedTimeString: NSAttributedString
        if item.isDone {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.colorGray
            ]
            attributedTimeString = NSAttributedString(
                string: item.text,
                attributes: attributes
            )
        } else {
            attributedTimeString = NSAttributedString(string: item.text)
        }
        self.label.attributedText = attributedTimeString
    }
}

// MARK: - Configure
extension CalendarCollectionViewCell {
    override func setupViews() {
        super.setupViews()
        addSubviews(label, categoryImage)
    }
    
    override func layoutViews() {
        super.layoutViews()
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(32)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        backgroundColor = UIColor.backSecondary
    }
}

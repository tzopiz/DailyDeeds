//
//  CalendarCollectionViewCell.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

final class CalendarCollectionViewCell: BaseCollectionViewCell {
    override class var reuseIdentifier: String {
        String(describing: CalendarCollectionViewCell.self)
    }
    
    private let label = BaseLabel(
        textColor: UIColor.labelSecondary,
        textAlignment: .center
    )
    
    override func configure(_ parametr: Any) {
        guard let dateInfo = parametr as? DateInfo else {
            print(#function, "Не удалось конфигурировать CalendarCollectionViewCell")
            return
        }
        label.text = dateInfo.day + "\n" + dateInfo.month
        backgroundColor = dateInfo.isSelected ? .navBarBackground : .clear
    }
}

// MARK: - Configure
extension CalendarCollectionViewCell {
    override func setupViews() {
        super.setupViews()
        addSubviews(label)
    }
    
    override func layoutViews() {
        super.layoutViews()
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.separator.cgColor
    }
}

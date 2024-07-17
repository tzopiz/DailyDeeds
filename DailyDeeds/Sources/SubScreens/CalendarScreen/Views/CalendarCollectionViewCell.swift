//
//  CalendarCollectionViewCell.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import CocoaLumberjackSwift
import UIComponents
import UIKit

final class CalendarCollectionViewCell: BaseCollectionViewCell {
    override class var reuseIdentifier: String {
        String(describing: CalendarCollectionViewCell.self)
    }

    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .navBarBackground : .clear
            layer.borderColor = isSelected ? UIColor.separator.cgColor : UIColor.clear.cgColor
         }
    }

    private let label = BaseLabel(
        textColor: UIColor.labelSecondary,
        textAlignment: .center
    )

    override func configure(_ parametr: Any) {
        guard let dateInfo = parametr as? DateInfo else {
            DDLogError("Failed to configure CalendarCollectionViewCell with invalid parameter.")
            return
        }
        label.text = dateInfo.description(.short)
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
        backgroundColor = .clear

        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
    }
}

//
//  CalendarTableViewCell.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/1/24.
//

import UIKit
import SnapKit
import UIComponents

final class CalendarTableViewCell: BaseTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: CalendarTableViewCell.self)
    }
    
    enum CellRoundedType {
        case top, bottom, all, notRounded
    }
    
    private let label = BaseLabel()
    private let categoryImage = UIImageView()
    private var categoryImageWidthConstraint: Constraint?
    private var labelTrailingToImageConstraint: Constraint?
    private var labelTrailingToSuperviewConstraint: Constraint?
    
    override func configure(_ parametr: Any) {
        guard let item = parametr as? TodoItem else {
            print(#function, "Не удалось конфигурировать CalendarTableViewCell")
            return
        }
        label.text = item.text
        let attributedTimeString: NSAttributedString
        if item.isDone {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.labelTertiary
            ]
            attributedTimeString = NSAttributedString(
                string: item.text,
                attributes: attributes
            )
        } else {
            attributedTimeString = NSAttributedString(string: item.text)
        }
        self.label.attributedText = attributedTimeString
        self.label.textColor = item.isDone ? UIColor.labelTertiary : UIColor.labelPrimary

        // Configure the category image
        if item.importance == .medium {
            categoryImage.image = UIImage(systemName: "circle.fill")
            categoryImageWidthConstraint?.update(offset: 32)
            labelTrailingToImageConstraint?.activate()
            labelTrailingToSuperviewConstraint?.deactivate()
        } else {
            categoryImage.image = nil
            categoryImageWidthConstraint?.update(offset: 0)
            labelTrailingToImageConstraint?.deactivate()
            labelTrailingToSuperviewConstraint?.activate()
        }
        updateConstraints()
    }
}

// MARK: - Configure
extension CalendarTableViewCell {
    override func setupViews() {
        super.setupViews()
        addSubviews(label, categoryImage)
    }
    
    override func layoutViews() {
        super.layoutViews()
        
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.verticalEdges.equalToSuperview().inset(8)
            // FIXME: - Unable to simultaneously satisfy constraints.
            labelTrailingToImageConstraint = make.trailing.equalTo(categoryImage.snp.leading).offset(-8).constraint
            labelTrailingToSuperviewConstraint = make.trailing.equalToSuperview().offset(-16).constraint
        }
        
        categoryImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.size.equalTo(25)
        }
        labelTrailingToImageConstraint?.deactivate()
        labelTrailingToSuperviewConstraint?.deactivate()
    }
    
    override func configureViews() {
        super.configureViews()
        backgroundColor = UIColor.backSecondary
        
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        categoryImage.contentMode = .scaleAspectFit
    }
}

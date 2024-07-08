//
//  CalendarTableViewCell.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/1/24.
//

import UIKit
import SnapKit
import UIComponents
import CocoaLumberjackSwift

final class CalendarTableViewCell: BaseTableViewCell {
    override class var reuseIdentifier: String {
        String(describing: CalendarTableViewCell.self)
    }
    
    private let label = BaseLabel()
    private let categoryImage = UIImageView()
    private var categoryImageWidthConstraint: Constraint?
    
    override func configure(_ parametr: Any) {
        guard let item = parametr as? TodoItem else {
            DDLogError("Failed to configure CalendarTableViewCell with invalid parameter.")
            return
        }
        configureTitle(item.text, style: item.isDone)
        configureCategoryImageView(with: item.category)
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
            make.verticalEdges.equalToSuperview().inset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(categoryImage.snp.leading).offset(-8)
        }
        
        categoryImage.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            categoryImageWidthConstraint = make.size.equalTo(20).constraint
        }
    }
    
    override func configureViews() {
        super.configureViews()
        backgroundColor = UIColor.backSecondary
        
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
    }
}

extension CalendarTableViewCell {
    private func configureTitle(_ text: String, style isDone: Bool) {
        let attributedTimeString: NSAttributedString
        if isDone {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.strikethroughColor: UIColor.labelTertiary
            ]
            attributedTimeString = NSAttributedString(
                string: text,
                attributes: attributes
            )
        } else {
            attributedTimeString = NSAttributedString(string: text)
        }
        
        self.label.attributedText = attributedTimeString
        self.label.textColor = isDone ? UIColor.labelTertiary : UIColor.labelPrimary
    }
    
    private func configureCategoryImageView(with category: Category?) {
        if let category = category, let color = category.color {
            let diameter: CGFloat = 15
            let circleColor = UIColor(hex: color)
            let shadowColor = UIColor.black.cgColor
            let shadowOpacity: Float = 0.4
            let shadowOffset = CGSize(width: 0, height: 3)
            let shadowBlurRadius: CGFloat = 3
            
            let renderer = UIGraphicsImageRenderer(
                size: CGSize(width: diameter + 5, height: diameter + 5)
            )
            let circleImage = renderer.image { ctx in
                let rect = CGRect(x: 2.5, y: 0, width: diameter, height: diameter)
                ctx.cgContext.setShadow(
                    offset: shadowOffset,
                    blur: shadowBlurRadius,
                    color: shadowColor.copy(alpha: CGFloat(shadowOpacity))
                )
                ctx.cgContext.setFillColor(circleColor.cgColor)
                ctx.cgContext.addEllipse(in: rect)
                ctx.cgContext.drawPath(using: .fill)
            }
            
            categoryImage.image = circleImage
            categoryImageWidthConstraint?.update(offset: 20)
        } else {
            categoryImage.image = nil
            categoryImageWidthConstraint?.update(offset: 0)
        }
        updateConstraintsIfNeeded()
    }
}

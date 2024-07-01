//
//  TableViewHeaderView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/1/24.
//

import UIKit
import UIComponents

final class TableViewHeaderView: BaseTableViewHeaderFooterView {
    override class var reuseIdentifier: String {
        String(describing: TableViewHeaderView.self)
    }
    
    private let label = BaseLabel()
    
    override func configure(_ parametr: Any) {
        guard let dateInfo = parametr as? DateInfo else {
            print(#function, "Не удалось конфигурировать TableViewHeaderView")
            return
        }
        label.text = [dateInfo.day, dateInfo.month, dateInfo.year].joined(separator: " ")
    }
}

// MARK: - Configure
extension TableViewHeaderView {
    override func setupViews() {
        super.setupViews()
        addSubviews(label)
    }
    
    override func layoutViews() {
        super.layoutViews()
        label.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(32)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        label.textColor = UIColor.labelTertiary
    }
}

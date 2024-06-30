//
//  SectionView.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 7/1/24.
//

import UIKit
import UIComponents

final class HeaderSectionView: UICollectionReusableView, IReusableCell, IConfigurable {
    static var reuseIdentifier: String {
        String(describing: HeaderSectionView.self)
    }

    func configure(_ parametr: Any) {
        print(#function)
    }
}

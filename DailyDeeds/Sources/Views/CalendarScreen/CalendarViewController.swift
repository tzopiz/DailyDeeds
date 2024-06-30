//
//  CalendarViewController.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import SwiftUI
import UIComponents

final
class CalendarViewController: BaseCollectionViewController<CalendarViewModel, CalendarCollectionViewCell> {
    
    private let calendarNavBar = CalendarNavBar()
    
    // MARK: - Configure
    override func setupViews() {
        super.setupViews()
        view.addSubviews(calendarNavBar)
    }
    
    override func layoutViews() {
        super.layoutViews()
        calendarNavBar.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(100)
        }
        collectionView.snp.removeConstraints()
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(calendarNavBar.snp.bottom)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        view.backgroundColor = UIColor.colorBlue.withAlphaComponent(0.2)
        calendarNavBar.backgroundColor = .colorGreen.withAlphaComponent(0.2)
        collectionView.backgroundColor = .colorRed.withAlphaComponent(0.2)
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.items.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.items[section].items.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        // FIXME: - not called
        print(#function)
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarCollectionViewCell
        else {
            print(#function, "error cast cell to CalendarCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.configure(viewModel.row(for: indexPath))
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderSectionView.reuseIdentifier,
            for: indexPath
        ) as? HeaderSectionView
        else { return UICollectionReusableView() }
        view.configure(viewModel.header(for: indexPath))
        return view
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 100)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}

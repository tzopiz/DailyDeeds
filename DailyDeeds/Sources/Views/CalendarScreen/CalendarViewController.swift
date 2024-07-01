//
//  CalendarViewController.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import SwiftUI
import UIComponents

final class CalendarViewController: BaseViewController<CalendarViewModel> {
    
    private let collectionView: UICollectionView
    private let tableView: UITableView
    
    init(viewModel: CalendarViewModel, layout: UICollectionViewLayout) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.tableView = UITableView(frame: .zero)
        super.init(viewModel: viewModel)
    }
    
    @MainActor 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    override func setupViews() {
        super.setupViews()
        view.addSubviews(tableView, collectionView)
    }
    
    override func layoutViews() {
        super.layoutViews()
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(116)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        
        view.backgroundColor = UIColor.colorBlue.withAlphaComponent(0.2)
        collectionView.backgroundColor = .colorGreen.withAlphaComponent(0.2)
        tableView.backgroundColor = .colorRed.withAlphaComponent(0.2)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerCells(CalendarCollectionViewCell.self)
        collectionView.register(
            HeaderSectionView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderSectionView.reuseIdentifier
        )
        
    }
    
}

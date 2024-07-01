//
//  CalendarViewController.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import UIKit
import UIComponents

final
class CalendarViewController: BaseCollectionViewController<CalendarViewModel, CalendarCollectionViewCell> {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Configure
    override func setupViews() {
        super.setupViews()
        view.addSubviews(tableView)
    }
    
    override func layoutViews() {
        super.layoutViews()
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(91)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(1)
        }
    }
    
    override func configureViews() {
        super.configureViews()
        
        view.backgroundColor = UIColor.separator
        
        tableView.backgroundColor = UIColor.backPrimary
        tableView.registerCells(CalendarTableViewCell.self)
        tableView.registerReuseViews(TableViewHeaderView.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        
        collectionView.backgroundColor = UIColor.backPrimary
        collectionView.bounces = false
    }
    
    // MARK: - UICollectionViewDataSource
    // не могу вынести в ext, так как это generic class...
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarCollectionViewCell
        else {
            print(#function, "error cast cell to CalendarCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.configure(viewModel.collectionViewRow(for: indexPath))
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 75, height: 75)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CalendarTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(viewModel.tableViewRow(for: indexPath))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: TableViewHeaderView.reuseIdentifier
        ) as? TableViewHeaderView
        else { return UIView() }
        
        view.configure(viewModel.tableViewHeader(for: section))
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

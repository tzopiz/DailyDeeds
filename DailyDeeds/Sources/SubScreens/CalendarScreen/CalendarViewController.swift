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
    
    // TODO: -
    // - [ ] При свайпе по ячейке слева-направо дело должно помечаться выполненым. Визуально оно перечеркивается и текст становится серого цвета.
    // - [ ] При свайпе справа-налево по уже выполненному делу оно должно становиться снова активным (не выполненым).
    // - [ ] Также на этом экране должна быть кнопка «+» по тапе на которую открывается экран создания дел (тот который был написан на Swift UI).
    
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
        tableView.separatorInset = .init()
        tableView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        collectionView.backgroundColor = UIColor.backPrimary
        collectionView.bounces = false
    }
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.configure(viewModel.collectionViewCell(for: indexPath))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollTableView(with: indexPath)
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
    
    // MARK: - UIScrollViewDelegate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView,
              let visibleRows = tableView.indexPathsForVisibleRows,
              let firstVisibleRow = visibleRows.first // redraw the cell with the activity indicator
        else { return }
        
        let collectionViewIndexPath = IndexPath(item: firstVisibleRow.section, section: 0)
        scrollCollectionViewToDay(with: collectionViewIndexPath)
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
        
        cell.configure(viewModel.tableViewCell(for: indexPath))
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction))
        rightSwipe.direction = .right
        cell.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeAction))
        leftSwipe.direction = .left
        cell.addGestureRecognizer(leftSwipe)
        
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

extension CalendarViewController {
    @IBAction
    func rightSwipeAction(gesture: UISwipeGestureRecognizer) {
        if let cell = gesture.view as? CalendarTableViewCell {
            cell.toggleCompletionValue()
        }
    }
    
    @IBAction
    func leftSwipeAction(gesture: UISwipeGestureRecognizer) {
        if let cell = gesture.view as? CalendarTableViewCell {
            cell.toggleCompletionValue()
        }
    }
    
    private func scrollTableView(with indexPath: IndexPath) {
        /* One section in collection view. Each row in collection view,
         its one section in tableview */
        let tableViewIndexPath = IndexPath(row: 0, section: indexPath.row)
        self.tableView.scrollToRow(at: tableViewIndexPath, at: .top, animated: true)
    }
    
    private func scrollCollectionViewToDay(with indexPath: IndexPath, offset: CGFloat = 8.0) {
        // FIXME: - no scroll when bottom content offset == 0
        guard indexPath.section < collectionView.numberOfSections,
              indexPath.item < collectionView.numberOfItems(inSection: indexPath.section)
        else { return }
        
        let layoutAttributes = collectionView.layoutAttributesForItem(at: indexPath)
        guard let targetX = layoutAttributes?.frame.origin.x else { return }
        self.collectionView.setContentOffset(CGPoint(x: targetX - offset, y: 0), animated: true)
//        self.collectionView.scrollToItem(at: collectionViewIndexPath, at: .left, animated: true)
    }
    
}

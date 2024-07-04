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
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Configure
    override func setupViews() {
        super.setupViews()
        view.addSubviews(tableView)
    }
    
    override func layoutViews() {
        super.layoutViews()
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.leading.trailing.equalToSuperview()
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
        
        configureCreateNewTodoItemButton()
    }
    
    override func refreshData() {
        super.refreshData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.scrollViewDidScroll(self.tableView)
        }
    }
    
    private func configureCreateNewTodoItemButton() {
        let newItem = TodoItem(text: "")
        
        let detailViewController = UIHostingController(
            rootView: DetailTodoItemView(todoItem: newItem) { item in
                self.viewModel.update(oldItem: newItem, to: item)
                self.refreshData()
            }
        )
        
        let hostingController = UIHostingController(
            rootView: CreateTodoItemButton {
                self.viewModel.navigationDelegate?.presentController(
                    detailViewController,
                    animated: true,
                    completion: nil
                )
            }
        )
        
        view.addSubviews(hostingController.view)
        addChild(hostingController)
        
        hostingController.view.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(32)
            make.centerX.equalToSuperview()
        }
        
        hostingController.view.backgroundColor = .clear
        hostingController.didMove(toParent: self)
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
        
        cell.configure(viewModel.collectionViewCellItem(for: indexPath))
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tableViewIndexPath = IndexPath(row: 0, section: indexPath.row)
        self.tableView.scrollToRow(at: tableViewIndexPath, at: .top, animated: true)
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
        guard let visibleSections = tableView.indexPathsForVisibleRows?.map({ $0.section }),
              let firstVisibleSection = visibleSections.first
        else { return }
        let collectionViewIndexPath = IndexPath(item: firstVisibleSection, section: 0)
        self.collectionView.selectItem(
            at: collectionViewIndexPath,
            animated: false, // TODO: animating
            scrollPosition: .centeredHorizontally
        )
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CalendarTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(viewModel.tableViewCellItem(for: indexPath))
        
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
        let item = viewModel.tableViewCellItem(for: indexPath)
        let detailView = DetailTodoItemView(
            todoItem: item,
            onUpdate: { newItem in
                self.viewModel.update(oldItem: item, to: newItem)
                self.refreshData()
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
        
        let hostingController = UIHostingController(rootView: detailView)
        
        viewModel.navigationDelegate?.presentController(
            hostingController,
            animated: true,
            completion: {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
        )
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(
        _ tableView: UITableView,
        leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let handler = { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.viewModel.complete(
                self.viewModel.tableViewCellItem(for: indexPath),
                isDone: true
            )
            tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
        }
        let doneAction = UIContextualAction(
            style: .normal,
            title:  "Выполнено",
            handler: handler
        )
        doneAction.backgroundColor = .colorGreen
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let handler = { (action: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            self.viewModel.complete(
                self.viewModel.tableViewCellItem(for: indexPath),
                isDone: false
            )
            tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
        }
        let doneAction = UIContextualAction(
            style: .destructive,
            title:  "Не выполнено",
            handler: handler
        )
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}

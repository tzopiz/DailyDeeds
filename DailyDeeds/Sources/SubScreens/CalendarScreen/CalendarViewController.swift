//
//  CalendarViewController.swift
//  DailyDeeds
//
//  Created by Дмитрий Корчагин on 6/30/24.
//

import CocoaLumberjackSwift
import SwiftUI
import UIComponents
import UIKit

final class CalendarViewController: BaseCollectionViewController<CalendarViewModel, CalendarCollectionViewCell> {

    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let addButton = UIButton()

    // MARK: - Configure
    override func setupViews() {
        super.setupViews()
        view.addSubviews(tableView, addButton)
    }

    override func layoutViews() {
        super.layoutViews()
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(1)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(91)
        }

        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(1)
        }

        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
            make.centerX.equalToSuperview()
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl

        collectionView.backgroundColor = UIColor.backPrimary
        collectionView.bounces = false
        collectionView.refreshControl = nil

        let plusImage = UIImage(resource: .plusCircleFillBlue)
        addButton.setImage(plusImage, for: .normal)
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        addButton.layer.shadowRadius = 5
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        scrollToItem(at: 0)
    }
    
    override func refreshData() {
        super.refreshData()
        DispatchQueue.main.async {
            self.tableView.refreshControl?.beginRefreshing()
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    @IBAction
    private func addButtonTapped() {
        let newItem = TodoItem(text: "")

        let detailViewController = UIHostingController(
            rootView: DetailTodoItemView(
                todoItem: newItem,
                onDelete: {
                    self.viewModel.deleteTodoItem(with: $0.id)
                    self.refreshData()
                }, onSave: {
                    self.viewModel.updateTodoItem($0)
                    self.refreshData()
                }
            )
        )
        self.viewModel.navigationDelegate?.presentController(
            detailViewController,
            animated: true,
            completion: {
                DDLogInfo("DetailTodoItemView is presented for adding a new item")
            }
        )
    }

    // MARK: - UICollectionViewDataSource
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? CalendarCollectionViewCell else {
            DDLogError("Failed to dequeue CalendarCollectionViewCell for indexPath: \(indexPath)")
            return UICollectionViewCell()
        }

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
        if scrollView == tableView, scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating {
            if let topSection = tableView.indexPathsForVisibleRows?.first {
                scrollToItem(at: topSection.section)
            }
        }
    }

    private func scrollToItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.selectItem(
            at: indexPath,
            animated: false, // TODO: Normal animating(without ping)
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
        else {
            DDLogError("Failed to dequeue CalendarTableViewCell for indexPath: \(indexPath)")
            return UITableViewCell()
        }

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
        else {
            DDLogError("Failed to dequeue TableViewHeaderView for section: \(section)")
            return UIView()
        }

        view.configure(viewModel.tableViewHeader(for: section))
        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.tableViewCellItem(for: indexPath)
        let detailView = DetailTodoItemView(
            todoItem: item,
            onDelete: {
                self.viewModel.deleteTodoItem(with: $0.id)
                self.refreshData()
            }, onSave: {
                self.viewModel.updateTodoItem($0)
                self.refreshData()
            }
        )

        let hostingController = UIHostingController(rootView: detailView)

        viewModel.navigationDelegate?.presentController(
            hostingController,
            animated: true,
            completion: {
                self.tableView.deselectRow(at: indexPath, animated: true)
                DDLogInfo("DetailTodoItemView presented for item at indexPath: \(indexPath)")
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
        let handler = { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            let item = self.viewModel.tableViewCellItem(for: indexPath)
            self.viewModel.complete(item, isDone: true)
            tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
            DDLogInfo("Completed task for item at indexPath: \(indexPath)")
        }

        let image = UIImage(systemName: "checkmark.circle.fill")
        let doneAction = UIContextualAction(
            style: .normal,
            title: "",
            handler: handler
        )
        doneAction.backgroundColor = .colorGreen
        doneAction.image = image

        return UISwipeActionsConfiguration(actions: [doneAction])
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let handler = { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            let item = self.viewModel.tableViewCellItem(for: indexPath)
            self.viewModel.complete(item, isDone: false)
            tableView.reloadRows(at: [indexPath], with: .none)
            success(true)
            DDLogInfo("Marked task as incomplete for item at indexPath: \(indexPath)")
        }

        let image = UIImage(systemName: "xmark.circle.fill")
        let doneAction = UIContextualAction(
            style: .destructive,
            title: "",
            handler: handler
        )
        doneAction.image = image

        return UISwipeActionsConfiguration(actions: [doneAction])
    }
}

//
//  YJSuspensionCellView.m
//  YJTableViewFactory
//
//  HomePage:https://github.com/937447974/YJCocoa
//  YJ技术支持群:557445088
//
//  Created by 阳君 on 16/5/11.
//  Copyright © 2016年 YJCocoa. All rights reserved.
//

#import "YJSuspensionCellView.h"
#import "YJTableViewDelegate.h"
#import "YJTableViewDataSource.h"
#import "UIView+YJViewGeometry.h"
#import "YJAutoLayout.h"

#pragma mark - YJSuspensionCellView
@interface YJSuspensionCellView () {
    CGFloat _showCellHeight;  ///< 当前显示Cell高
}

@property (nonatomic) BOOL scrollAnimate; ///< 悬浮cell动画滑动中
@property (nonatomic) NSInteger index;      ///< 当前显示下标, 1代表第一个cell固定显示
@property (nonatomic, weak, readonly) UITableView *tableView; ///< UITableView
@property (nonatomic, strong) NSMutableArray<YJTableCellObject *> *indexPaths;    ///< 悬浮的Cell对象
@property (nonatomic, strong) NSMutableArray<UITableViewCell *> *suspensionCells; ///< 悬浮的Cell队列

@end

@implementation YJSuspensionCellView

#pragma mark - 刷新数据
- (void)reloadData {
    _showCellHeight = 0;
    self.index = 0;
    self.scrollAnimate = NO;
    if (self.translatesAutoresizingMaskIntoConstraints) {
        self.heightFrame = 0;
    } else {
        [self removeConstraints:self.constraints];
        self.heightLayout.equalToConstant(0);
    }
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self.indexPaths removeAllObjects];
    [self.suspensionCells removeAllObjects];
    for (NSArray<YJTableCellObject *> *array in self.tableViewDelegate.dataSource.dataSourceGrouped) {
        for (YJTableCellObject *co in array) {
            if (co.suspension) {
                [self.indexPaths addObject:co];
            }
        }
    }
}

#pragma mark - 根据YJTableCellObject生成UITableViewCell
- (UITableViewCell *)dequeueReusableCellWithCellObject:(YJTableCellObject *)cellObject {
    // 生成cell
    UITableViewCell *cell;
    if (cell == nil) {
        switch (cellObject.createCell) {
            case YJTableViewCellCreateDefault:
                cell = [[UINib nibWithNibName:cellObject.cellName bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
                break;
            case YJTableViewCellCreateSoryboard:
                NSAssert(NO, @"悬浮cel不支持YJTableViewCellCreateSoryboard创建cell");
                break;
            case YJTableViewCellCreateClass:
                cell = [[cellObject.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                break;
        }
    }
    // 刷新数据
    [cell reloadDataWithCellObject:cellObject tableViewDelegate:self.tableViewDelegate];
    return cell;
}

#pragma mark - tableView滑动显示
#pragma mark tableView上滑
- (void)scrollToTop {
    if (!self.suspensionCells.count) {
        return;
    }
    if (self.translatesAutoresizingMaskIntoConstraints) {
        [self scrollToTopFrame];
    } else {
        [self scrollToTopAutolayout];
    }
}

#pragma mark tableView上滑frame布局
- (void)scrollToTopFrame {
    
}

#pragma mark tableView上滑自动布局
- (void)scrollToTopAutolayout {
    if (self.index <= 0 && self.index >= self.subviews.count) {
        return;
    }
    NSLayoutConstraint *heightConstraint = self.heightLayout.constraint();
    if (!heightConstraint.constant || !self.index) {
        return;
    }
    NSInteger showIndex = self.scrollAnimate ? self.index : self.index-1;
    YJTableCellObject *cellObj = [self.indexPaths objectAtIndex:showIndex];
    CGRect rect = [self.tableView rectForRowAtIndexPath:cellObj.indexPath];
    if (_contentOffsetY > rect.origin.y) {
        return;
    }
    if (showIndex) {
        YJTableCellObject *topCellObj = [self.indexPaths objectAtIndex:showIndex-1];
        CGFloat topRectHeight = [self.tableView rectForRowAtIndexPath:topCellObj.indexPath].size.height;
        if (self.scrollAnimate && heightConstraint.constant >= topRectHeight + _showCellHeight) {
            self.scrollAnimate = NO;
            [self.tableViewDelegate.dataSource reloadRowsAtIndexPaths:@[cellObj]];
            heightConstraint.constant = topRectHeight;
            CGFloat topItemY = 0;
            for (int i = 0; i < self.index-1; i++) {
                topItemY += [self.suspensionCells objectAtIndex:i].heightFrame;
            }
            self.suspensionCells.firstObject.topLayout.costraintTo(self.topLayout).constant = -topItemY;
        } else {
            CGFloat newConstant = rect.origin.y + rect.size.height - self.contentOffsetY;
            NSLayoutConstraint *topItemConstraint = self.suspensionCells.firstObject.topLayout.costraintTo(self.topLayout);
            topItemConstraint.constants(topItemConstraint.constant + (newConstant-heightConstraint.constant));
            heightConstraint.constant = newConstant;
            if (!self.scrollAnimate) {
                self.index --;
                _showCellHeight = [self.suspensionCells objectAtIndex:self.index-1].heightFrame;
            }
            self.scrollAnimate = YES;
        }
    } else {
        self.scrollAnimate = NO;
        [self.tableViewDelegate.dataSource reloadRowsAtIndexPaths:@[cellObj]];
        heightConstraint.constants(0);
        _showCellHeight = 0;
        self.index = 0;
    }
}

#pragma mark tableView下滑
- (void)scrollToBottom {
    if (self.indexPaths.count != self.subviews.count) { // 是否已初始化
        YJTableCellObject *cellObj = [self.indexPaths objectAtIndex:self.subviews.count];
        if (cellObj.indexPath) {
            if (self.suspensionCells.count <= self.subviews.count) {
                [self.suspensionCells addObject:[self dequeueReusableCellWithCellObject:cellObj]];
            }
        }
    }
    if (!self.suspensionCells.count) {
        return;
    }
    if (self.translatesAutoresizingMaskIntoConstraints) {
        [self scrollToBottomFrame];
    } else {
        [self scrollToBottomAutolayout];
    }
}

#pragma mark tableView下滑frame布局
- (void)scrollToBottomFrame {
    
}

#pragma mark tableView下滑自动布局
- (void)scrollToBottomAutolayout {
    // 添加
    if (self.suspensionCells.count != self.subviews.count) {
        UITableViewCell *cell = [self.suspensionCells objectAtIndex:self.subviews.count];
        [self addSubview:cell];
        YJTableCellObject *cellObj = [self.indexPaths objectAtIndex:self.subviews.count-1];
        CGRect rect = [self.tableView rectForRowAtIndexPath:cellObj.indexPath];
        cell.leadingSpaceToSuper(0);
        cell.heightLayout.equalToConstant(rect.size.height);
        cell.widthLayout.equalToConstant(rect.size.width);
        if (self.subviews.count >= 2) {
            cell.topLayout.equalTo(self.subviews[self.subviews.count-2].bottomLayout);
        } else {
            cell.topSpaceToSuper(0);
        }
    }
    // 显示
    if (self.index < 0 || self.index >= self.subviews.count) {
        return;
    }
    NSLayoutConstraint *heightConstraint = self.heightLayout.constraint();
    if (!heightConstraint) {
        heightConstraint = self.heightLayout.equalToConstant(0);
    }
    YJTableCellObject *cellObj = [self.indexPaths objectAtIndex:self.index];
    CGRect rect = [self.tableView rectForRowAtIndexPath:cellObj.indexPath];
    self.scrollAnimate = NO;
    if (self.index) {
        if (_contentOffsetY + _showCellHeight > rect.origin.y + rect.size.height) {
            self.heightLayout.equalToConstant(rect.size.height);
            _showCellHeight = rect.size.height;
            CGFloat topItemY = 0;
            for (int i = 0; i < self.index; i++) {
                topItemY += [self.suspensionCells objectAtIndex:i].heightFrame;
            }
            self.suspensionCells.firstObject.topLayout.costraintTo(self.topLayout).constant = -topItemY;
            self.index ++;
        } else if (_contentOffsetY + _showCellHeight > rect.origin.y) {
            self.scrollAnimate = YES;
            CGFloat newConstant = rect.origin.y + rect.size.height - _contentOffsetY;
            NSLayoutConstraint *topItemConstraint = self.subviews.firstObject.topLayout.costraintTo(self.topLayout);
            if (heightConstraint.constant < newConstant) {
                [[self.suspensionCells objectAtIndex:self.index] reloadDataWithCellObject:cellObj tableViewDelegate:self.tableViewDelegate];
                topItemConstraint.constants(topItemConstraint.constant - (heightConstraint.constant+rect.size.height-newConstant));
            } else {
                topItemConstraint.constants(topItemConstraint.constant - (heightConstraint.constant-newConstant));
            }
            heightConstraint.constants(newConstant);
        }
    } else {
        self.subviews.firstObject.topSpaceToSuper(0);
        if (_contentOffsetY > rect.origin.y) {
            [self.suspensionCells.firstObject reloadDataWithCellObject:cellObj tableViewDelegate:self.tableViewDelegate];
            heightConstraint.constants(rect.size.height);
            _showCellHeight = rect.size.height;
            self.index ++;
        }
    }
}

#pragma mark - setter and getter
- (UITableView *)tableView {
    return self.tableViewDelegate.dataSource.tableView;
}

- (NSMutableArray<YJTableCellObject *> *)indexPaths {
    if (!_indexPaths) {
        _indexPaths = [NSMutableArray array];
    }
    return _indexPaths;
}

- (NSMutableArray<UITableViewCell *> *)suspensionCells {
    if (!_suspensionCells) {
        _suspensionCells = [NSMutableArray array];
    }
    return _suspensionCells;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    if (!self.indexPaths.count) {
        return;
    }
    BOOL goBottom = contentOffsetY > _contentOffsetY;
    _contentOffsetY = contentOffsetY;
    goBottom ? [self scrollToBottom] : [self scrollToTop];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    NSLog(@"%ld", (long)index);
}

@end

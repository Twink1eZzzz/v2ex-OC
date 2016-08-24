//
//  WTMemberTopicViewController.m
//  v2ex
//
//  Created by gengjie on 16/8/24.
//  Copyright © 2016年 无头骑士 GJ. All rights reserved.
//

#import "WTMemberTopicViewController.h"
#import "WTTopicDetailViewController.h"

#import "WTTopicCell.h"

#import "WTTopicDetailViewModel.h"
#import "WTMemberTopicViewModel.h"

#import "WTRefreshNormalHeader.h"
#import "WTRefreshAutoNormalFooter.h"

#import "UITableView+FDTemplateLayoutCell.h"

NSString * const WTMemberTopicIdentifier = @"WTMemberTopicIdentifier";

@interface WTMemberTopicViewController ()
@property (nonatomic, strong) WTMemberTopicViewModel *memberTopicVM;
@end

@implementation WTMemberTopicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.memberTopicVM = [WTMemberTopicViewModel new];
    
    // 设置View
    [self setupView];
    
}

// 设置View
- (void)setupView
{
    
    self.title = @"我的回复";
    
    // tableView
    {
        // 自动计算行高
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 128.5;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([WTTopicCell class]) bundle: nil] forCellReuseIdentifier: WTMemberTopicIdentifier];
        
        // 添加下拉刷新、上拉刷新
        //        self.tableView.mj_header = [WTRefreshNormalHeader headerWithRefreshingTarget: self refreshingAction: @selector(loadNewData)];
        self.tableView.mj_footer = [WTRefreshAutoNormalFooter footerWithRefreshingTarget: self refreshingAction: @selector(loadOldData)];
        
        // 空白tableView
        //        self.tableView.emptyDataSetSource = self;
        //        self.tableView.emptyDataSetDelegate = self;
    }
    
    [self loadNewData];
}

#pragma mark - 加载数据
#pragma mark 加载最新的数据
- (void)loadNewData
{
    self.memberTopicVM.page = 1;
    
    [self.memberTopicVM getMemberTopicsWithUsername: self.topicDetailVM.topicDetail.author iconURL: self.topicDetailVM.iconURL success:^{
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark 加载旧的数据
- (void)loadOldData
{
    if (self.memberTopicVM.isNextPage)
    {
        [self.memberTopicVM getMemberTopicsWithUsername: self.topicDetailVM.topicDetail.author iconURL: self.topicDetailVM.iconURL success:^{
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
        }];
    }
    else
    {
        [self.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.memberTopicVM.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTTopicCell *cell = [tableView dequeueReusableCellWithIdentifier: WTMemberTopicIdentifier];
    
    cell.topic = self.memberTopicVM.topics[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier: WTMemberTopicIdentifier cacheByIndexPath: indexPath configuration:^(WTTopicCell *cell) {
        cell.topic = self.memberTopicVM.topics[indexPath.row];
    }];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中的效果
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    // 跳转至话题详情控制器
    WTTopic *topic = self.memberTopicVM.topics[indexPath.row];
    WTTopicDetailViewController *detailVC = [WTTopicDetailViewController new];
    detailVC.topicDetailUrl = topic.detailUrl;
    [self.navigationController pushViewController: detailVC animated: YES];
}


@end

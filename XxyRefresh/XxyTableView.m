//
//  XxyTableView.m
//  SlimeRefresh
//
//  Created by Apple on 14-6-10.
//  Copyright (c) 2014年 zrz. All rights reserved.
//

#import "XxyTableView.h"


@implementation XxyTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if(_dataArr == nil){
            _dataArr = [[NSMutableArray alloc] init];
        }
        _finishedLoadData = NO;
        
    }
    return self;
}



- (void)loadMoreView
{
    if (_moreBtn) {
        _haveMore = YES;
        moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.backgroundColor = [UIColor clearColor];
        moreButton.frame = CGRectMake(5, 5, 310, 35);
        moreButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        [moreButton setTitle:moreBtnNorTitle forState:UIControlStateNormal];
        [moreButton setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
        moreActivityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        moreActivityView.frame = CGRectMake(80, 10, 20, 20);
        [moreActivityView stopAnimating];
        moreActivityView.tag = 500;
        [moreButton addSubview:moreActivityView];
        self.tableFooterView = moreButton;
        [self.tableFooterView setBackgroundColor:[UIColor clearColor]];
        //[self.tableFooterView setHidden:YES];
    }
}

//设置下拉加载更多是否可用 以及各个状态的标题
- (void)setMoreBtn:(BOOL)moreBtn normalTitle:(NSString *)norTit loadingTitle:(NSString *)loaTit noMoreTit:(NSString *)noTit
{
    _moreBtn = moreBtn;
    moreBtnNorTitle = norTit;
    moreBtnLoaTitle = loaTit;
    moreBtnNoTitle = noTit;
    [self loadMoreView];
    
}

//加载更多
- (void)loadMoreAction
{
    [moreActivityView startAnimating];
    [moreButton setTitle:moreBtnLoaTitle forState:UIControlStateNormal];
    _loBlock();
}
//完成加载更多
- (void)fininshedLoadMore
{
    if (!_moreBtn) {
        return;
    }
    if (_haveMore == NO) {
        [moreActivityView stopAnimating];
        [moreButton setTitle:moreBtnNoTitle forState:UIControlStateNormal];
        [moreButton setEnabled:NO];
    }else{
        [moreActivityView stopAnimating];
        [moreButton setTitle:moreBtnNorTitle forState:UIControlStateNormal];
    }
}

- (void)didScroll
{
    if (!_finishedLoadData) {
        //NSLog(@"还没加载完数据");
        return;
    }
}

- (void)didEndDraging:(UIScrollView *)scrollView
{
    if (!_finishedLoadData) {
        return;
    }
    float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float delt = contentHeight - offset;
    if (delt < 490) {
        if (!_haveMore) {
            return;
        }
        [self loadMoreAction];
    }
}


@end

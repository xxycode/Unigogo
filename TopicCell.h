//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖保佑             永无BUG
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//
//  TopicCell.h
//  Unigogo
//
//  Created by xxy on 14-7-7.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "XxyHttpRequest.h"
#import "TopicItem.h"
#import "TQRichTextView.h"
#import "TagLabel.h"
#import "TopExButton.h"
#import "JuBaoTableAlert.h"

typedef void(^noTokenBlock)(void);
typedef void(^commentBlock)(BOOL hasOne,NSString *tid);
typedef void (^delBlock)(NSIndexPath *indexPath);
typedef void (^delPreBlock)(NSIndexPath *indexPath,NSString *tid);
typedef void (^showProBlock)(NSString *uid);

@interface TopicCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *fromImage;
    UILabel *fromName;
    UIImageView *itemImage;
    TQRichTextView *contentTextView;
    UIView *bgView;
    UIImageView *imgV;
    UIScrollView *scView;
    MBProgressHUD *HUD;
    CGRect orgFrame;
    UILabel *timeLabel;
    BOOL isPer;
    BOOL canDelet;
    CGFloat starX;
    CGFloat cellX;
    CGFloat delt;
    UIImageView *hotView;
    TopExButton *commentBtn;
    TopExButton *repostBtn;
    TopExButton *zanBtn;
    TopExButton *favBtn;
    UILabel *hotLabel;
    UIImageView *tagView;
    UILabel *tagLabel;
    UIImageView *xinView;
    UIImageView *handView;
    UIButton *deleteButton;
    UIButton *delBtn;
    JuBaoTableAlert *typeSelectView;
    NSArray *itemsTypes;
    NSInteger currJtype;
}
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) TopicItem *item;
@property (nonatomic, strong) noTokenBlock noToken;
@property (nonatomic, strong) commentBlock comBlock;
@property (nonatomic, strong) delBlock delActionBlock;
@property (nonatomic, strong) delPreBlock delPreActionBlock;
@property (nonatomic, strong) showProBlock showProfileBlock;
+ (CGFloat)cellHeightForItem:(TopicItem *)item isPer:(BOOL)per;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier personal:(BOOL)per deleteAble:(BOOL)deletable;

@end

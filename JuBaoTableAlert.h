//
//  JuBaoTableAlert.h
//  Unigogo
//
//  Created by xxy on 14-7-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class JuBaoTableAlert;
// Blocks definition for table view management
typedef NSInteger (^JuBaoTableAlertNumberOfRowsBlock)(NSInteger section);
typedef UITableViewCell* (^JuBaoTableAlertTableCellsBlock)(JuBaoTableAlert *alert, NSIndexPath *indexPath);
typedef void (^JuBaoTableAlertRowSelectionBlock)(NSIndexPath *selectedIndex);
typedef void (^JuBaoTableAlertCompletionBlock)(void);


@interface JuBaoTableAlert : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) JuBaoTableAlertCompletionBlock completionBlock;	// Called when Cancel button pressed
@property (nonatomic, strong) JuBaoTableAlertRowSelectionBlock selectionBlock;	// Called when a row in table view is pressed
@property (nonatomic, strong) UIButton *okButton;

// Classe method; rowsBlock and cellsBlock MUST NOT be nil
+(JuBaoTableAlert *)tableAlertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(JuBaoTableAlertNumberOfRowsBlock)rowsBlock andCells:(JuBaoTableAlertTableCellsBlock)cellsBlock;

// Initialization method; rowsBlock and cellsBlock MUST NOT be nil
-(id)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelBtnTitle numberOfRows:(JuBaoTableAlertNumberOfRowsBlock)rowsBlock andCells:(JuBaoTableAlertTableCellsBlock)cellsBlock;

// Allows you to perform custom actions when a row is selected or the cancel button is pressed
-(void)configureSelectionBlock:(JuBaoTableAlertRowSelectionBlock)selBlock andCompletionBlock:(JuBaoTableAlertCompletionBlock)comBlock;

// Show the alert
-(void)show;

-(void)dismissTableAlert;

@end

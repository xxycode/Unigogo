//
//  FaceView.m
//  Unigogo
//
//  Created by xxy on 14-7-6.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "FaceView.h"
#import "FaceItemView.h"

@implementation FaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self setContentSize:CGSizeMake(kScreenWidth * 4, 165)];
    [self setPagingEnabled:YES];
    faceArr = [NSArray arrayWithObjects:@"[01]",@"[02]",@"[03]",@"[04]",@"[05]",@"[06]",@"[07]",@"[08]",@"[09]",@"[10]",@"[11]",@"[12]",@"[13]",@"[14]",@"[15]",@"[16]",@"[17]",@"[18]",@"[19]",@"[20]",@"[21]",@"[22]",@"[23]",@"[24]",@"[25]",@"[26]",@"[27]",@"[28]",@"[29]",@"[30]",@"[31]",@"[32]",@"[33]",@"[34]",@"[35]",@"[36]",@"[37]",@"[38]",@"[39]",@"[40]",@"[41]",@"[42]",@"[43]",@"[44]",@"[45]",@"[46]",@"[47]",@"[48]",@"[49]",@"[50]",@"[51]",@"[52]",@"[53]",@"[54]",@"[55]",@"[56]",@"[57]",@"[58]",@"[59]",@"[60]",@"[61]",@"[62]",@"[63]",@"[64]",@"[65]",@"[66]",@"[67]",@"[68]",@"[69]",nil];
    CGFloat curS_X = 0;
    
    for (int i = 0; i < 4; i ++) {
        UIView *fac = [[UIView alloc] initWithFrame:CGRectMake(curS_X, 0, kScreenWidth, 165)];
        [self addSubview:fac];
        CGFloat curV_Y = 13.75;
        int flag = 1;
        for (int j = 0; j < 3; j ++) {
            CGFloat curV_X = 13.75;
            for (int k = 0; k < 7; k ++) {
                if (i*20+j*7+k >= 69) {
                    FaceItemView *faceBtn = [[FaceItemView alloc] initWithFrame:CGRectMake(curV_X, curV_Y, 30, 30)];
                    curV_X += 30 + 13.75;
                    [faceBtn setImage:[UIImage imageNamed:@"delface.png"] forState:UIControlStateNormal];
                    [faceBtn setFaceString:@"-1"];
                    [fac addSubview:faceBtn];
                    [faceBtn addTarget:self action:@selector(faceItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    flag = 0;
                    break;
                    flag = 0;
                    break;
                }
                if (j == 2 && k == 6) {
                    FaceItemView *faceBtn = [[FaceItemView alloc] initWithFrame:CGRectMake(curV_X, curV_Y, 30, 30)];
                    [faceBtn setFaceString:@"-1"];
                    curV_X += 30 + 13.75;
                    [faceBtn setImage:[UIImage imageNamed:@"delface.png"] forState:UIControlStateNormal];
                    [fac addSubview:faceBtn];
                    [faceBtn addTarget:self action:@selector(faceItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    flag = 0;
                    break;
                }
                NSString *imgId = [faceArr objectAtIndex:i*20+j*7+k];
                FaceItemView *faceBtn = [[FaceItemView alloc] initWithFrame:CGRectMake(curV_X, curV_Y, 30, 30)];
                curV_X += 30 + 13.75;
                NSString *imgName = [NSString stringWithFormat:@"%@.png",imgId];
                [faceBtn setFaceString:imgId];
                [faceBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
                [faceBtn addTarget:self action:@selector(faceItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                [fac addSubview:faceBtn];
            }
            if (flag == 0) {
                break;
            }
            curV_Y += 30 + 13.75;
        }
        curS_X += kScreenWidth;
    }
}


- (void)faceItemClicked:(FaceItemView *)btn
{
    if (self.clickBlock != nil) {
        self.clickBlock(btn.faceString);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

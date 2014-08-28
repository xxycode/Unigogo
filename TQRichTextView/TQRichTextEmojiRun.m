//
//  TQRichTextEmojiRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "TQRichTextEmojiRun.h"

@implementation TQRichTextEmojiRun

- (id)init
{
    self = [super init];
    if (self) {
        self.type = richTextEmojiRunType;
        self.isResponseTouch = NO;
    }
    return self;
}

- (BOOL)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",self.originalText];
    
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
    return YES;
}

+ (NSArray *) emojiStringArray
{
    return [NSArray arrayWithObjects:@"[01]",@"[02]",@"[03]",@"[04]",@"[05]",@"[06]",@"[07]",@"[08]",@"[09]",@"[10]",@"[11]",@"[12]",@"[13]",@"[14]",@"[15]",@"[16]",@"[17]",@"[18]",@"[19]",@"[20]",@"[21]",@"[22]",@"[23]",@"[24]",@"[25]",@"[26]",@"[27]",@"[28]",@"[29]",@"[30]",@"[31]",@"[32]",@"[33]",@"[34]",@"[35]",@"[36]",@"[37]",@"[38]",@"[39]",@"[40]",@"[41]",@"[42]",@"[43]",@"[44]",@"[45]",@"[46]",@"[47]",@"[48]",@"[49]",@"[50]",@"[51]",@"[52]",@"[53]",@"[54]",@"[55]",@"[56]",@"[57]",@"[58]",@"[59]",@"[60]",@"[61]",@"[62]",@"[63]",@"[64]",@"[65]",@"[66]",@"[67]",@"[68]",@"[69]",nil];
}

+ (NSString *)analyzeText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    NSString *markL = @"[";
    NSString *markR = @"]";
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:string.length];
    
    //偏移索引 由于会把长度大于1的字符串替换成一个空白字符。这里要记录每次的偏移了索引。以便简历下一次替换的正确索引
    int offsetIndex = 0;
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                for (NSString *c in stack)
                {
                    [newString appendString:c];
                }
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                
                if ([[TQRichTextEmojiRun emojiStringArray] containsObject:emojiStr])
                {
                    TQRichTextEmojiRun *emoji = [[TQRichTextEmojiRun alloc] init];
                    emoji.range = NSMakeRange(i + 1 - emojiStr.length - offsetIndex, 1);
                    emoji.originalText = emojiStr;
                    [*runArray addObject:emoji];
                    [newString appendString:@" "];
                    
                    offsetIndex += emojiStr.length - 1;
                }
                else
                {
                    [newString appendString:emojiStr];
                }
                
                [stack removeAllObjects];
            }
        }
        else
        {
            [newString appendString:s];
        }
    }

    return newString;
}

@end

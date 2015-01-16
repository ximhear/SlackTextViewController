//
//  SPHLeftBubbleCell.h
//  NewChatBubble
//
//  Created by Siba Prasad Hota  on 1/3/15.
//  Copyright (c) 2015 Wemakeappz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TextCellDelegate;

@interface SPHTextBubbleCell : UITableViewCell
{
    UIImageView *messageBackgroundView;
}

@property (nonatomic,strong) NSString *bubbletype;
@property (nonatomic,strong) UIImageView *AvatarImageView;
@property(nonatomic, readonly) UILabel* topDateLabel;
@property(nonatomic, readonly) UIView* whisperView;
@property(nonatomic, readonly) UIView* nameView;
@property(nonatomic, readonly) UIView* menuView;

@property(nonatomic, assign) BOOL showDateSeparator;
@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* name;
@property(nonatomic, strong) NSString* whisperUserName;

+(CGFloat)height:(NSString*)message showDateSeparator:(BOOL)showDateSeparator bubbleType:(NSString*)bubbletype frame:(CGRect)frame name:(NSString*)name whisperUserName:(NSString*)whisperUserName;

@end


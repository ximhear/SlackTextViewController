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

@property(nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic,strong) NSString *bubbletype;
@property (nonatomic,strong) UIImageView *AvatarImageView;
@property(nonatomic, readonly) UILabel* topDateLabel;
@property(nonatomic, readonly) UILabel* nameLabel;
@property(nonatomic, readonly) UIView* menuView;

@property(nonatomic, assign) BOOL showDateSeparator;
@property(nonatomic, strong) NSDate* date;
@property(nonatomic, strong) NSString* name;

@property (nonatomic, assign) id <TextCellDelegate> CustomDelegate;

- (void)showMenu;


@end


@protocol TextCellDelegate
@required

-(void)textCellDidTapped:(SPHTextBubbleCell *)tesxtCell AndGesture:(UIGestureRecognizer*)tapGR;

-(void)cellCopyPressed:(SPHTextBubbleCell *)tesxtCell;
-(void)cellForwardPressed:(SPHTextBubbleCell *)tesxtCell;
-(void)cellDeletePressed:(SPHTextBubbleCell *)tesxtCell;


@end


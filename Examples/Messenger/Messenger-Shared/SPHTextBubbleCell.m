//
//  SPHLeftBubbleCell.m
//  NewChatBubble
//
//  Created by Siba Prasad Hota  on 1/3/15.
//  Copyright (c) 2015 Wemakeappz. All rights reserved.
//

#import "SPHTextBubbleCell.h"
#import "UIImage+Utils.h"
#import "Constantvalues.h"
#import "GZLog.h"

@interface SPHTextBubbleCell ()

@property(nonatomic, strong) UILabel* topDateLabel;
@property(nonatomic, strong) UIView* whisperView;
@property(nonatomic, strong) UIView* nameView;
@property(nonatomic, strong) UIView* menuView;

@end


@implementation SPHTextBubbleCell

// ***********************************================================================******************************//

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if ([[UIDevice currentDevice].systemVersion floatValue] < 7.0f) {
            self.textLabel.backgroundColor = [UIColor whiteColor];
        }
        self.textLabel.font = [UIFont systemFontOfSize:14.0f];
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = [UIColor whiteColor];
        
        _topDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _topDateLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _topDateLabel.textAlignment = NSTextAlignmentCenter;
        _topDateLabel.backgroundColor = [UIColor grayColor];
        _topDateLabel.font = [UIFont systemFontOfSize:12.0f];
        _topDateLabel.textColor = [UIColor blackColor];
        _topDateLabel.frame = CGRectMake(10.0f, 6, self.bounds.size.width -20, 18);
        [self.contentView addSubview:_topDateLabel];
        [[_topDateLabel layer] setMasksToBounds:YES];
        [[_topDateLabel layer] setCornerRadius:_topDateLabel.frame.size.height/2.0];
        
        self.whisperView = [[UIView alloc] initWithFrame:CGRectZero];
        self.whisperView.backgroundColor = [UIColor yellowColor];
        
        self.nameView = [[UIView alloc] initWithFrame:CGRectZero];
        self.nameView.backgroundColor = [UIColor redColor];
        
//        self.nameLabel.textAlignment = NSTextAlignmentLeft;
//        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
//        self.nameLabel.textColor = [UIColor darkGrayColor];
        
        self.menuView = [[UIView alloc] initWithFrame:CGRectZero];
        self.menuView.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:self.whisperView];
        [self.contentView addSubview:self.nameView];
        [self.contentView addSubview:self.menuView];
        
        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];
        
        self.AvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,10+TOP_MARGIN, 50, 50)];
       
        [self.contentView addSubview:self.AvatarImageView];
        
        CALayer * l = [self.AvatarImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:self.AvatarImageView.frame.size.width/2.0];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    }
    
    return self;
}


// ***********************************================================================******************************//
// **********************| LAYOUT CELL |****************************************************************************//
// ***********************************================================================******************************//


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat y;
    self.showDateSeparator = (self.textLabel.tag % 2 == 0 ? YES : NO);
    if (self.showDateSeparator) {
        _topDateLabel.frame = CGRectMake(10.0f, 6, self.bounds.size.width -20, 18);
        y = 24;
    }
    else {
        _topDateLabel.frame = CGRectZero;
        y = 0;
    }
    
//    GZLogCGRect(self.frame);
    
    self.bubbletype = (self.textLabel.tag % 2 == 0 ? @"LEFT" : @"RIGHT");
    if ([self.bubbletype isEqualToString:@"LEFT"])
    {
        CGFloat offset = 68 + 16 + 10 + 60;
        CGSize labelSize =[self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width-offset, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                            context:nil].size;
        self.whisperUserName = @"whisper";
        if (self.whisperUserName) {
            self.whisperView.frame = CGRectMake(68, y+4, self.bounds.size.width -68-10, 18);
            y += 4 + 18;
        }
        else {
            self.whisperView.frame = CGRectZero;
        }
        
        self.name = @"hello";
        if (self.name) {
            self.nameView.frame = CGRectMake(68, y+4, self.bounds.size.width -68-10, 18);
//            self.nameLabel.text = self.name;
            y += 4 + 18;
        }
        else {
            self.nameView.frame = CGRectZero;
        }
        
        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.origin.x = 68;
        textLabelFrame.origin.y = y + 4 + 12;
        textLabelFrame.size.width = self.frame.size.width - offset;
        textLabelFrame.size.height = labelSize.height;
        self.textLabel.frame = textLabelFrame;
        messageBackgroundView.frame = CGRectMake(60, textLabelFrame.origin.y - 12, labelSize.width + 16,labelSize.height + 18);
        self.AvatarImageView.frame=CGRectMake(5,10+TOP_MARGIN, 50, 50);
        self.menuView.frame = CGRectMake(messageBackgroundView.frame.origin.x + messageBackgroundView.frame.size.width, messageBackgroundView.frame.origin.y+messageBackgroundView.frame.size.height - 30, 60, 30);
      
        messageBackgroundView.image = [[UIImage imageNamed:@"talk_bubble_left.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:25];
        
    }
    else {
        // Right
        CGFloat offset = 10 + 60 + 16   + 8 + 10;
        CGSize labelSize =[self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width-offset, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                            context:nil].size;
        
        self.whisperUserName = @"whisper";
        if (self.whisperUserName) {
            self.whisperView.frame = CGRectMake(0, y+4, self.bounds.size.width -10, 18);
            y += 4 + 18;
        }
        else {
            self.whisperView.frame = CGRectZero;
        }
        
        self.name = @"hello";
        if (self.name) {
            self.nameView.frame = CGRectMake(0, y+4, self.bounds.size.width -10, 18);
//            self.nameLabel.text = self.name;
//            self.nameLabel.textAlignment = NSTextAlignmentRight;
            y += 4 + 18;
        }
        else {
            self.nameView.frame = CGRectZero;
        }
        
        CGRect textLabelFrame = self.textLabel.frame;
        textLabelFrame.size.width = labelSize.width;
        textLabelFrame.size.height = labelSize.height;
        textLabelFrame.origin.y = y + 4 + 12;
        textLabelFrame.origin.x = self.frame.size.width - labelSize.width - 8 - 10;
        self.textLabel.frame = textLabelFrame;
        
        messageBackgroundView.frame = CGRectMake(textLabelFrame.origin.x - 16, textLabelFrame.origin.y - 12, labelSize.width + 16 + 8, labelSize.height + 18);
         messageBackgroundView.image = [[UIImage imageNamed:@"talk_bubble_right.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:25];
        
        self.menuView.frame = CGRectMake(messageBackgroundView.frame.origin.x - 60, messageBackgroundView.frame.origin.y+messageBackgroundView.frame.size.height - 30, 60, 30);
        self.AvatarImageView.frame = CGRectZero;
    }
    
}

// ***********************************================================================******************************//

//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor);
//    
//    CGContextSetLineWidth(context, 1.0);
//    CGContextMoveToPoint(context, 0, 21); //start at this point
//    CGContextAddLineToPoint(context, (self.bounds.size.width - 120) / 2, 21); //draw to this point
//    
//    CGContextMoveToPoint(context, self.bounds.size.width, 21); //start at this point
//    CGContextAddLineToPoint(context, self.bounds.size.width - (self.bounds.size.width - 120) / 2, 21); //draw to this point
//    
//    CGContextStrokePath(context);
//    
//}

// ***********************************================================================******************************//

+(CGFloat)height:(NSString*)message showDateSeparator:(BOOL)showDateSeparator bubbleType:(NSString*)bubbletype frame:(CGRect)frame name:(NSString*)name  whisperUserName:(NSString*)whisperUserName {
    
    CGFloat y;
//    showDateSeparator = NO;
    if (showDateSeparator) {
        y = 24;
    }
    else {
        y = 0;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
//    GZLogCGRect(frame);
    if ([bubbletype isEqualToString:@"LEFT"])
    {
        CGFloat offset = 68 + 16 + 10 + 60;
        CGSize labelSize =[message boundingRectWithSize:CGSizeMake(frame.size.width-offset, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
        
        if (whisperUserName) {
            y += 4 + 18;
        }
        
        if (name) {
            y += 4 + 18;
        }
        
        y = y + 4 + labelSize.height + 18;
        
        // 2는 여유 공간.
        return y > 10+TOP_MARGIN + 50? y + 2: 10 + TOP_MARGIN + 50 + 2;
    }
    else {
        // Right
        CGFloat offset = 10 + 60 + 16   + 8 + 10;
        CGSize labelSize =[message boundingRectWithSize:CGSizeMake(frame.size.width-offset, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
        
        if (whisperUserName) {
            y += 4 + 18;
        }
        
        if (name) {
            y += 4 + 18;
        }
        
        // 2는 여유 공간.
        y = y + 4 + labelSize.height + 18 + 2;
        
        return y;
    }
}
@end

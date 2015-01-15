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
@property(nonatomic, strong) UILabel* nameLabel;
@property(nonatomic, strong) UIView* menuView;

@end


@implementation SPHTextBubbleCell

@synthesize timestampLabel = _timestampLabel;


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
        
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timestampLabel.textAlignment = NSTextAlignmentCenter;
        _timestampLabel.backgroundColor = [UIColor grayColor];
        _timestampLabel.font = [UIFont systemFontOfSize:12.0f];
        _timestampLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        _timestampLabel.frame = CGRectMake(0.0f, 12, self.bounds.size.width, 18);
        
//        [self.contentView addSubview:_timestampLabel];
        
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
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.backgroundColor = [UIColor redColor];
        self.nameLabel.font = [UIFont systemFontOfSize:12.0f];
        self.nameLabel.textColor = [UIColor darkGrayColor];
        
        self.menuView = [[UIView alloc] initWithFrame:CGRectZero];
        self.menuView.backgroundColor = [UIColor redColor];
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.menuView];
        
        messageBackgroundView = [[UIImageView alloc] initWithFrame:self.textLabel.frame];
        [self.contentView insertSubview:messageBackgroundView belowSubview:self.textLabel];
        
        self.AvatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5,10+TOP_MARGIN, 50, 50)];
       
        [self.contentView addSubview:self.AvatarImageView];
        
        CALayer * l = [self.AvatarImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:self.AvatarImageView.frame.size.width/2.0];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
//        lpgr.minimumPressDuration = .4; //seconds
//        lpgr.delegate = self;
//        [self addGestureRecognizer:lpgr];
        
    }
    
    return self;
}


// ***********************************================================================******************************//
// **********************| DELEGATE FUNCTIONS OF  CELL |****************************************************************************//
// ***********************************================================================******************************//


-(void)tapRecognized:(UITapGestureRecognizer *)tapGR
{
    [self.CustomDelegate textCellDidTapped:self AndGesture:tapGR];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)|| action==@selector(forward:) || action==@selector(delete:)) {
        return YES;
    }
    return NO;
}
- (IBAction)copy:(id)sender
{
    [self.CustomDelegate cellCopyPressed:self];
}

- (IBAction)forward:(id)sender
{
    [self.CustomDelegate cellForwardPressed:self];
}

- (IBAction)delete:(id)sender
{
    [self.CustomDelegate cellDeletePressed:self];
}

- (void)showMenu
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self becomeFirstResponder];
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"Forward" action:@selector(forward:)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:menuItem,nil]];
    [[UIMenuController sharedMenuController] update];
    CGRect textFrame=self.textLabel.frame; textFrame.origin.x-=50;
    [[UIMenuController sharedMenuController] setTargetRect:textFrame inView:self];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    
}

// ***********************************================================================******************************//
// **********************| LAYOUT CELL |****************************************************************************//
// ***********************************================================================******************************//


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat y;
    self.showDateSeparator = YES;
    if (self.showDateSeparator) {
        _topDateLabel.frame = CGRectMake(10.0f, 6, self.bounds.size.width -20, 18);
        y = 24;
    }
    else {
        _topDateLabel.frame = CGRectZero;
        y = 0;
    }
    
    GZLogCGRect(self.frame);
    
    self.bubbletype = @"LEFT";
    if ([self.bubbletype isEqualToString:@"LEFT"])
    {
        CGFloat offset = 68 + 16 + 10 + 60;
        CGSize labelSize =[self.textLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width-offset, MAXFLOAT)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:14.0f] }
                                                            context:nil].size;
        self.name = @"hello";
        if (self.name) {
            self.nameLabel.frame = CGRectMake(68, y+4, self.bounds.size.width -68-10, 18);
            self.nameLabel.text = self.name;
            y += 4 + 18;
        }
        else {
            self.nameLabel.frame = CGRectZero;
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
        
        self.name = @"hello";
        if (self.name) {
            self.nameLabel.frame = CGRectMake(0, y+4, self.bounds.size.width -10, 18);
            self.nameLabel.text = self.name;
            self.nameLabel.textAlignment = NSTextAlignmentRight;
            y += 4 + 18;
        }
        else {
            self.nameLabel.frame = CGRectZero;
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

@end

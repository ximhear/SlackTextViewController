//
//  UserInvitationView.m
//  Messenger
//
//  Created by C.H Lee on 1/16/15.
//  Copyright (c) 2015 Slack Technologies, Inc. All rights reserved.
//

#import "UserInvitationView.h"
#import "GZLog.h"

@interface UserInvitationView ()

@property(nonatomic, strong) void (^selectBlock)(NSDictionary*);
@property(nonatomic, strong) void (^closeBlock)(void);

@end

@implementation UserInvitationView

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadView];
    }
    
    return self;
}

-(void)dealloc {
    GZLogFunc0();
    
}

-(void)loadView {
    
    UIView* containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];

    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeBtn];

    {
        NSDictionary *views = @{@"containerView": containerView,
                                @"closeBtn":closeBtn,
                                @"self":self,
                                };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[containerView]-20-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[containerView]-10-|" options:0 metrics:nil views:views]];
        
        [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0@750)-[closeBtn(44)]-10-|" options:0 metrics:nil views:views]];
        
        NSLayoutConstraint* c1 = [NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:containerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint* c2 = [NSLayoutConstraint constraintWithItem:closeBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:60];
        [containerView addConstraints:@[c1, c2]];
    }
}

-(void)setActionBlock:(void (^)(NSDictionary*))selectBlock closeBlock:(void (^)(void))closeBlock {
    
    self.selectBlock = selectBlock;
    self.closeBlock = closeBlock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)closeBtnClicked:(id)sender {
    GZLogFunc0();
    
    if (self.closeBlock) {
        self.closeBlock();
    }
}

@end

//
//  UserInvitationView.h
//  Messenger
//
//  Created by C.H Lee on 1/16/15.
//  Copyright (c) 2015 Slack Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInvitationView : UIView

-(void)setActionBlock:(void (^)(NSDictionary*))selectBlock closeBlock:(void (^)(void))closeBlock;

@end

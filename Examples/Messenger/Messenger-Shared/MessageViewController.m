//
//  MessageViewController.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "SPHTextBubbleCell.h"
#import "Constantvalues.h"
#import "GZLog.h"
#import "UserInvitationView.h"

#import <LoremIpsum/LoremIpsum.h>

@interface MessageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, assign) BOOL invitationViewExpanded;
@property(nonatomic, assign) BOOL userInvitationViewShowed;
@property(nonatomic, strong) UICollectionView* userCollectionView;

@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSArray *channels;
@property (nonatomic, strong) NSArray *emojis;

@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation MessageViewController

- (id)init
{
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        
        self.users = @[@"Allen", @"Anna", @"Alicia", @"Arnold", @"Armando", @"Antonio", @"Brad", @"Catalaya", @"Christoph", @"Emerson", @"Eric", @"Everyone", @"Steve"];
        self.channels = @[@"General", @"Random", @"iOS", @"Bugs", @"Sports", @"Android", @"UI", @"SSB"];
        self.emojis = @[@"m", @"man", @"machine", @"block-a", @"block-b", @"bowtie", @"boar", @"boat", @"book", @"bookmark", @"neckbeard", @"metal", @"fu", @"feelsgood"];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder
{
    return UITableViewStylePlain;
}


#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.userCollectionView = collectionView;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [collectionView setBackgroundColor:[UIColor redColor]];

    [self setupViewConstraints:^{
        self.navigationViewHC.constant = 40;
        self.invitationViewHC.constant = 40;
        self.whisperViewHC.constant = 40;
        
        {
            UIButton* backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            backBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [backBtn setTitle:@"Back" forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.navigationView addSubview:backBtn];
            
            NSDictionary *views = @{@"backBtn": backBtn};
            [self.navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[backBtn]-5-|" options:0 metrics:nil views:views]];
            [self.navigationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backBtn(80)]-(>=0@750)-|" options:0 metrics:nil views:views]];
        }
        
        {
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
            titleLabel.text = @"대화방";
            [self.invitationView addSubview:titleLabel];
            
            UIButton* expandBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            expandBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [expandBtn setTitle:@"Expand" forState:UIControlStateNormal];
            [expandBtn addTarget:self action:@selector(expandBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.invitationView addSubview:expandBtn];
            
            UIButton* inviteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            inviteBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [inviteBtn setTitle:@"Invite" forState:UIControlStateNormal];
            [inviteBtn addTarget:self action:@selector(inviteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.invitationView addSubview:inviteBtn];
            
            UIButton* exitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            exitBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [exitBtn setTitle:@"Exit" forState:UIControlStateNormal];
            [exitBtn addTarget:self action:@selector(exitBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.invitationView addSubview:exitBtn];
            
            [self.invitationView addSubview:collectionView];

            NSDictionary *views = @{@"titleLabel":titleLabel,
                                    @"expandBtn": expandBtn,
                                    @"inviteBtn": inviteBtn,
                                    @"exitBtn": exitBtn,
                                    @"collectionView": collectionView,
                                    };
            [self.invitationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[titleLabel]-(>=5@750)-|" options:0 metrics:nil views:views]];
            [self.invitationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[expandBtn(30)]-(>=5@750)-|" options:0 metrics:nil views:views]];
            [self.invitationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[inviteBtn(==expandBtn)]-(>=5@750)-|" options:0 metrics:nil views:views]];
            [self.invitationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[exitBtn(==expandBtn)]-2.5-[collectionView(>=100@750)]-2.5-|" options:0 metrics:nil views:views]];
            [self.invitationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[titleLabel]-(>=0@750)-[expandBtn(60)]-[inviteBtn(44)]-[exitBtn(44)]|" options:0 metrics:nil views:views]];
            [self.invitationView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[collectionView]-5-|" options:0 metrics:nil views:views]];
        }

        {
            UIButton* whisperCloseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            whisperCloseBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [whisperCloseBtn setTitle:@"Close" forState:UIControlStateNormal];
            [whisperCloseBtn addTarget:self action:@selector(whisperCloseBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.whisperView addSubview:whisperCloseBtn];
            
            NSDictionary *views = @{@"whisperCloseBtn": whisperCloseBtn};
            [self.whisperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[whisperCloseBtn]-5-|" options:0 metrics:nil views:views]];
            [self.whisperView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0@750-[whisperCloseBtn(80)]|" options:0 metrics:nil views:views]];
        }
    }];
    
    [collectionView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 100; i++) {
        NSInteger words = (arc4random() % 40)+1;
        [array addObject:[LoremIpsum wordsWithNumber:words]];
    }
    
    NSArray *reversed = [[array reverseObjectEnumerator] allObjects];
    
    self.messages = [[NSMutableArray alloc] initWithArray:reversed];
    
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SPHTextBubbleCell class] forCellReuseIdentifier:@"SPHTextBubbleCell"];

    self.textView.placeholder = NSLocalizedString(@"Message", nil);
    self.textView.placeholderColor = [UIColor lightGrayColor];
    self.textView.layer.borderColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0].CGColor;
    self.textView.pastableMediaTypes = SLKPastableMediaTypeAll|SLKPastableMediaTypePassbook;
    
    [self.leftButton setImage:[UIImage imageNamed:@"icn_upload"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor grayColor]];
    
    [self.rightButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editortLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editortRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    self.textInputbar.autoHideRightButton = NO;
    self.textInputbar.maxCharCount = 0;
    self.textInputbar.counterStyle = SLKCounterStyleNone;
    
//    self.typingIndicatorView.canResignByTouch = YES;
    
//    [self.autoCompletionView registerClass:[MessageTableViewCell class] forCellReuseIdentifier:AutoCompletionCellIdentifier];
//    [self registerPrefixesForAutoCompletion:@[@"@", @"#", @":"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_editing"] style:UIBarButtonItemStylePlain target:self action:@selector(editRandomMessage:)];
    
    UIBarButtonItem *typeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_typing"] style:UIBarButtonItemStylePlain target:self action:@selector(simulateUserTyping:)];
    UIBarButtonItem *appendItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icn_append"] style:UIBarButtonItemStylePlain target:self action:@selector(fillWithText:)];
    
    self.navigationItem.rightBarButtonItems = @[editItem, appendItem, typeItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    GZLogFunc1(self.userCollectionView);
    GZLogFunc1(self.tableView);
    
    if (self.invitationViewExpanded == YES && self.userInvitationViewShowed == NO) {
        if (self.userCollectionView.contentSize.height < self.tableView.frame.size.height) {
            self.invitationViewHC.constant = 40 + self.userCollectionView.contentSize.height;
            [self.view layoutIfNeeded];
        }
    }
}


#pragma mark - Action Methods

- (void)fillWithText:(id)sender
{
    if (self.textView.text.length == 0)
    {
        int sentences = (arc4random() % 4);
        if (sentences <= 1) sentences = 1;
        self.textView.text = [LoremIpsum sentencesWithNumber:sentences];
    }
    else {
        [self.textView slk_insertTextAtCaretRange:[NSString stringWithFormat:@" %@", [LoremIpsum word]]];
    }
}

- (void)simulateUserTyping:(id)sender
{
//    if (!self.isEditing && !self.isAutoCompleting) {
//        [self.typingIndicatorView insertUsername:[LoremIpsum name]];
//    }
}

- (void)editCellMessage:(UIGestureRecognizer *)gesture
{
    MessageTableViewCell *cell = (MessageTableViewCell *)gesture.view;
    NSString *message = self.messages[cell.indexPath.row];
    
    [self editText:message];
    
    [self.tableView scrollToRowAtIndexPath:cell.indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)editRandomMessage:(id)sender
{
    int sentences = (arc4random() % 10);
    if (sentences <= 1) sentences = 1;
    
    [self editText:[LoremIpsum sentencesWithNumber:sentences]];
}

- (void)editLastMessage:(id)sender
{
    if (self.textView.text.length > 0) {
        return;
    }
    
    NSInteger lastSectionIndex = [self.tableView numberOfSections]-1;
    NSInteger lastRowIndex = [self.tableView numberOfRowsInSection:lastSectionIndex]-1;
    
    NSString *lastMessage = [self.messages objectAtIndex:lastRowIndex];
    [self editText:lastMessage];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)didSaveLastMessageEditing:(id)sender
{
    NSString *message = [self.textView.text copy];
    
    [self.messages removeLastObject];
    [self.messages addObject:message];
    
    [self.tableView reloadData];
}


#pragma mark - Overriden Methods

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status
{
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate
{
    // Notifies the view controller that the text will update.

    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated
{
    // Notifies the view controller that the text did update.

    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender
{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender
{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    NSString *message = [self.textView.text copy];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewRowAnimation rowAnimation = self.inverted ? UITableViewRowAnimationBottom : UITableViewRowAnimationTop;
    UITableViewScrollPosition scrollPosition = self.inverted ? UITableViewScrollPositionBottom : UITableViewScrollPositionTop;

    [self.tableView beginUpdates];
    [self.messages insertObject:message atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    
    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [super didPressRightButton:sender];
}

- (void)didPressArrowKey:(id)sender
{
    [super didPressArrowKey:sender];
    
    UIKeyCommand *keyCommand = (UIKeyCommand *)sender;
    
    if ([keyCommand.input isEqualToString:UIKeyInputUpArrow]) {
        [self editLastMessage:nil];
    }
}

- (NSString *)keyForTextCaching
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo
{
    // Notifies the view controller when the user has pasted an image inside of the text view.
    
    NSLog(@"%s : %@",__FUNCTION__, userInfo);
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
    
    NSString *message = [self.textView.text copy];
    
    [self.messages removeObjectAtIndex:0];
    [self.messages insertObject:message atIndex:0];
    [self.tableView reloadData];
    
    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender
{
    // Notifies the view controller when tapped on the left "Cancel" button

    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton
{
    return [super canPressRightButton];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
        return self.messages.count;
    }
    else {
        return self.searchResult.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self messageCellForRowAtIndexPath:indexPath];
}

- (SPHTextBubbleCell *)messageCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPHTextBubbleCell *cell = (SPHTextBubbleCell *)[self.tableView dequeueReusableCellWithIdentifier:@"SPHTextBubbleCell"];
    
    NSString *message = self.messages[indexPath.row];
    if (indexPath.row % 2 == 0) {
        cell.bubbletype=@"LEFT";//:@"RIGHT";
        cell.AvatarImageView.image=[UIImage imageNamed:@"ProfilePic"];
    }
    else {
        cell.bubbletype=@"RIGHT";//:@"RIGHT";
    }
    cell.textLabel.text = message;
    cell.textLabel.tag=indexPath.row;
    
    // Cells must inherit the table view's transform
    // This is very important, since the main table view may be inverted
    cell.transform = self.tableView.transform;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return [SPHTextBubbleCell height:self.messages[indexPath.row]
                       showDateSeparator:YES
                              bubbleType:@"LEFT"
                                   frame:self.tableView.frame
                                    name:@"left name"
                         whisperUserName:@"ggg"];
    }
    else {
        return [SPHTextBubbleCell height:self.messages[indexPath.row]
                       showDateSeparator:NO
                              bubbleType:@"RIGHT"
                                   frame:self.tableView.frame
                                    name:@"right name"
                         whisperUserName:@"ggg"];
    }}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
    [super scrollViewDidScroll:scrollView];
}

-(void)whisperCloseBtnClicked:(id)sender {
    GZLogFunc0();
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.whisperViewHC.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

-(void)backBtnClicked:(id)sender {
    GZLogFunc0();
    
}

-(void)expandBtnClicked:(id)sender {
    GZLogFunc0();
    
    if (self.invitationViewExpanded) {
        self.invitationViewExpanded = NO;
    }
    else {
        self.invitationViewExpanded = YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (self.invitationViewExpanded) {
            self.invitationViewHC.constant = 100;
        }
        else {
            self.invitationViewHC.constant = 40;
        }
        [self.view layoutIfNeeded];
    }];
}

-(void)inviteBtnClicked:(id)sender {
    GZLogFunc0();
    
    UserInvitationView* userView = [[UserInvitationView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    userView.translatesAutoresizingMaskIntoConstraints = NO;
    userView.backgroundColor = [UIColor colorWithHue:1 saturation:0 brightness:0 alpha:0.5];
    
    self.userInvitationViewShowed = YES;
    [self.view addSubview:userView];
    
    __weak UIView* view = userView;
    [userView setActionBlock:^(NSDictionary *dic) {
        GZLogFunc1(dic);

    } closeBlock:^{
        GZLogFunc0();
        self.userInvitationViewShowed = NO;
        [view removeFromSuperview];
    }];
    
    {
        NSDictionary *views = @{@"userView": userView};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[userView]-0-|" options:0 metrics:nil views:views]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[userView]-0-|" options:0 metrics:nil views:views]];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)exitBtnClicked:(id)sender {
    GZLogFunc0();
    
    GZLogFunc1(self.userCollectionView);
    
}

#pragma mark - UICollectionViewDataSource
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GZLogFunc1(collectionView);
    
    return 15;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GZLogFunc0();
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor magentaColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 70);
}

@end

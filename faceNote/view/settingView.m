//
//  settingView.m
//  faceNote
//
//  Created by 林景隆 on 5/7/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "settingView.h"
#import "iAPHelper.h"
#import "icloudHelper.h"
#import "UICKeyChainStore.h"
#import "gestureCodeSettingView.h"
#import "gestureCodeVerifyView.h"
#import "MBProgressHUD.h"

@interface settingView()<UITableViewDataSource,UITableViewDelegate,gestureCodeViewDelegate,gestureCodeVerifyViewDelegate>
{
    UITableView *table;
    UISwitch *iCloudSwitch;
    UISwitch *gestureCodeSwitch;
}
@end

@implementation settingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.text = NSLocalizedString(@"setting", @"");
        [self.backButton setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];
        
        table = [[UITableView alloc] initWithFrame:self.content.bounds style:UITableViewStyleGrouped];
        [self.content addSubview:table];
        table.delegate = self;
        table.dataSource = self;
        [self.content addSubview:table];
        
        CGFloat switchWidth = 60;
        CGFloat switchHeight = 30;
        CGRect switchFrame = CGRectMake(table.frame.size.width - switchWidth - 10, 5, switchWidth, switchHeight);
        iCloudSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
        [iCloudSwitch addTarget:self action:@selector(onICloudSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        iCloudSwitch.tag = 904;
        [self updateICloudSwitchState];
        
        gestureCodeSwitch = [[UISwitch alloc] initWithFrame:switchFrame];
        [gestureCodeSwitch addTarget:self action:@selector(onGestureCodeSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self updateGestureCodeSwitch];
    }
    return self;
}


#pragma mark- instance method

- (void)updateICloudSwitchState
{
    iCloudSwitch.on = [icloudHelper helper].synchronizationEnabled;
}

- (void)updateGestureCodeSwitch
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:kGestureCodeEnable];
    if( number ){
        gestureCodeSwitch.on = number.boolValue;
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

#pragma -mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            NSString *Id = @"iCloudEnableCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
            if( !cell ){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
            }
            UISwitch *switchBtn = (UISwitch*)[cell viewWithTag:904];
            if( switchBtn ){
                [switchBtn removeFromSuperview];
            }
            if( [iAPHelper helper].bPurchased ){
                cell.textLabel.text = NSLocalizedString(@"enableICloud", nil);
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell addSubview:iCloudSwitch];
                [self updateICloudSwitchState];
            }
            else{
                cell.textLabel.text = NSLocalizedString(@"buyICloud", nil);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }
    }
    else if( indexPath.section == 1 ){
        if( indexPath.row == 0 ){
            NSString *Id = @"gestureCodeCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
            if( !cell ){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
                cell.textLabel.text = NSLocalizedString(@"SetGestureCode", @"");
                [cell addSubview:gestureCodeSwitch];
            }
            [self updateGestureCodeSwitch];
            return cell;
        }
    }
    
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 15)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UICOLOR(185, 185, 190, 1);
    label.backgroundColor = [UIColor clearColor];
    if( section == 0 ){
        label.text = NSLocalizedString(@"iCloudFunc", nil);
    }
    else if( section == 1 ){
        label.text = NSLocalizedString(@"gestureCode", nil);
    }
    [headView addSubview:label];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 && indexPath.row == 0 ){
        if( ![iAPHelper helper].bPurchased )
        {
            [[iAPHelper helper] buyICloudSynchronizationProductWithBlock:^(int status){
                if( status == 0 ){
                    [table reloadData];
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", nil) message:NSLocalizedString(@"buyICloudSynchronizationSucceeded", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                    [av show];
                }
                else{
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", nil) message:NSLocalizedString(@"buyICloudSynchronizationFailed", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                    [av show];
                }
            }];
        }
    }
}


#pragma mark- actions

- (void)onICloudSwitchValueChanged:(id)sender
{
    [icloudHelper helper].synchronizationEnabled = iCloudSwitch.on;
}

- (void)onGestureCodeSwitchValueChanged:(id)sender
{
    if( gestureCodeSwitch.on ){
        NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:kGestureCode];
        if( !code ){
            gestureCodeSettingView *view = [[gestureCodeSettingView alloc] initWithFrame:self.bounds delegate:self];
            [self addSubview:view];
        }
        else{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kGestureCodeEnable];
        }
    }
    else{
        NSString *code = [[NSUserDefaults standardUserDefaults] objectForKey:kGestureCode];
        gestureCodeVerifyView *view = [[gestureCodeVerifyView alloc] initWithFrame:self.bounds code:code limit:3 delegate:self back:YES];
        [self addSubview:view];
        gestureCodeSwitch.on = YES;
    }
}


#pragma mark- gestureCodeViewDelegate

- (void)didGestureCodePass:(NSString*)gestureCode
{
    [[NSUserDefaults standardUserDefaults] setObject:gestureCode forKey:kGestureCode];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:kGestureCodeEnable];
    gestureCodeSwitch.on = YES;
}

- (void)didGestureCodeCancel
{
    [table reloadData];
}

#pragma mark- gestureCodeVerifyViewDelegate

- (void)didGestureCodeIsValid:(NSString*)code
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:kGestureCodeEnable];
    gestureCodeSwitch.on = NO;
}

- (void)didInvalidGestureCodeReachLimitTimes:(int)times
{
    gestureCodeSwitch.on = YES;
}

@end

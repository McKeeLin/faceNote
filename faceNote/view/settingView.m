//
//  settingView.m
//  faceNote
//
//  Created by 林景隆 on 5/7/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "settingView.h"
#import "iAPHelper.h"

@interface settingView()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    UISwitch *iCloudSwitch;
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
        [self addSubview:table];
        
        CGFloat switchWidth = 60;
        CGFloat switchHeight = 30;
        iCloudSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(table.frame.size.width - switchWidth - 10, 5, switchWidth, switchHeight)];
        [iCloudSwitch addTarget:self action:@selector(onICloudSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        iCloudSwitch.tag = 904;
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"enableICloud"];
        if( number ){
            iCloudSwitch.on = number.boolValue;
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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
    NSString *Id = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if( !cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    
    UIView *switchBtn = [cell viewWithTag:904];
    if( switchBtn ){
        [switchBtn removeFromSuperview];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if( indexPath.section == 0 ){
        if( [iAPHelper helper].bPurchased ){
            cell.textLabel.text = NSLocalizedString(@"enableICloud", nil);
            [cell addSubview:iCloudSwitch];
        }
        else{
            cell.textLabel.text = NSLocalizedString(@"buyICloud", nil);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    else if( indexPath.section ){
        ;
    }
    
    return cell;
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

- (void)onICloudSwitchValueChanged:(id)sender
{
    NSNumber *number = [NSNumber numberWithBool:iCloudSwitch.on];
    [[NSUserDefaults standardUserDefaults] setObject:number forKey:@"enableICloud"];
}

@end

//
//  funcVC.m
//  faceNote
//
//  Created by 林景隆 on 4/18/14.
//  Copyright (c) 2014 cndatacom. All rights reserved.
//

#import "funcVC.h"
#import "iapVC.h"

@interface funcVC ()

@end

@implementation funcVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( section == 0 ){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Id = @"funcVCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    if( !cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
    }
    // Configure the cell...
    cell.textLabel.text = @"iap-buy";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            iapVC *vc = [[iapVC alloc] initWithStyle:UITableViewStyleGrouped];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}
@end

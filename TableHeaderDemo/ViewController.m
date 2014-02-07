//
//  ViewController.m
//  TableHeaderDemo
//
//  Created by Andrew Black on 2/7/14.
//  Copyright (c) 2014 Andrew Black. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *mockData;
@property (nonatomic, strong) UIButton *deleteAllButton;
@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Seahawks";
    self.mockData = @[@"Russell Wilson", @"Marshawn Lynch", @"Richard Sherman", @"Kam Chancellor", @"Earl Thomas"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self configureHeaderView];
}

- (UIButton *)deleteAllButton
{
    if (!_deleteAllButton) {
        _deleteAllButton = [[UIButton alloc] init];
        _deleteAllButton.backgroundColor = [UIColor grayColor];
        [_deleteAllButton setTitle:@"Delete All" forState:UIControlStateNormal];
        _deleteAllButton.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _deleteAllButton;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor yellowColor];
        _label.text = @"You have a lot of text here telling you that you have stuff to delete";
        _label.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _label;
}

- (void)configureHeaderView
{
    if (self.tableView.tableHeaderView) {
        return;
    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor orangeColor];
    [headerView addSubview:self.label];
    [headerView addSubview:self.deleteAllButton];
    
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_deleteAllButton]-[_label]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_label, _deleteAllButton)]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteAllButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    headerView.clipsToBounds = YES;
    
    self.tableView.tableHeaderView = headerView;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        UIView *headerView = self.tableView.tableHeaderView;
        CGRect rect = headerView.frame;
        
        if (editing) {
            rect.size.height = 60.0f; // arbitrary; calculate height based on content size if you wish
        } else {
            rect.size.height = 0.0f;
        }
        
        headerView.frame = rect;
        self.tableView.tableHeaderView = headerView;
        
        [self.tableView layoutIfNeeded];
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mockData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.mockData[indexPath.row];
    
    return cell;
}

@end

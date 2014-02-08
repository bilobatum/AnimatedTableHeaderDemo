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
@property (nonatomic, strong) UIView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Fruit";
    self.mockData = @[@"Orange", @"Apple", @"Pear", @"Banana", @"Cantalope"];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (UIButton *)deleteAllButton
{
    if (!_deleteAllButton) {
        _deleteAllButton = [[UIButton alloc] init];
        _deleteAllButton.backgroundColor = [UIColor grayColor];
        [_deleteAllButton setTitle:@"Delete All" forState:UIControlStateNormal];
        _deleteAllButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_deleteAllButton addTarget:self action:@selector(handleDeleteAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteAllButton;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.backgroundColor = [UIColor yellowColor];
        _label.text = @"Delete all button prompt";
        _label.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _label;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        // WARNING: do not set translatesAutoresizingMaskIntoConstraints to NO
        _headerView.backgroundColor = [UIColor orangeColor];
        _headerView.clipsToBounds = YES;
        
        [_headerView addSubview:self.label];
        [_headerView addSubview:self.deleteAllButton];
        
        [_headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_deleteAllButton]-[_label]-|" options:NSLayoutFormatAlignAllCenterY metrics:0 views:NSDictionaryOfVariableBindings(_label, _deleteAllButton)]];
        
        [_headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.deleteAllButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_headerView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    }
    
    return _headerView;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if (self.editing) {
        self.tableView.tableHeaderView = self.headerView;
        [self.tableView layoutIfNeeded];
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        
        CGRect rect = self.headerView.frame;
        
        if (editing) {
            rect.size.height = 60.0f; // arbitrary; for testing purposes
        } else {
            rect.size.height = 0.0f;
        }
        
        self.headerView.frame = rect;
        self.tableView.tableHeaderView = self.headerView;
        
        [self.tableView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (!editing) {
            self.tableView.tableHeaderView = nil;
        }
    }];
}

- (void)handleDeleteAll
{
    NSLog(@"handle delete all");
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

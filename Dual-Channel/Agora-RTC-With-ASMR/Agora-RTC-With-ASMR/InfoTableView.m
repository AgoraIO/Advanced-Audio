//
//  InfoTableView.m
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 2017/10/12.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "InfoTableView.h"
#import "InfoCell.h"
#import "InfoModel.h"

@interface InfoTableView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *infoArray;
@end

@implementation InfoTableView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark- append info to tableView to display
- (void)appendInfoToTableViewWithInfo:(NSString *)infoStr {
    InfoModel *model = [InfoModel modelWithInfoStr:infoStr];
    [self.infoArray insertObject:model atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark- <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
    InfoModel *model = self.infoArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark- <UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InfoModel *model = self.infoArray[indexPath.row];
    
    return model.height;
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}

#pragma mark - Lazy Load
- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    
    return _infoArray;
}

@end

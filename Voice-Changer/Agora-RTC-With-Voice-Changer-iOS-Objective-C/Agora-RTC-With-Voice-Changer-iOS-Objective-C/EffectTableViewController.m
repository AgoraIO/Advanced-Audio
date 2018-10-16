//
//  EffectTableViewController.m
//  Agora-RTC-With-Voice-Changer-iOS-Objective-C
//
//  Created by ZhangJi on 2018/5/4.
//  Copyright © 2018 ZhangJi. All rights reserved.
//

#import "EffectTableViewController.h"
#import "EffectCell.h"

@interface EffectTableViewController ()<EffectCellDelegate>

@property (strong, nonatomic) NSMutableDictionary *currentValueDic;
@property (strong, nonatomic) NSArray *equalizationBandFrequencysArray;
@property (strong, nonatomic) NSArray *reverbsArray;
@property (strong, nonatomic) NSArray *rolesArray;

@end

@implementation EffectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(300, 400);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray *)equalizationBandFrequencysArray {
    if (!_equalizationBandFrequencysArray) {
        _equalizationBandFrequencysArray = @[@(AgoraAudioEqualizationBand31),
                                             @(AgoraAudioEqualizationBand62),
                                             @(AgoraAudioEqualizationBand125),
                                             @(AgoraAudioEqualizationBand250),
                                             @(AgoraAudioEqualizationBand500),
                                             @(AgoraAudioEqualizationBand1K),
                                             @(AgoraAudioEqualizationBand2K),
                                             @(AgoraAudioEqualizationBand4K),
                                             @(AgoraAudioEqualizationBand8K),
                                             @(AgoraAudioEqualizationBand16K)];
    }
    return _equalizationBandFrequencysArray;
}

- (NSArray *)reverbsArray {
    if (!_reverbsArray) {
        _reverbsArray = @[@(AgoraAudioReverbDryLevel),
                          @(AgoraAudioReverbWetLevel),
                          @(AgoraAudioReverbRoomSize),
                          @(AgoraAudioReverbWetDelay),
                          @(AgoraAudioReverbStrength)];
    }
    return _reverbsArray;
}

- (NSMutableDictionary *)currentValueDic {
    if (!_currentValueDic) {
        _currentValueDic = [[NSMutableDictionary alloc] init];
        [_currentValueDic setValue:[NSNumber numberWithDouble:1.0] forKey:@"Pitch"];
        for (NSInteger i = 0; i < _equalizationBandFrequencysArray.count; i++) {
            [_currentValueDic setValue:[NSNumber numberWithDouble:0.0] forKey:[self descriptionOfBandFrequency:[self.equalizationBandFrequencysArray[i] integerValue]]];
        }
        for (NSInteger i = 0; i < _reverbsArray.count; i++) {
             [_currentValueDic setValue:[NSNumber numberWithDouble:0.0] forKey:[self descriptionOfReverType:[self.reverbsArray[i] integerValue]]];
        }
    }
    return _currentValueDic;
}

- (NSArray *)rolesArray {
    if (!_rolesArray) {
        _rolesArray = @[@(EffectRolesOldMan),
                          @(EffectRolesBabyBoy),
                          @(EffectRolesZhuBaJie),
                          @(EffectRolesEthereal),
                          @(EffectRolesHulk),
                          @(EffectRolesBabyGily),
                          @(EffectRolesDefault)];
    }
    return _rolesArray;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.rolesArray count];
        case 1:
            return 1;
        case 2:
            return [self.equalizationBandFrequencysArray count];
        case 3:
            return [self.reverbsArray count];
        default:
            return 0;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"role_reuse" forIndexPath:indexPath];
        EffectRoles role = [_rolesArray[indexPath.row] integerValue];
        cell.textLabel.text = [self descriptionOfRole:role];
        return cell;
    } else {
        EffectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"effect_reuse" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 1:
                cell.titelLabel.text = @"Pitch";
                cell.valuaSlider.minimumValue = 0.5;
                cell.valuaSlider.maximumValue = 2.0;
                cell.valuaSlider.value = [[self.currentValueDic valueForKey:@"Pitch"] floatValue];
                cell.valueLabel.text = [NSString stringWithFormat:@"%0.2f", cell.valuaSlider.value];
                break;
            case 2: {
                AgoraAudioEqualizationBandFrequency bandFrequency = [_equalizationBandFrequencysArray[indexPath.row] integerValue];
                cell.titelLabel.text = [self descriptionOfBandFrequency:bandFrequency];
                cell.valuaSlider.minimumValue = [cell rangeOfBandFrequency:bandFrequency].minValue;
                cell.valuaSlider.maximumValue = [cell rangeOfBandFrequency:bandFrequency].maxValue;
                cell.valuaSlider.value = [[self.currentValueDic valueForKey:[self descriptionOfBandFrequency:bandFrequency]] floatValue];
                cell.valueLabel.text = [NSString stringWithFormat:@"%d", (int)cell.valuaSlider.value];
                break;
            }
            case 3: {
                AgoraAudioReverbType reverType = [_reverbsArray[indexPath.row] integerValue];
                cell.titelLabel.text = [self descriptionOfReverType:reverType];
                cell.valuaSlider.minimumValue = [cell rangeOfReverType:reverType].minValue;
                cell.valuaSlider.maximumValue = [cell rangeOfReverType:reverType].maxValue;
                cell.valuaSlider.value = [[self.currentValueDic valueForKey:[self descriptionOfReverType:reverType]] floatValue];
                cell.valueLabel.text = [NSString stringWithFormat:@"%d", (int)cell.valuaSlider.value];
                break;
            }
            default:
                break;
        }
        cell.indexPath = indexPath;
        cell.delegate = self;
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"Role"; break;
        case 1: return @"Pitch"; break;
        case 2: return @"EqualizationBandFrequency"; break;
        case 3: return @"Reverb"; break;
        default: return @""; break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        EffectRoles role = [self.rolesArray[indexPath.row] integerValue];
        [self setForRole:role];
    }
}

#pragma mark- Effect Cell Delegate

- (void)effectCell:(EffectCell *)effectCell sliderValue:(double)value didChangedAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 1:
            [self.agoraKit setLocalVoicePitch:value];
            [self.currentValueDic setValue:[NSNumber numberWithDouble:value] forKey:@"Pitch"];
            break;
        case 2: {
            AgoraAudioEqualizationBandFrequency bandFrequency = [_equalizationBandFrequencysArray[indexPath.row] integerValue];
            [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:bandFrequency withGain:(int)value];
            [self.currentValueDic setValue:[NSNumber numberWithDouble:value] forKey:[self descriptionOfBandFrequency:bandFrequency]];
            break;
        }
        case 3: {
            AgoraAudioReverbType reverType = [_reverbsArray[indexPath.row] integerValue];
            [self.agoraKit setLocalVoiceReverbOfType:reverType withValue:(int)value];
            [self.currentValueDic setValue:[NSNumber numberWithDouble:value] forKey:[self descriptionOfReverType:reverType]];
            break;
        }
        default:
            break;
    }
}

- (NSString *)descriptionOfReverType:(AgoraAudioReverbType)reverType {
    switch (reverType) {
        case AgoraAudioReverbDryLevel: return @"DryLevel";
        case AgoraAudioReverbWetLevel: return @"WetLevel";
        case AgoraAudioReverbRoomSize: return @"RoomSize";
        case AgoraAudioReverbStrength: return @"Strength";
        case AgoraAudioReverbWetDelay: return @"WetDelay";
    }
}

- (NSString *)descriptionOfBandFrequency:(AgoraAudioEqualizationBandFrequency)bandFrequency {
    switch (bandFrequency) {
        case AgoraAudioEqualizationBand1K: return @"Band1K";
        case AgoraAudioEqualizationBand2K: return @"Band2K";
        case AgoraAudioEqualizationBand31: return @"Band31";
        case AgoraAudioEqualizationBand4K: return @"Band4K";
        case AgoraAudioEqualizationBand62: return @"Band62";
        case AgoraAudioEqualizationBand8K: return @"Band8K";
        case AgoraAudioEqualizationBand125: return @"Band125";
        case AgoraAudioEqualizationBand16K: return @"Band16K";
        case AgoraAudioEqualizationBand250: return @"Band250";
        case AgoraAudioEqualizationBand500: return @"Band500";
    }
}

- (NSString *)descriptionOfRole:(EffectRoles)role {
    switch (role) {
        case EffectRolesOldMan: return @"OldMan"; break;
        case EffectRolesBabyBoy: return @"BabyBoy"; break;
        case EffectRolesZhuBaJie: return @"ZhuBaJie"; break;
        case EffectRolesEthereal: return @"Ethereal"; break;
        case EffectRolesHulk: return @"Hulk"; break;
        case EffectRolesBabyGily: return @"BabyGily"; break;
        default: return @"Default"; break;
    }
}

- (void)setForRole:(EffectRoles)role {
    switch (role) {
        case EffectRolesOldMan: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:0.8] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-15] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:6] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-4] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-10] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-15] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:3] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:3] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-12] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-12] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:90] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:43] forKey:@"Strength"];
            break;
        }
        case EffectRolesBabyBoy: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:1.23] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:15] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:11] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-3] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-5] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-7] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-7] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-9] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-15] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-15] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-15] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:4] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:2] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:91] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:44] forKey:@"Strength"];
            break;
        }
        case EffectRolesZhuBaJie: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:0.6] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:12] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-9] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-9] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:3] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-3] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:11] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-8] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-8] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-9] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-14] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-8] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:34] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:39] forKey:@"Strength"];
            break;
        }
        case EffectRolesEthereal: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-8] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-8] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:5] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:13] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:2] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:12] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-3] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:7] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-2] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-10] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-17] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-13] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:72] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:9] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:69] forKey:@"Strength"];
            break;
        }
        case EffectRolesHulk: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:0.5] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-15] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:3] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-9] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-8] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-6] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-4] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-3] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-2] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-1] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:10] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-9] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:76] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:124] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:78] forKey:@"Strength"];
            break;
        }
        case EffectRolesBabyGily: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:1.45] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:10] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:6] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-6] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:13] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:7] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-14] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:13] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:13] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:-11] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:-7] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:31] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:44] forKey:@"Strength"];
            break;
        }
        case EffectRolesDefault: {
            [_currentValueDic setValue:[NSNumber numberWithDouble:1] forKey:@"Pitch"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band31"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band62"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band125"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band250"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band500"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band1k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band2k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band4k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band8k"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Band16k"];
            
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"DryLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"WetLevel"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"RoomSize"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"WetDelay"];
            [_currentValueDic setValue:[NSNumber numberWithDouble:0] forKey:@"Strength"];
            break;
        }
    }
    for (NSString *key in _currentValueDic) {
        [self setAudioEffectForKey:key value:[[self.currentValueDic valueForKey:key] doubleValue]];
    }
    [self.tableView reloadData];
}

- (void)setAudioEffectForKey:(NSString *)key value:(double)value {
    if ([key isEqualToString:@"Pitch"]) {
        [self.agoraKit setLocalVoicePitch:value];
    } else if ([key isEqualToString:@"Band31"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand31 withGain:(int)value];
    } else if ([key isEqualToString:@"Band62"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand62 withGain:(int)value];
    } else if ([key isEqualToString:@"Band125"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand125 withGain:(int)value];
    } else if ([key isEqualToString:@"Band250"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand250 withGain:(int)value];
    } else if ([key isEqualToString:@"Band500"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand500 withGain:(int)value];
    } else if ([key isEqualToString:@"Band1K"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand1K withGain:(int)value];
    } else if ([key isEqualToString:@"Band2K"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand2K withGain:(int)value];
    } else if ([key isEqualToString:@"Band4K"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand4K withGain:(int)value];
    } else if ([key isEqualToString:@"Band8K"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand8K withGain:(int)value];
    } else if ([key isEqualToString:@"Band16K"]) {
        [self.agoraKit setLocalVoiceEqualizationOfBandFrequency:AgoraAudioEqualizationBand16K withGain:(int)value];
    } else if ([key isEqualToString:@"DryLevel"]) {
        [self.agoraKit setLocalVoiceReverbOfType:AgoraAudioReverbDryLevel withValue:(int)value];
    } else if ([key isEqualToString:@"WetLevel"]) {
        [self.agoraKit setLocalVoiceReverbOfType:AgoraAudioReverbWetLevel withValue:(int)value];
    } else if ([key isEqualToString:@"RoomSize"]) {
        [self.agoraKit setLocalVoiceReverbOfType:AgoraAudioReverbRoomSize withValue:(int)value];
    } else if ([key isEqualToString:@"WetDelay"]) {
        [self.agoraKit setLocalVoiceReverbOfType:AgoraAudioReverbWetDelay withValue:(int)value];
    } else if ([key isEqualToString:@"Strength"]) {
        [self.agoraKit setLocalVoiceReverbOfType:AgoraAudioReverbStrength withValue:(int)value];
    }
}
@end

















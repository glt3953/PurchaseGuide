//
//  ViewController.m
//  PurchaseGuide
//
//  Created by guoliting on 2018/7/3.
//  Copyright © 2018年 NingXia. All rights reserved.
//

#import "ViewController.h"
#import "RadioButton.h"

//static float pickerViewWidth = [UIScreen mainScreen].bounds.size.width;

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) double finalPrice; //成交价
@property (nonatomic, strong) UITextField *finalPriceTextField; //成交价输入框
@property (nonatomic, copy) NSArray *houseFeatures; //房屋特点：满五年（0）、满两年（1）
@property (nonatomic, copy) NSNumber *houseType; //房屋类型：满五年（0）、满两年（1）
@property (nonatomic) double netPrice; //网签价
@property (nonatomic, strong) UITextField *netPriceTextField; //网签价输入框
@property (nonatomic, copy) NSArray *evaluationRatios; //评估比例：95成（0.95）、93成（0.93）
@property (nonatomic, copy) NSNumber *evaluationRatio; //评估比例：95成（0.95）、93成（0.93）
@property (nonatomic, strong) UIPickerView *extendCreditPickerView; //贷款比例及年限
@property (nonatomic, copy) NSArray *extendCreditRatios; //贷款比例：20-65%
@property (nonatomic, copy) NSNumber *extendCreditRatio; //贷款比例：20-65%
@property (nonatomic, copy) NSArray *extendCreditPeriods; //贷款年限：1-25年
@property (nonatomic, copy) NSNumber *extendCreditPeriod; //贷款比例：20-65%

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat originX = 20;
    CGFloat originY = 64;
    CGFloat labelWidth = 100;
    CGFloat labelHeight = 30;
    UILabel *finalPriceLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [finalPriceLabel setText:@"成交价："];
    [finalPriceLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:finalPriceLabel];
    
    originX += labelWidth;
    _finalPrice = 300;
    _finalPriceTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [_finalPriceTextField setText:[NSString stringWithFormat:@"%.2f万", _finalPrice]];
    [_finalPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_finalPriceTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:2];
    CGRect btnRect = (CGRect){originX, originY, labelWidth, labelHeight};
    _houseFeatures = @[@{@"type":@0, @"feature":@"满五年"}, @{@"type":@1, @"feature":@"满两年"}];
    for (NSDictionary *houseFeature in _houseFeatures) {
        RadioButton *btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(houseFeaturesRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.x += labelWidth;
        [btn setTitle:houseFeature[@"feature"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.view addSubview:btn];
        [buttons addObject:btn];
    }
    [buttons[0] setGroupButtons:buttons]; // Setting buttons into the group
    [buttons[0] setSelected:YES]; // Making the first button initially selected
    
    originY += 10 + labelHeight;
    NSMutableArray *evaluationRatioButtons = [NSMutableArray arrayWithCapacity:2];
    btnRect = (CGRect){originX, originY, labelWidth, labelHeight};
    _evaluationRatios = @[@{@"value":@0.95, @"name":@"95成"}, @{@"value":@0.93, @"name":@"93成"}];
    for (NSDictionary *evaluationRatio in _evaluationRatios) {
        RadioButton *btn = [[RadioButton alloc] initWithFrame:btnRect];
        [btn addTarget:self action:@selector(evaluationRatioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
        btnRect.origin.x += labelWidth;
        [btn setTitle:evaluationRatio[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
        [self.view addSubview:btn];
        [evaluationRatioButtons addObject:btn];
    }
    [evaluationRatioButtons[0] setGroupButtons:evaluationRatioButtons]; // Setting buttons into the group
    [evaluationRatioButtons[0] setSelected:YES]; // Making the first button initially selected
    
    originY += 10 + labelHeight;
    UILabel *netPriceLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [netPriceLabel setText:@"网签价："];
    [netPriceLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:netPriceLabel];
    
    originX += labelWidth;
    _netPrice = 279;
    _netPriceTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [_netPriceTextField setText:[NSString stringWithFormat:@"%.2f万", _netPrice]];
    [_netPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_netPriceTextField];
}

- (void)houseFeaturesRadioButtonValueChanged:(RadioButton *)sender {
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if (sender.selected) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feature=%@", sender.titleLabel.text]; //实现数组的快速查询
        if (predicate) {
            NSArray *filteredArray = [_houseFeatures filteredArrayUsingPredicate:predicate];
            if (filteredArray.count > 0) {
                _houseType = filteredArray[0][@"type"];
            }
        }
        
        NSLog(@"Selected text: %@", sender.titleLabel.text);
    }
}

- (void)evaluationRatioButtonValueChanged:(RadioButton *)sender {
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if (sender.selected) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", sender.titleLabel.text]; //实现数组的快速查询
        if (predicate) {
            NSArray *filteredArray = [_evaluationRatios filteredArrayUsingPredicate:predicate];
            if (filteredArray.count > 0) {
                _evaluationRatio = filteredArray[0][@"value"];
            }
        }
        
        NSLog(@"Selected text: %@", sender.titleLabel.text);
    }
}

#pragma mark - UIPickerViewDataSource
//返回列数（必须实现）
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

//返回每列里边的行数（必须实现）
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _extendCreditRatios ? _extendCreditRatios.count : 0;
    } else {
        return _extendCreditPeriods ? _extendCreditPeriods.count : 0;
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
//    return pickerViewWidth;
    return CGRectGetWidth(self.view.bounds);
}

//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

//设置组件中每行的标题row:行
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return _extendCreditRatios && _extendCreditRatios.count > row ? _extendCreditRatios[row][@"name"] : @"";
    } else {
        return _extendCreditPeriods && _extendCreditPeriods.count > row ? _extendCreditPeriods[row][@"name"] : @"";
    }
    
    return @"";
}

//选中行的事件处理
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _extendCreditRatio = _extendCreditRatios && _extendCreditRatios.count > row ? _extendCreditRatios[row][@"value"] : @0;
    } else {
        _extendCreditPeriod = _extendCreditPeriods && _extendCreditPeriods.count > row ? _extendCreditPeriods[row][@"value"] : @0;
    }
    
    [pickerView reloadComponent:component];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

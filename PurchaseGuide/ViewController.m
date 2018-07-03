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
@property (nonatomic) double extendCreditAmount; //贷款额
@property (nonatomic, strong) UITextField *extendCreditAmountTextField; //贷款额输入框
@property (nonatomic) double netDownPayment; //净首付
@property (nonatomic, strong) UITextField *netDownPaymentTextField; //净首付输入框
@property (nonatomic, strong) UITextField *averageMonthlySupplyTextField; //平均月供输入框
@property (nonatomic) double deedTax; //契税
@property (nonatomic, strong) UITextField *deedTaxTextField; //契税输入框
@property (nonatomic) double personalTax; //个税
@property (nonatomic, strong) UITextField *personalTaxTextField; //个税输入框
@property (nonatomic) double agencyFees; //中介费
@property (nonatomic, strong) UITextField *agencyFeesTextField; //中介费输入框
@property (nonatomic) double totalDownPayment; //总首付
@property (nonatomic, strong) UITextField *totalDownPaymentTextField; //总首付输入框

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat originX = 20;
    CGFloat originY = 64;
    CGFloat labelWidth = 120;
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
    _evaluationRatios = @[@{@"value":@0.93, @"name":@"93成"}, @{@"value":@0.95, @"name":@"95成"}];
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
    _evaluationRatio = _evaluationRatios[0][@"value"];
    
    originY += 10 + labelHeight;
    UILabel *netPriceLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [netPriceLabel setText:@"网签价："];
    [netPriceLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:netPriceLabel];
    
    originX += labelWidth;
    _netPriceTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    _netPriceTextField.enabled = NO;
    [_netPriceTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_netPriceTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *extendCreditLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth * 2, labelHeight}];
    [extendCreditLabel setText:@"贷款比例及年限："];
    [extendCreditLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:extendCreditLabel];
    
    NSMutableArray *extendCreditRatios = [[NSMutableArray alloc] init];
    for (NSUInteger i = 65; i > 15;) {
        [extendCreditRatios addObject:@{@"value":[NSNumber numberWithDouble:i * 0.01], @"name":[NSString stringWithFormat:@"%lu%%", (unsigned long)i]}];
        i -= 5;
    }
    _extendCreditRatios = [extendCreditRatios copy];
    NSMutableArray *extendCreditPeriods = [[NSMutableArray alloc] init];
    for (NSUInteger i = 25; i > 0; i--) {
        [extendCreditPeriods addObject:@{@"value":[NSNumber numberWithUnsignedInteger:i], @"name":[NSString stringWithFormat:@"%lu年", (unsigned long)i]}];
    }
    _extendCreditPeriods = [extendCreditPeriods copy];
    originY += 10 + labelHeight;
    CGFloat pickerViewHeight = 60;
    //初始化一个PickerView
    _extendCreditPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, originY, CGRectGetWidth(self.view.bounds), pickerViewHeight)];
    _extendCreditPickerView.tag = 1000;
    //指定Picker的代理
    _extendCreditPickerView.dataSource = self;
    _extendCreditPickerView.delegate = self;
    //是否要显示选中的指示器(默认值是NO)
    _extendCreditPickerView.showsSelectionIndicator = NO;
    [self.view addSubview:_extendCreditPickerView];
    _extendCreditRatio = _extendCreditRatios[0][@"value"];
    
    originY += 10 + pickerViewHeight;
    UILabel *extendCreditAmountLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [extendCreditAmountLabel setText:@"贷款额："];
    [extendCreditAmountLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:extendCreditAmountLabel];
    
    originX += labelWidth;
    _extendCreditAmountTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    _extendCreditAmountTextField.enabled = NO;
    [_extendCreditAmountTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_extendCreditAmountTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *netDownPaymentLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [netDownPaymentLabel setText:@"净首付："];
    [netDownPaymentLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:netDownPaymentLabel];
    
    originX += labelWidth;
    _netDownPaymentTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    _netDownPaymentTextField.enabled = NO;
    [_netDownPaymentTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_netDownPaymentTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *averageMonthlySupplyLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [averageMonthlySupplyLabel setText:@"平均月供："];
    [averageMonthlySupplyLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:averageMonthlySupplyLabel];
    
    originX += labelWidth;
    _averageMonthlySupplyTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    _averageMonthlySupplyTextField.enabled = NO;
    [_averageMonthlySupplyTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_averageMonthlySupplyTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *deedTaxLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [deedTaxLabel setText:@"契税："];
    [deedTaxLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:deedTaxLabel];
    
    originX += labelWidth;
    _deedTaxTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    _deedTaxTextField.enabled = NO;
    [_deedTaxTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_deedTaxTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *personalTaxLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [personalTaxLabel setText:@"个税："];
    [personalTaxLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:personalTaxLabel];
    
    originX += labelWidth;
    _personalTaxTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [_personalTaxTextField setBorderStyle:UITextBorderStyleRoundedRect];
    _personalTax = 4.3;
    [_personalTaxTextField setText:[NSString stringWithFormat:@"%.2f万", _personalTax]];
    [self.view addSubview:_personalTaxTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *agencyFeesLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [agencyFeesLabel setText:@"中介费："];
    [agencyFeesLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:agencyFeesLabel];
    
    originX += labelWidth;
    _agencyFeesTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [_agencyFeesTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_agencyFeesTextField];
    
    originX = 20;
    originY += 10 + labelHeight;
    UILabel *totalDownPaymentLabel = [[UILabel alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    [totalDownPaymentLabel setText:@"总首付："];
    [totalDownPaymentLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:totalDownPaymentLabel];
    
    originX += labelWidth;
    _totalDownPaymentTextField = [[UITextField alloc] initWithFrame:(CGRect){originX, originY, labelWidth, labelHeight}];
    _totalDownPaymentTextField.enabled = NO;
    [_totalDownPaymentTextField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.view addSubview:_totalDownPaymentTextField];
    
    [self refreshPriceInfo];
}

- (void)refreshPriceInfo {
    if ([_houseType unsignedIntegerValue] == 0) {
        //满五年
        _netPrice = _finalPrice * [_evaluationRatio doubleValue];
        _extendCreditAmount = _netPrice * [_extendCreditRatio doubleValue];
    } else {
        _netPrice = 150;
        _extendCreditAmount = _netPrice * 0.8;
    }
    
    [_netPriceTextField setText:[NSString stringWithFormat:@"%.2f万", _netPrice]];
    [_extendCreditAmountTextField setText:[NSString stringWithFormat:@"%.2f万", _extendCreditAmount]];
    
    _netDownPayment = _finalPrice - _extendCreditAmount;
    [_netDownPaymentTextField setText:[NSString stringWithFormat:@"%.2f万", _netDownPayment]];
    
    _deedTax = _netPrice * 0.01;
    [_deedTaxTextField setText:[NSString stringWithFormat:@"%.2f万", _deedTax]];
    
    _agencyFees = _finalPrice * 0.025;
    [_agencyFeesTextField setText:[NSString stringWithFormat:@"%.2f万", _agencyFees]];
    
    _totalDownPayment = _netDownPayment + _deedTax + _agencyFees + 0.06;
    if ([_houseType unsignedIntegerValue] == 1) {
        //满两年
        _totalDownPayment += _personalTax;
    }
    [_totalDownPaymentTextField setText:[NSString stringWithFormat:@"%.2f万", _totalDownPayment]];
}

- (void)houseFeaturesRadioButtonValueChanged:(RadioButton *)sender {
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if (sender.selected) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"feature=%@", sender.titleLabel.text]; //实现数组的快速查询
        if (predicate) {
            NSArray *filteredArray = [_houseFeatures filteredArrayUsingPredicate:predicate];
            if (filteredArray.count > 0) {
                _houseType = filteredArray[0][@"type"];
                
                [self refreshPriceInfo];
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
                
                [self refreshPriceInfo];
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
    return CGRectGetWidth(self.view.bounds) / 2;
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
    
    [self refreshPriceInfo];
    
    [pickerView reloadComponent:component];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

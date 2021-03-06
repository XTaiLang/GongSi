//
//  ScanViewController.m
//  Mercurial
//
//  Created by 王霄 on 16/3/14.
//  Copyright © 2016年 muggins. All rights reserved.
//

#import "ScanViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "NetworkRequest+Others.h"

@interface ScanViewController () <QRCodeReaderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@property (weak, nonatomic) IBOutlet UITextField *productTextField;
@property (weak, nonatomic) IBOutlet UIButton *enquiryButton;
@property (strong, nonatomic) QRCodeReaderViewController *reader;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"防伪查询";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]]];
    [self configureButton];
} 

- (void)configureButton{
    self.scanButton.backgroundColor = [UIColor clearColor];
    self.scanButton.layer.cornerRadius = 8;
    self.scanButton.layer.masksToBounds = YES;
    self.scanButton.layer.borderWidth = 2;
    self.scanButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.enquiryButton.backgroundColor = [UIColor clearColor];
    self.enquiryButton.layer.cornerRadius = 8;
    self.enquiryButton.layer.masksToBounds = YES;
    self.enquiryButton.layer.borderWidth = 2;
    self.enquiryButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.productTextField.layer.borderColor = [UIColor blueColor].CGColor;
    self.productTextField.layer.borderWidth = 3;
}
- (IBAction)scanButtonClicked {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader = [QRCodeReaderViewController new];
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)enquryButtonClicked {
    [SVProgressHUD show];
    [NetworkRequest requestFakeSearch:self.productTextField.text success:^(NSString *successContent){
        [SVProgressHUD showSuccessWithStatus:successContent];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
    } failure:^(NSString *error,NSString *phone){
        if (phone.length == 0) { //网络问题
            [SVProgressHUD showErrorWithStatus:error];
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
            return ;
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.2f];
        [self showAlertWithTitle:error phone:phone];
    }];
}

- (void)showAlertWithTitle:(NSString *)title phone:(NSString *)phone {
    UIAlertController *vc = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *call = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    [vc addAction:cancel];
    [vc addAction:call];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        self.productTextField.text = result;
        [self enquryButtonClicked];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

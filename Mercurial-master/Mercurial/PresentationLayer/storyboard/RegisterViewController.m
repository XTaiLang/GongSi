//
//  RegisterViewController.m
//  Mercurial
//
//  Created by 王霄 on 16/3/17.
//  Copyright © 2016年 muggins. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetworkRequest+User.h"
#import "ActionSheetStringPicker.h"

@interface RegisterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTF;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"用户注册";
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_bg"]]];
    [self configureRegisterButton];
    [self.phoneNumTextField becomeFirstResponder];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
}

- (void)configureRegisterButton{
    self.registerButton.backgroundColor = [UIColor clearColor];
    self.registerButton.layer.cornerRadius = 8;
    self.registerButton.layer.masksToBounds = YES;
    self.registerButton.layer.borderWidth = 2;
    self.registerButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)registerButtonClicked {
    if(![self isValidPhoneNumber:self.phoneNumTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话号码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        return;
    }
    if (self.nameTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        return;
    }
    if (![self isNumOrEnglish:self.nameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"用户名只能包含英文或数字"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        return;
    }
    if (self.confirmPasswordTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请再次输入密码"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        return;
    }
    if(![self.passwordTextField.text isEqualToString:self.confirmPasswordTF.text]){
        [SVProgressHUD showErrorWithStatus:@"两次输入的密码不一致，请重新输入"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        return;
    }
    [SVProgressHUD show];
    [NetworkRequest userRegisterWithName:self.nameTextField.text password:self.passwordTextField.text phone:self.phoneNumTextField.text sex:@"男" age:18 Email:@"10000@weimei.com" success:^{
        [SVProgressHUD showSuccessWithStatus:@"注册成功!"];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:1.5f];
    }];
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark <UITextFieldDelegate>
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[@[@"男", @"女"]] initialSelection:@[@(0)] doneBlock:^(ActionSheetStringPicker *picker, NSArray * selectedIndex, NSArray *selectedValue) {
//        self.sexTextField.text = [selectedValue firstObject];
//        [self.sexTextField resignFirstResponder];
//    } cancelBlock:nil origin:self.view];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

#pragma mark <VerficationCode>

- (BOOL)isValidPhoneNumber:(NSString *)text{
    if (text.length != 11) {
        return NO;
    }else if (![self isAllNum:text]){
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isValidAgeNumber:(NSString *)text{
    if (!(text.length == 1 || text.length == 2)) {
        return NO;
    }else if (![self isAllNum:text]){
        return NO;
    }else{
        return YES;
    }
}

- (BOOL)isAllNum:(NSString *)text{
    unichar c;
    for (int i=0; i<text.length; i++) {
        c=[text characterAtIndex:i];
        if (!isdigit(c)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isNumOrEnglish:(NSString *)text {
    NSInteger alength = [text length];
    for (int i = 0; i<alength; i++) {
        char commitChar = [text characterAtIndex:i];
        NSString *temp = [text substringWithRange:NSMakeRange(i,1)];
        const char *u8Temp = [temp UTF8String];
        if (3==strlen(u8Temp)){
            return NO;
        }else if((commitChar>64)&&(commitChar<91)){
           // NSLog(@"字符串中含有大写英文字母");
        }else if((commitChar>96)&&(commitChar<123)){
          //  NSLog(@"字符串中含有小写英文字母");
        }else if((commitChar>47)&&(commitChar<58)){
          //  NSLog(@"字符串中含有数字");
        }else{
            return NO;
        }
    }
    return YES;
}

@end

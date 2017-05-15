//
//  ViewController.m
//  DemoStripePayment
//
//  Created by Bhavin Gupta on 27/01/17.
//  Copyright © 2017 Easy Pay. All rights reserved.
//

#import "ViewController.h"
#import "PaymentViewController.h"
#import "Constants.h"
#import "Numpad.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface ViewController ()<PaymentViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UITextField *txtEnterPayableAmount;
@property (nonatomic, strong) PaymentViewController *paymentViewController;

@end

@implementation ViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IPAD){
        // Custom Numeric Pad For iPad
        Numpad *numpad = [[Numpad alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 352.0f)];
        numpad.textField = self.txtEnterPayableAmount;
        self.txtEnterPayableAmount.inputView = numpad;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.txtEnterPayableAmount){
        return [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Present Error And Payment Succeeded Methods
- (void)presentError:(NSError *)error {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)paymentSucceeded {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Success" message:@"Payment successfully created!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Custom Payment Method
- (IBAction)beginCustomPayment:(id)sender {
    if([self.txtEnterPayableAmount isFirstResponder])
        [self.txtEnterPayableAmount resignFirstResponder];
    
    self.paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
    
    if([self.txtEnterPayableAmount.text length]==0 || [self.txtEnterPayableAmount.text isEqualToString:@"0"]){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Demo Stripe Payment" message:@"Please enter amount" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [controller addAction:action];
        [self presentViewController:controller animated:YES completion:nil];
        return;
    }
    self.paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:self.txtEnterPayableAmount.text];
    self.paymentViewController.backendCharger = self;
    self.paymentViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.paymentViewController];
    [self presentViewController:navController animated:YES completion:nil];
    [self.txtEnterPayableAmount setText:@""];
}

- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error {
    [self.paymentViewController dismissViewControllerAnimated:YES completion:^{
        if (error) {
            [self presentError:error];
        } else {
            [self paymentSucceeded];
        }
    }];
}

#pragma mark - STP Backend Charging Method
- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion {
    if (!BackendChargeURLString) {
        NSError *error = [NSError
                          errorWithDomain:StripeDomain
                          code:STPInvalidRequestError
                          userInfo:@{
                                     NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "
                                                                 @"instructions in the README to set up an example backend, or use this "
                                                                 @"token to manually create charges at dashboard.stripe.com .",
                                                                 token.tokenId]
                                     }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSString *urlString = [BackendChargeURLString stringByAppendingPathComponent:@"charge_card"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"stripe_token=%@&amount=%@", token.tokenId, [NSString stringWithFormat:@"%@",self.paymentViewController.amount]];
    NSData *data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request
                                                               fromData:data
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                                          if (!error && httpResponse.statusCode != 200) {
                                                              error = [NSError errorWithDomain:StripeDomain
                                                                                          code:STPInvalidRequestError
                                                                                      userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                                          }
                                                          if (error) {
                                                              completion(STPBackendChargeResultFailure, error);
                                                          } else {
                                                              completion(STPBackendChargeResultSuccess, nil);
                                                          }
                                                      }];
    
    [uploadTask resume];
}

@end

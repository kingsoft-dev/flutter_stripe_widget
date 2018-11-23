#import "StripeWidgetPlugin.h"

@implementation StripeWidgetPlugin{
  FlutterResult flutterResult;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"stripe_widget"
            binaryMessenger:[registrar messenger]];
  StripeWidgetPlugin* instance = [[StripeWidgetPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   if ([@"addSource" isEqualToString:call.method]) {

       [self openStripeCardVCWithResult:result];
   }
   else if ([@"setPublishableKey" isEqualToString:call.method]) {
       [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:call.arguments];
   }
   else {
       result(FlutterMethodNotImplemented);
   }
}

-(void)openStripeCardVCWithResult:(FlutterResult) result {
    flutterResult = result;
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    STPAddSourceViewController* addSourceVC = [[STPAddSourceViewController alloc] init];
    addSourceVC.srcDelegate = self;
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:addSourceVC];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];

    [vc presentViewController:navigationController animated:true completion:nil];
}

- (void)addCardViewControllerDidCancel:(STPAddSourceViewController *)addCardViewController {
    [addCardViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)addCardViewController:(STPAddSourceViewController *)addCardViewController didCreateToken:(STPToken *)token completion:(STPErrorBlock)completion {
    flutterResult(token.tokenId);
    
    [addCardViewController dismissViewControllerAnimated:true completion:nil];

}


@end

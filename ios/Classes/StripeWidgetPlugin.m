#import "StripeWidgetPlugin.h"

@implementation StripeWidgetPlugin{
  FlutterResult flutterResult;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"stripe_widget"
            binaryMessenger:[registrar messenger]];
  UIViewController *viewController = (UIViewController *)registrar.window.rootViewController;
  StripeWidgetPlugin* instance = [[StripeWidgetPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   if ([@"addSource" isEqualToString:call.method]) {

       [self openStripeCardVC:self.viewController result:result];
   }
   else if ([@"setPublishableKey" isEqualToString:call.method]) {
       [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:call.arguments];
   }
   else {
       result(FlutterMethodNotImplemented);
   }
}

-(void)openStripeCardVC:(UIViewController*)controller result:(FlutterResult) result {
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

- (void)addCardViewController:(STPAddSourceViewController *)addCardViewController
              didCreateSource:(STPSource *)source
                   completion:(STPErrorBlock)completion {
    flutterResult(source.stripeID);

    [addCardViewController dismissViewControllerAnimated:true completion:nil];
}
@end

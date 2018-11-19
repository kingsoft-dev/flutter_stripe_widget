#import <Flutter/Flutter.h>
#import "STPAddSourceViewController.h"

@interface StripeWidgetPlugin : NSObject<FlutterPlugin, STPAddSourceViewControllerDelegate>
@property (nonatomic, retain) UIViewController *viewController;
@end

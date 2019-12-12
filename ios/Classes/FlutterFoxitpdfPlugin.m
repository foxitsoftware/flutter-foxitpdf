#import "FlutterFoxitpdfPlugin.h"

@interface FlutterFoxitpdfPlugin() <UIExtensionsManagerDelegate>

@property (nonatomic, strong) FSPDFViewCtrl *pdfViewCtrl;
@property (nonatomic, strong) UIExtensionsManager *uiextensionManager;
@property (nonatomic, strong) UIViewController *pdfViewController;
@property (nonatomic, strong) UINavigationController *navgationController;
@end

@implementation FlutterFoxitpdfPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_foxitpdf"
            binaryMessenger:[registrar messenger]];
  FlutterFoxitpdfPlugin* instance = [[FlutterFoxitpdfPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"initialize" isEqualToString:call.method]) {
      [self initialize:call result:result];
  } else if ([@"openDocument" isEqualToString:call.method]) {
      [self openDocument:call result:result];
   } else {
    result(FlutterMethodNotImplemented);
  }
}

static FSErrorCode errorCode = FSErrUnknown;

- (void)initialize:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *sn = call.arguments[@"sn"];
    NSString *key = call.arguments[@"key"];
    errorCode = [FSLibrary initialize:sn key:key];
    //result(errorCode);
}

- (void)openDocument:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (errorCode != FSErrSuccess) {
        //[result error:("" + errorCode,"Failed to initialize Foxit Library", errorCode)];
      return;
    }
    
    NSString *path = call.arguments[@"path"];
    if (path == NULL)
    {
        return;
    }
    
    NSString *password = call.arguments[@"password"];
    if ((NSNull *)password == [NSNull null] || password == NULL) {
        password = nil;
    } else {
        password = [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (password.length == 0) {
            password = nil;
        }
    }
    
    self.pdfViewCtrl = [[FSPDFViewCtrl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.uiextensionManager = [[UIExtensionsManager alloc] initWithPDFViewControl:self.pdfViewCtrl];
    self.pdfViewCtrl.extensionsManager = self.uiextensionManager;
    
    self.pdfViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    
    self.navgationController = [[UINavigationController alloc] init];
    self.navgationController.view = self.pdfViewCtrl;
    self.navgationController.navigationBarHidden = YES;
    self.navgationController.view.frame = [[UIScreen mainScreen] bounds];
    self.navgationController.interactivePopGestureRecognizer.enabled = NO;

    //show
    __weak FlutterFoxitpdfPlugin *weakSelf = self;
    [self.pdfViewCtrl openDoc:path password:password completion:^(FSErrorCode error) {
        if (error == FSErrSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.pdfViewController presentViewController:weakSelf.navgationController animated:YES completion:nil];
            });
        } else{
            
        }
    }];
    
    self.uiextensionManager.goBack = ^() {
        [weakSelf.pdfViewController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
    };
}


@end

#import "FlutterFoxitpdfPlugin.h"

@interface PDFViewController : UIViewController
@property (nonatomic, weak) UIExtensionsManager *extensionsManager;
@end

@interface FlutterFoxitpdfPlugin() <UIExtensionsManagerDelegate>

@property (nonatomic, strong) FSPDFViewCtrl *pdfViewCtrl;
@property (nonatomic, strong) UIExtensionsManager *uiextensionManager;
@property (nonatomic, strong) PDFViewController *pdfViewController;
@property (nonatomic, strong) UINavigationController *rootViewController;
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
   } else if ([@"openDocFromUrl" isEqualToString:call.method]) {
       [self openDocFromUrl:call result:result];
    }else {
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

- (void)openDocFromUrl:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (errorCode != FSErrSuccess) {
        //[result error:("" + errorCode,"Failed to initialize Foxit Library", errorCode)];
      return;
    }
    
    NSString *path = call.arguments[@"path"];
    NSURL *targetURL = [NSURL URLWithString:path];
    if (path == NULL || !targetURL)
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
    
    self.pdfViewController = [[PDFViewController alloc] init];
    self.pdfViewController.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pdfViewController.view = self.pdfViewCtrl;
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.pdfViewController];
    self.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.rootViewController.navigationBarHidden = YES;
    self.pdfViewController.extensionsManager = self.uiextensionManager;

    //show
    __weak FlutterFoxitpdfPlugin *weakSelf = self;
    [self.pdfViewCtrl openDocFromURL:targetURL password:password cacheOption:nil httpRequestProperties:nil completion:^(FSErrorCode error) {
        if (error == FSErrSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[weakSelf topMostViewController] presentViewController:weakSelf.rootViewController animated:YES completion:nil];
            });
        } else{
            
        }
    }];
    
    self.uiextensionManager.goBack = ^() {
        [weakSelf.rootViewController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
    };

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
    
    self.pdfViewController = [[PDFViewController alloc] init];
    self.pdfViewController.automaticallyAdjustsScrollViewInsets = NO;
    
    self.pdfViewController.view = self.pdfViewCtrl;
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.pdfViewController];
    self.rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.rootViewController.navigationBarHidden = YES;
    self.pdfViewController.extensionsManager = self.uiextensionManager;

    //show
    __weak FlutterFoxitpdfPlugin *weakSelf = self;
    [self.pdfViewCtrl openDoc:path password:password completion:^(FSErrorCode error) {
        if (error == FSErrSuccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[weakSelf topMostViewController] presentViewController:weakSelf.rootViewController animated:YES completion:nil];
            });
        } else{
            
        }
    }];
    
    self.uiextensionManager.goBack = ^() {
        [weakSelf.rootViewController dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
    };
}

- (UIViewController*) topMostViewController {
    UIViewController *presentingViewController = [self getForegroundActiveWindow].rootViewController;
    while (presentingViewController.presentedViewController != nil) {
        presentingViewController = presentingViewController.presentedViewController;
    }
    return presentingViewController;
}

- (UIWindow *)getForegroundActiveWindow{

    UIWindow *originalKeyWindow = nil;
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                if (windowScene.activationState == UISceneActivationStateUnattached){
                    originalKeyWindow = windowScene.windows.firstObject;
                }
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            originalKeyWindow = window;
                            break;
                        }
                    }
                }
            }

        }
        if (originalKeyWindow) {
            return originalKeyWindow;
        }
    }
    #endif
    return [[[UIApplication sharedApplication] delegate] window];
}

@end


@implementation PDFViewController
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return !self.extensionsManager.isScreenLocked;
}

- (BOOL)shouldAutorotate {
    return !self.extensionsManager.isScreenLocked;
}

- (BOOL)prefersStatusBarHidden {
    return self.extensionsManager.prefersStatusBarHidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end

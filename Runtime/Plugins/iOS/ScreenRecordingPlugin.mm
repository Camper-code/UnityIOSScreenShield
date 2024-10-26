#import <UIKit/UIKit.h>

static UIView *protectionView = nil;

extern "C" {
    void BlockScreenRecording() {
        if (@available(iOS 11.0, *)) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            if (!protectionView) {
                // Створюємо чорний захисний екран
                protectionView = [[UIView alloc] initWithFrame:window.bounds];
                protectionView.backgroundColor = [UIColor blackColor];
                protectionView.hidden = YES;
                protectionView.userInteractionEnabled = NO;
                [window addSubview:protectionView];

                // Спостерігач за змінами стану запису екрану
                [[NSNotificationCenter defaultCenter] addObserverForName:UIScreenCapturedDidChangeNotification
                                                                  object:nil
                                                                   queue:[NSOperationQueue mainQueue]
                                                              usingBlock:^(NSNotification * _Nonnull note) {
                    protectionView.hidden = !UIScreen.mainScreen.isCaptured;
                }];

                // Спостерігач за переходом у фоновий режим (блокування скріншотів)
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                                  object:nil
                                                                   queue:[NSOperationQueue mainQueue]
                                                              usingBlock:^(NSNotification * _Nonnull note) {
                    // При переході у фоновий режим вмикаємо чорний екран
                    protectionView.hidden = NO;
                }];

                // Спостерігач за поверненням в активний режим
                [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                  object:nil
                                                                   queue:[NSOperationQueue mainQueue]
                                                              usingBlock:^(NSNotification * _Nonnull note) {
                    // При поверненні в активний режим ховаємо чорний екран, якщо не записується екран
                    protectionView.hidden = !UIScreen.mainScreen.isCaptured;
                }];
            }
        }
    }
}

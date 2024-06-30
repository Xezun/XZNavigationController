//
//  XZNavigationControllerDefines.h
//  XZNavigationController
//
//  Created by 徐臻 on 2024/6/30.
//

#import <UIKit/UIKit.h>

#if XZ_FRAMEWORK
#define XZ_NAVC_PRIVATE_METHOD
#define XZ_NAVC_PRIVATE_CLASS
#else
#define XZ_NAVC_PRIVATE_METHOD NS_UNAVAILABLE
#define XZ_NAVC_PRIVATE_CLASS NS_UNAVAILABLE
#endif

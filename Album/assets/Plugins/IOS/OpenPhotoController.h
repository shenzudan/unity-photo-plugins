//
//  OpenPhotoController.h
//  UnityAlbum
//
//  Created by StanWind on 2017/5/6.
//  Copyright © 2017年 StanWind. All rights reserved.
//

@interface OpenPhotoController : UIViewController<UIApplicationDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>
{
    
    UIView*                _rootView;
    UIViewController*    _rootController;
@private
    id _popoverViewController;
}
@property (nonatomic, retain) id popoverViewController;
@end

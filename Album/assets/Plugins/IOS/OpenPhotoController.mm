//
//  OpenPhotoController.m
//  UnityAlbum
//
//  Created by StanWind on 2017/5/6.
//  Copyright © 2017年 StanWind. All rights reserved.
//

#import "OpenPhotoController.h"

@interface OpenPhotoController()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation OpenPhotoController
{
    UIAlertController *alert;
}
@synthesize popoverViewController = _popoverViewController;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self showActionSheet:self];
}

-(void)showActionSheet:(OpenPhotoController *)app
{
    alert = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPicker:UIImagePickerControllerSourceTypeCamera vc:app];
    }];
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showPicker:UIImagePickerControllerSourceTypePhotoLibrary vc:app];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:cameraAction];
    [alert addAction:photosAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    //[sheet release];
    
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if( buttonIndex == 0 )
//    {
//        [self showPicker:UIImagePickerControllerSourceTypeCamera];
//    }
//    else if( buttonIndex == 1 )
//    {
//        [self showPicker:UIImagePickerControllerSourceTypePhotoLibrary];
//    }
//    else // Cancelled
//    {
//        //UnityPause( false );
//        //UnitySendMessage( "EtceteraManager", "imagePickerDidCancel", "" );
//    }
}

- (void)showPicker:(UIImagePickerControllerSourceType)type vc:(OpenPhotoController *)app
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = app;
    picker.sourceType = type;
    picker.allowsEditing = YES;
    
    // We need to display this in a popover on iPad
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        Class popoverClass = NSClassFromString( @"UIPopoverController" );
        if( !popoverClass )
            return;
        
        _popoverViewController = [[popoverClass alloc] initWithContentViewController:picker];
        [_popoverViewController setDelegate:self];
        //picker.modalInPopover = YES;
        
        // Display the popover
        [_popoverViewController presentPopoverFromRect:CGRectMake( 0, 0, 128, 128 )
                                                inView:UnityGetGLViewController().view
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
    }
    else
    {
        // wrap and show the modal
//        UIViewController *vc = UnityGetGLViewController();
        [app presentModalViewController:picker animated:YES];
    }
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController*)popoverController
{
    self.popoverViewController = nil;
    //UnityPause( false );
    
    //UnitySendMessage( "EtceteraManager", "imagePickerDidCancel", "" );
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    // Grab the image and write it to disk
    UIImage *image;
    UIImage *image2;
    //  if( _pickerAllowsEditing )
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    //        else
    //            image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //NSLog( @"picker got image with orientation: %i", image.imageOrientation );
    UIGraphicsBeginImageContext(CGSizeMake(128,128));
    [image drawInRect:CGRectMake(0, 0, 128, 128)];
    image2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 得到了image，然后用你的函数传回u3d
    NSData *imgData;
    if(UIImagePNGRepresentation(image2) == nil)
    {
        imgData= UIImageJPEGRepresentation(image2, 0.5);
    }
    else
    {
        imgData= UIImageJPEGRepresentation(image2, 0.5);
    }
    
    NSString *_encodeImageStr = [imgData base64Encoding];
    
    UnitySendMessage( "Stan", "PhotoCallBack", _encodeImageStr.UTF8String);
    // Dimiss the pickerController
    [self dismissWrappedController];
    [self Dis];
//    [self presentViewController:UnityGetGLViewController() animated:YES completion:nil];
}
-(void)Dis{
    [alert dismissViewControllerAnimated:NO completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // dismiss the wrapper, unpause and notifiy Unity what happened
    [self dismissWrappedController];
    //UnityPause( false );
    //UnitySendMessage( "EtceteraManager", "imagePickerDidCancel", "" );
}

- (void)dismissWrappedController
{
    //UnityPause( false );
    
    UIViewController *vc = UnityGetGLViewController();
    
    // No view controller? Get out of here.
    if( !vc )
        return;
    
    // dismiss the view controller
    [vc dismissModalViewControllerAnimated:YES];
    
    // remove the wrapper view controller
    [self performSelector:@selector(removeAndReleaseViewControllerWrapper) withObject:nil afterDelay:1.0];
    
    //UnitySendMessage( "EtceteraManager", "dismissingViewController", "" );
}

- (void)removeAndReleaseViewControllerWrapper
{
    // iPad might have a popover
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && _popoverViewController )
    {
        [_popoverViewController dismissPopoverAnimated:YES];
        self.popoverViewController = nil;
    }
}
@end

extern "C"
{
    void openPhoto()//相册
    {
        //UnityPause( true );
        
        OpenPhotoController * app = [[OpenPhotoController alloc] init];
        // No need to give a choice for devices with no camera
//        if( ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
//        {
//            [app showPicker:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
//            return;
//        }
        app.modalPresentationStyle = UIModalPresentationCurrentContext;
        [UnityGetGLViewController() presentViewController:app animated:YES completion:nil];
//        [app showActionSheet:app];
        
    }
    
}

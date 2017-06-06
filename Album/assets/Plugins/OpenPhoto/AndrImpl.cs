using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

/**
 * Android打开相册impl
 */
namespace com.stanwind.unity3d{
	//预编译写在外面 不然切换平台会提示某个平台下声明了类却没实现方法
	#if UNITY_ANDROID
	public class AndrImpl: StanImpl{
		public override void OpenPhoto(){
			AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");  
			AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");  
			jo.Call("TakePhoto","Lib");  //相册
			//jo.Call("TakePhoto","takePhoto") //相机
		}
	}
	#endif
}
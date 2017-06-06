using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

/**
 * IOS打开相册impl
 */
namespace com.stanwind.unity3d{
	//预编译写在外面 不然切换平台会提示某个平台下声明了类却没实现方法
	#if UNITY_IOS
	public class IOSImpl : StanImpl{
		
		[DllImport("__Internal")]
		private static extern void openPhoto();

		public override void OpenPhoto(){
			openPhoto ();
		}
	}
	#endif
}
using UnityEngine;
using System;
using System.Collections;

public class StanListener : MonoBehaviour {
	public delegate void PhotoHandler(byte[] img);

	/// <summary>
	/// Photo Select Finish handler.
	/// </summary>
	public static PhotoHandler PhotoSelectFinishHandler;

	//Default listener
	void Awake () {
		PhotoSelectFinishHandler+=delefunTest;
	}

	public void PhotoCallBack(string encode){
		//System.Console.WriteLine ("Ios Callback Base64->"+encode);
		Debug.Log ("Ios Callback Base64->" + encode);
		//Base64转bytes
		byte[] bytes = Convert.FromBase64String(encode); 
		//调用回调去通知方法
		PhotoSelectFinishHandler (bytes);
	}

	public void delefunTest(byte[] img){
		System.Console.WriteLine ("Unity Default Callback imgLen->"+img.Length);
	}

}

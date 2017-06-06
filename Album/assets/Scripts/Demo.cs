using UnityEngine;
using System.Collections;
using com.stanwind.unity3d;

public class Demo : MonoBehaviour {
	public SpriteRenderer spr;
	void Awake () {
		//收到图片回调处理
		StanListener.PhotoSelectFinishHandler += (img) => {
			int width = 128;
			int height = 128;
			Texture2D texture = new Texture2D(width, height);
			texture.LoadImage(img);
			Sprite sprite = Sprite.Create(texture, new Rect(0, 0, texture.width, texture.height), new Vector2(0.5f, 0.5f));
			spr.sprite = sprite;
			Resources.UnloadUnusedAssets(); //一定要清理游离资源。
		};
	}
}

using UnityEngine;
using System.Collections;

public class girlTextScript : MonoBehaviour {

	// Use this for initialization
	void Start () {

	}
	
	// Update is called once per frame
	void Update () {
		//-(Screen.width / 2) + 600
		this.GetComponent<GUIText>().pixelOffset = new Vector2(0, -(Screen.height/2) + 100);
	}
}

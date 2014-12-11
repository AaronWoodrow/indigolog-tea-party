using UnityEngine;
using System.Collections;

public class ConvoHistory : MonoBehaviour {
	
	private string convoText;
	private bool girlTalking;
	private Vector2 scrollPosition = Vector2.zero;
	
	// Use this for initialization
	void Start () {
		convoText = "";
		scrollPosition.y = 10000;
		girlTalking = true;
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	
	void OnGUI () {
		GUILayout.BeginArea (new Rect(500, 0, Screen.width-500, Screen.height)); //-100 - 50
	    scrollPosition = GUILayout.BeginScrollView (scrollPosition, GUILayout.Width(Screen.width-500), GUILayout.Height(100));
	    GUI.skin.box.wordWrap = true;
		GUI.skin.box.alignment = TextAnchor.UpperLeft;
		if (girlTalking){
			GUI.skin.box.normal.textColor = Color.red;
		} else {
			GUI.skin.box.normal.textColor = Color.yellow;
		}
	    GUILayout.Box(convoText);
	     
	    GUILayout.EndScrollView ();
	     
	    GUILayout.EndArea();
	}
	
	public string getConvoText(){
		return this.convoText;
	}
	
	public void setConvoText(string s){
		this.convoText = this.convoText + s;
	}
	
	public void setGirlTalking(bool b){
		this.girlTalking = b;	
	}
}

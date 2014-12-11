using UnityEngine;
using System.Collections;

public class WriteToGUI : MonoBehaviour {
	
	private Vector2 scrollPosition = Vector2.zero;
	
	// Use this for initialization
	void Start () {
		scrollPosition.y = 10000;
	}
	
	public GUIText gUITextObject;
	public string textToDisplay = "";
	
	// Update is called once per frame
	//private Vector2 scrollViewVector = Vector2.zero;
	//private string innerText = "I am inside the ScrollView";
	

	void OnGUI () {
		
		GUILayout.BeginArea (new Rect(0, 0, 500, Screen.height)); //-100 - 50
	    scrollPosition = GUILayout.BeginScrollView (scrollPosition, GUILayout.Width(500), GUILayout.Height(100));
	    GUI.skin.box.wordWrap = true;
		GUI.skin.box.alignment = TextAnchor.UpperLeft;
		GUI.skin.box.normal.textColor = Color.white;
	    GUILayout.Box(textToDisplay);
	    GUILayout.EndScrollView ();
	    GUILayout.EndArea();
		/*
		// Begin the ScrollView
		scrollViewVector = GUI.BeginScrollView (new Rect (0, 0, 500, 100), scrollViewVector, new Rect (0, 0, 400, 400));

		// Put something inside the ScrollView
		//innerText = GUI.TextArea (new Rect (0, 0, 400, 400), innerText);
		GUI.Label (new Rect (0, 0, 400, 400), textToDisplay);

		// End the ScrollView
		GUI.EndScrollView();
		*/
	}
	void Update () {
		
	}
}

using UnityEngine;
using System.Collections;

public class MyTextSelection : MonoBehaviour {
	
	TcpServer server;
	
	public int numberOfChoices;
	private int treeLevel;
	GUIText myText;
	GUIText girlText;
	public bool selection;
	
	// Use this for initialization
	void Start () {
		server = GameObject.Find("Server").GetComponent<TcpServer>();
		myText = GameObject.Find ("MyText").GetComponent<GUIText>();
		girlText = GameObject.Find ("girlText").GetComponent<GUIText>();
		selection = false;
		numberOfChoices = 1;
		treeLevel = 1;
	}
	
	// Update is called once per frame
	void Update () {
		if (selection)
		{
			if (Input.GetKeyDown(KeyCode.Alpha1) && numberOfChoices > 0){
				Debug.Log ("1 was clicked");
				myText.text = "";
				girlText.text = "";
				selection = false;
				if (server.getSW() != null){ 
					server.getSW().WriteLine("chose(1," + treeLevel + ")");
					treeLevel++;
				}
			
			}
			else if (Input.GetKeyDown(KeyCode.Alpha2) && numberOfChoices > 1){
				Debug.Log ("2 was clicked");
				myText.text = "";
				girlText.text = "";
				selection = false;
				if (server.getSW() != null){ 
					server.getSW().WriteLine("chose(2," + treeLevel + ")");
					treeLevel++;
				}
			}
			else if (Input.GetKeyDown(KeyCode.Alpha3) && numberOfChoices > 2){
				Debug.Log ("3 was clicked");
				myText.text = "";
				girlText.text = "";
				selection = false;
				if (server.getSW() != null){ 
					server.getSW().WriteLine("chose(3," + treeLevel + ")");
					treeLevel++;
				}
			}
			else if (Input.GetKeyDown(KeyCode.Alpha4) && numberOfChoices > 3){
				Debug.Log ("4 was clicked");
				myText.text = "";
				girlText.text = "";
				selection = false;
				if (server.getSW() != null){ 
					server.getSW().WriteLine("chose(4," + treeLevel + ")");
					treeLevel++;
				}
			}
		}
	}
	
}

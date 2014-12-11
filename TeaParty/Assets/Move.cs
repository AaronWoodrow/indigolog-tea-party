using UnityEngine;
using System.Collections;

public class Move : MonoBehaviour {

	public GameObject target;
	private Vector3 startPos;
	
	// Use this for initialization
	void Start () {
		//target = GameObject.Find("Lefthand"); //destination
		startPos = transform.position;
	}
	
	float speed = 5.0f;
	public bool moving = false;
	private float weight = 0.0f;
	
	// Update is called once per frame
	void Update () {
		
		//if (Input.GetKeyDown(KeyCode.E))
		//{
			//startPos = transform.position;
			//moving = true;
		//}
		/*
		else if (Input.GetKeyDown(KeyCode.Q))
		{
			target = GameObject.Find(go.name + "Pos");
			startPos = go.transform.position;
			moving = true;	
		}
		*/
		if(transform.position == target.transform.position){
			moving = false;
			weight = 0.0f;
		}
		if(moving){
			weight += Time.deltaTime * speed;
			transform.position = Vector3.Lerp(startPos, target.transform.position, weight);
		}
	}
}

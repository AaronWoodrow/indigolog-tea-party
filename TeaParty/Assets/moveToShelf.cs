using UnityEngine;
using System.Collections;

public class moveToShelf : MonoBehaviour {
	
	GameObject n1;
	GameObject n2;
	GameObject n3;
	GameObject n4;
	GameObject girl;
	GameObject server;
	
	// Use this for initialization
	void Start () {
		n1 =  GameObject.Find("n1");
		n2 =  GameObject.Find("n2");
		n3 =  GameObject.Find("n3");
		n4 =  GameObject.Find("n4");
		girl = GameObject.Find("Girl");
		server = GameObject.Find("Server");
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.M) && girl.transform.position == n1.transform.position)
		{
			Debug.Log(n4.transform.rotation.y);
			girl.GetComponent<SplineController>().FollowSpline();
			server.GetComponent<TcpServer>().getSW().WriteLine("moveExog(shelf)");
		} 
		else if (Input.GetKeyDown(KeyCode.N)&& (girl.transform.position == n4.transform.position))
		{
			server.GetComponent<TcpServer>().getSW().WriteLine("moveExog(table)");
			Vector3 temp;
			//reverse the nodes
			Vector3 n1Pos = n1.transform.position;
			Vector3 n2Pos = n2.transform.position;
			Vector3 n3Pos = n3.transform.position;
			Vector3 n4Pos = n4.transform.position;
			
			n1.transform.position = n4Pos;
			n4.transform.position = n1Pos;
			n2.transform.position = n3Pos;
			n3.transform.position = n2Pos;
				
			n1.transform.Rotate(new Vector3(0.0f, -90.0f, 0.0f));
			n2.transform.Rotate(new Vector3(0.0f, -180.0f, 0.0f));
			n3.transform.Rotate(new Vector3(0.0f, -90.0f, 0.0f));
			n4.transform.Rotate(new Vector3(0.0f, -90.0f, 0.0f));
			Debug.Log(n4.transform.rotation.y);
			girl.GetComponent<SplineController>().FollowSpline();
			
			server.GetComponent<TcpServer>().getSW().WriteLine("moveExog(table)");
			
			n1.transform.position = n1Pos;
			n4.transform.position = n4Pos;
			n2.transform.position = n2Pos;
			n3.transform.position = n3Pos;
			
			n1.transform.Rotate(new Vector3(0.0f, 90.0f, 0.0f));
			n2.transform.Rotate(new Vector3(0.0f, 180.0f, 0.0f));
			n3.transform.Rotate(new Vector3(0.0f, 90.0f, 0.0f));
			n4.transform.Rotate(new Vector3(0.0f, 90.0f, 0.0f));
		}
	}
}

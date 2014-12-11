using UnityEngine;
using System.Collections;

public class myHSplineTest : MonoBehaviour {
	
	GameObject go1;
	GameObject go2;
	GameObject go3;
	GameObject cyl;
	GameObject cube;
	GameObject root;
	
	// Use this for initialization
	void Start () {
		go1 =  GameObject.Find("1");
		go2 =  GameObject.Find("2");
		go3 =  GameObject.Find("3");
		cyl =  GameObject.Find("Cylinder");
		cube = GameObject.Find("Cube1");
		root = GameObject.Find("SplineRoot");
		if (root == null) Debug.Log("ROOT IS NULL");
		cyl.AddComponent("SplineController");
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown(KeyCode.Alpha1))
		{
			Debug.Log(go1.transform.position.x);
			go1.transform.position = cyl.transform.position;
			go3.transform.position = cube.transform.position;
			cyl.GetComponent<SplineController>().AutoStart = false;
			cyl.GetComponent<SplineController>().AutoClose = false;
			cyl.GetComponent<SplineController>().SplineRoot = root;
			cyl.GetComponent<SplineController>().FollowSpline();
		}
	}
}

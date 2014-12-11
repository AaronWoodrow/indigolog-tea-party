#pragma strict

function Start () {

}

var switchToTarget : Transform;

function Update () {
	if (Input.GetButtonDown("Jump"))
	{
		GetComponent(Follow).target = switchToTarget;
		/*
		var newTarget = GameObject.FindWithTag("Cube1").transform;
		GetComponent(Follow).target = newTarget;
		*/
	}
}
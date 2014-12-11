#pragma strict

function Start () {

}

var newObject : Transform;
private var cubeCount = 0;

function Update () {
	if (Input.GetButtonDown("Fire1")) {
		Instantiate(newObject, transform.position, transform.rotation);
		Debug.Log("Cube created");
		cubeCount++;

	}

}
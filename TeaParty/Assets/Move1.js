#pragma strict

function Start () {

}

var speed = 5.0;

function Update () {
	var x = Input.GetAxis("Horizontal") * Time.deltaTime * speed;
	var y = 0.0;
	if (Input.GetKey(KeyCode.E))
	{
		y = 1.0 * Time.deltaTime * speed;
	}
	else if (Input.GetKey(KeyCode.Q))
	{
		y = -1.0 * Time.deltaTime * speed;
	}
	
	var z = Input.GetAxis("Vertical") * Time.deltaTime * speed;
	// print ("x: " + x + "y: " + y);
	transform.Translate(x, y, z);
}
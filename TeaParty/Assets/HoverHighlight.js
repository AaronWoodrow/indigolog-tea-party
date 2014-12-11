#pragma strict

var origColor : Color;
origColor = renderer.material.color;
var highlightColor : float;
highlightColor = 1.5;

function Start () {

}

function Update () {

}

function OnMouseOver(){
	
	//if (renderer.material.color.r < 10.0)
	//{
	/*
		while (true)
		{
			renderer.material.color.r += 10.0 * Time.deltaTime;
			renderer.material.color.r -= 10.0 * Time.deltaTime;
		}
	*/
	//renderer.material.color.r = Mathf.Sin(Time.time) * 255.0 + 255.0;
	//}
	//else if (renderer.material.color.r < 1.0)
	//{
	var newR;
	var newG;
	var newB;
	newR = renderer.material.color.r * highlightColor;
	newG = renderer.material.color.g * highlightColor;
	newB = renderer.material.color.b * highlightColor;
	renderer.material.color = new Color(newR, newG, newB);
	
	//} 
}

function OnMouseExit(){
		renderer.material.color = origColor;
}
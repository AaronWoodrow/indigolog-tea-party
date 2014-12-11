#pragma strict

function Start () {

}

var target : Transform;

function Update () {
	transform.LookAt(target);
}
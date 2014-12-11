using UnityEngine;
using System.Collections;

public class lerpTest : MonoBehaviour {
    
    public Transform target;
    public float speed;
    
    //Transform sphere;

	//// Use this for initialization
	void Start () {
	    //sphere = GameObject.Find("Sphere").transform;
	}
	
	// Update is called once per frame
	void Update () {
	     Vector3 targetDir = target.position - transform.position;
        float step = speed * Time.deltaTime;
        //Vector3 newDir = Vector3.RotateTowards(transform.forward, targetDir, step, 0.0F);
        Vector3 newDir = Vector3.RotateTowards(transform.up, targetDir, step, 0.0F);
        Debug.DrawRay(transform.position, newDir, Color.red);
        transform.rotation = Quaternion.LookRotation(newDir);
	}
    
    void LateUpdate () {
        //Vector3.
 }
}

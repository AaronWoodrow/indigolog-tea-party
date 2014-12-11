using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Animator))]
public class TargetCtrl : MonoBehaviour {
 
    protected Animator animator;    

    //the platform object in the scene
    public Transform sitTarget = null; 
    public Transform standTarget = null;
    
	// Use this for initialization
	void Start () {
	    animator = GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {
	    if(animator) {
            if(Input.GetKeyDown(KeyCode.U))               
                animator.MatchTarget(sitTarget.position, sitTarget.rotation, AvatarTarget.Body, new MatchTargetWeightMask(Vector3.zero, 1f), 0.492f, 0.499f);
            if(Input.GetKeyDown(KeyCode.I))               
                animator.MatchTarget(standTarget.position, standTarget.rotation, AvatarTarget.Root, new MatchTargetWeightMask(Vector3.one, 1f), 0.097f, 0.259f);
        }   
       
	}
}

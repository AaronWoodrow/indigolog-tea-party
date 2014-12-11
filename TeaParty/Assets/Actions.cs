using UnityEngine;
using System.Collections;

public class Actions : MonoBehaviour {
    //THIS IS FOR GIRL DOLL MODEL
        /******************
	GameObject go;
	GameObject target;
	GameObject n1;
	GameObject n2;
	**********************/
    GameObject target;  // The target to face before walking.
    Transform standTarget2;
    Transform waypoint1;
    Transform waypoint2;
    Transform waypoint3;
    Transform currentTarget;
    
    bool walkToShelf;
    bool walkFromShelf;
    
    public float rotateSpeed = 0.1f;
   
    public float angleBetween = 0.0f;
    public Transform targetAngle;
    
    public Transform spine;
    public Transform spine1;
    
    private Animator anim;
    private AnimatorStateInfo currentBaseState;
    private AnimatorStateInfo layer2CurrentState;
    private AnimatorStateInfo layer3CurrentState;
    private AnimatorStateInfo layer4CurrentState;
    
    static int idleState = Animator.StringToHash("Base Layer.Idle");
    static int standState = Animator.StringToHash("Base Layer.Stand Up");
    static int sitState = Animator.StringToHash("Base Layer.SitDown");
    static int sitState2 = Animator.StringToHash("SitLayer.SitDown");
    static int walkState = Animator.StringToHash("Base Layer.Walk Forward");
    
	// Use this for initialization
	void Start () {
        
        anim = GetComponent<Animator>();
        
        //if(anim.layerCount ==3)
            anim.SetLayerWeight(2, 1);
        //if(anim.layerCount ==4)
            anim.SetLayerWeight(3, 1);
        
        standTarget2 = GameObject.Find ("standTarget2").transform;
        target = GameObject.Find("waypoint1");
        waypoint1 = GameObject.Find ("waypoint1").transform;
        waypoint2 = GameObject.Find ("waypoint2").transform;
        waypoint3 = GameObject.Find ("waypoint3").transform;
        currentTarget = null;
        
        walkToShelf = true;
        walkFromShelf = false;
        
    //THIS IS FOR GIRL DOLL MODEL
        /******************
		go = GameObject.Find("Cup1");
		target = GameObject.Find("Lefthand"); //destination
		n1 = GameObject.Find("n1");
		if (n1 == null) Debug.Log("n1 IS NULL");
		n2 = GameObject.Find("node2");
		if (n2 == null) Debug.Log("n2 IS NULL");
       **********************/
	}
	//THIS IS FOR GIRL DOLL MODEL
        /******************
	private string[] objects = {"Cup1","Cup2","Cup3","Cup4","Teapot" };
	
	float speed = 5.0f;
	private bool moving = false;
	private float weight = 0.0f;
	private Vector3 startPos;
	    *********************/
	// Update is called once per frame
	void Update () {
        
        currentBaseState = anim.GetCurrentAnimatorStateInfo(0);
        
        //if (anim.layerCount == 2)
            layer2CurrentState = anim.GetCurrentAnimatorStateInfo(1);
        //if (anim.layerCount == 3)
            layer3CurrentState = anim.GetCurrentAnimatorStateInfo(2);
        //if (anim.layerCount == 4)
            layer3CurrentState = anim.GetCurrentAnimatorStateInfo(3);
        /*
        if ((currentBaseState.nameHash == sitState) && !anim.GetBool("Stand"))
        {
            anim.SetBool("Sit", false);
            anim.SetLayerWeight(1,1);
        }
        
        if ((currentBaseState.nameHash == idleState) && anim.GetBool("Stand"))
        {
            anim.SetBool("Stand", false);
        }
         */   
        
        //Vector3 targetDir = targetAngle.position - transform.position;
        Vector3 targetDir = targetAngle.position - spine.position;
        angleBetween = Vector3.Angle(spine.right, targetDir);
        
        if ((currentBaseState.nameHash == idleState) && anim.GetBool("Sit"))
        {
            //anim.SetLayerWeight(3,1);
        }
        
        if (Input.GetKeyDown(KeyCode.U)){
            anim.SetBool("Stand", false);
            anim.SetBool("Sit", true);
        }
        /*
        if (Input.GetKeyDown(KeyCode.I) && (layer2CurrentState.nameHash == sitState2))
        {
            anim.SetLayerWeight(1,0);
            anim.SetBool("Stand",true);
        }
        */
        if (Input.GetKeyDown(KeyCode.I)) //&& (currentBaseState.nameHash == idleState))
        {
            anim.SetBool("Sit", false);
            anim.SetBool("Stand",true);
        }
        
        if (Input.GetKeyDown(KeyCode.O) && (currentBaseState.nameHash == idleState))
        {
            anim.SetBool("Stand",false);
            anim.SetLayerWeight(3,0);
            anim.SetBool("Walk", true);
        }
        
        //Grab object
        if (Input.GetKeyDown(KeyCode.P))
        {
            anim.SetBool("Grab", true);
            GameObject.Find("ikLimb3").GetComponent<ikLimb>().IsEnabled = true;
            GameObject lht = GameObject.Find("LeftHandTarget2");
            GameObject cup2 = GameObject.Find("Cup2Pos");
            Vector3 temp = lht.transform.position;
            temp.y = cup2.transform.position.y;
            temp.z = cup2.transform.position.z;
            lht.transform.position = temp;
            lht.transform.rotation = cup2.transform.rotation;
            lht.transform.RotateAroundLocal(new Vector3(0,1,0),-90);
            
            //Vector3 targetDir = targetAngle.position - transform.position;
            //angleBetween = Vector3.Angle(transform.right, targetDir);
        }
        
        //THIS IS FOR GIRL DOLL MODEL
        /******************    
		if (Input.GetKeyDown(KeyCode.L)){
			//n1 = GameObject.Find("node1");
			//n1.transform.position = go.transform.position;
			//n2 = GameObject.Find("node2");
			n2.transform.position = target.transform.position;
			//go.GetComponent<SplineController>().FollowSpline();
		}		
		//float y = 0.0f;
		else if (Input.GetKeyDown(KeyCode.Space)){
			for (int i = 0; i < objects.Length; i++)
			{
				if (go.name == objects[i]){
					go = GameObject.Find(objects[(i+1)%objects.Length]);
					break;
				}
			}
		}
		else if (Input.GetKeyDown(KeyCode.C)){
			if (target.name == "Lefthand")
				target = GameObject.Find("Righthand");
			else {
				target = GameObject.Find("Lefthand");
			}
		}
		else if (Input.GetKeyDown(KeyCode.E))
		{
			startPos = go.transform.position;
			moving = true;
		}
		else if (Input.GetKeyDown(KeyCode.Q))
		{
			target = GameObject.Find(go.name + "Pos");
			startPos = go.transform.position;
			moving = true;	
		}
		
		if(go.transform.position == target.transform.position){
			moving = false;
			weight = 0.0f;
		}
		if(moving){
			weight += Time.deltaTime * speed;
			go.transform.position = Vector3.Lerp(startPos, target.transform.position, weight);
		}
        *****************/   
	}
    
    void LateUpdate(){
        
        Quaternion targetRotation = Quaternion.LookRotation(target.transform.position - transform.position);
        float str = Mathf.Min (rotateSpeed* Time.deltaTime, 1);
        
        currentBaseState = anim.GetCurrentAnimatorStateInfo(0);
        
        if (anim.GetBool("Grab"))
        {
            Transform lht2 = GameObject.Find("LeftHandTarget2").transform;
            Transform lh = GameObject.Find("LeftHand").transform;
            Transform cup2pos = GameObject.Find("Cup2Pos").transform;
            Vector3 start = lht2.position;
            Vector3 to = cup2pos.position;
            if (angleBetween > 100) lht2.position = Vector3.Lerp(start,to,str);
            
            //Transform spine = GameObject.Find("Spine").transform;
            ////
            Transform spineParent = spine.parent;
            Vector3 spineLocalPosition = spine.localPosition;
            Quaternion spineRotation = spine.rotation;
            
            GameObject spineAxisCorrection = new GameObject("spineAxisCorrection");
            spineAxisCorrection.transform.position = spine.position;
            //spineAxisCorrection.transform.LookAt(spine1.position, transform.root.up);
            //spineAxisCorrection.transform.parent = transform;
            spine.parent = spineAxisCorrection.transform;
            
            Quaternion temp = spineAxisCorrection.transform.rotation;
            
            //if (Vector3.Distance(cup2pos.position,lht2.position)>0.1) spineAxisCorrection.transform.rotation = Quaternion.Lerp(temp, Quaternion.AngleAxis(45,Vector3.up), Time.time*0.4f);
            //if (Vector3.Distance(cup2pos.position,lht2.position)>0.1) spineAxisCorrection.transform.rotation = Quaternion.Lerp(temp, Quaternion.AngleAxis(45, Vector3.right), Time.time*0.4f);
            
            spine.parent = spineParent;
            spine.localPosition = spineLocalPosition;
            Destroy(spineAxisCorrection);
            ////
            
            Transform head = GameObject.Find("Head").transform;
            head.rotation = Quaternion.Lerp(head.rotation, Quaternion.LookRotation(cup2pos.position-head.position,Vector3.up), Time.time*0.4f);
            //head.LookAt(cup2pos);
            //anim.SetBool("Grab",false);
        }
        
        if (currentBaseState.nameHash == sitState)
        {
            target = GameObject.Find("sitTarget");
            Transform start = GameObject.Find("standTarget2").transform;
            targetRotation = Quaternion.AngleAxis(0,Vector3.up);
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, str);
            // The 3rd argument needs to be implemented.
            transform.position = Vector3.Lerp(start.position, target.transform.position, 1);
            anim.SetLayerWeight(3,1);
        }
        
        if (currentBaseState.nameHash == standState)
        {
            target = GameObject.Find("sitTarget");
            Transform start = GameObject.Find("standTarget2").transform;
            targetRotation = Quaternion.AngleAxis(-90,Vector3.up);
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, str);
            // The 3rd argument needs to be implemented.
            transform.position = Vector3.Lerp(start.position, target.transform.position, 0);
            
        }
        
        if ((currentBaseState.nameHash == walkState) && walkToShelf)
        {
            if ((Vector3.Distance(transform.position, standTarget2.position) < 1)) 
            {
                Debug.Log("START POS: " + Vector3.Distance(transform.position, standTarget2.position));
                currentTarget = waypoint1;
            } 
                
            if ((Vector3.Distance(transform.position, waypoint1.position) < 0.5)) 
            {
                Debug.Log("WAYPOINT 1: " + Vector3.Distance(transform.position, waypoint1.position));
                currentTarget = waypoint2;
            }
            
            if ((Vector3.Distance(transform.position, waypoint2.position) < 0.5))
            {
                currentTarget = waypoint3;   
            }
            
            targetRotation = Quaternion.LookRotation(currentTarget.position - transform.position);
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, str);
            
            if ((Vector3.Distance(transform.position, waypoint3.position) < 0.2))
            {
                anim.SetBool("Walk",false);
                walkToShelf = false;
                walkFromShelf = true;
            }
        }
        
        if ((currentBaseState.nameHash == walkState) && walkFromShelf)
        {
            if ((Vector3.Distance(transform.position, waypoint3.position) < 1)) 
            {
                Debug.Log("WAYPOINT 3: " + Vector3.Distance(transform.position, waypoint3.position));
                currentTarget = waypoint2;
            }
                
            if ((Vector3.Distance(transform.position, waypoint2.position) < 0.5)) 
            {
                Debug.Log("WAYPOINT 2: " + Vector3.Distance(transform.position, waypoint2.position));
                currentTarget = waypoint1;
            }
            
            if ((Vector3.Distance(transform.position, waypoint1.position) < 0.5))
            {
                currentTarget = standTarget2;   
            }
            
            targetRotation = Quaternion.LookRotation(currentTarget.position - transform.position);
            transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, str);
            
            if ((Vector3.Distance(transform.position, standTarget2.position) < 0.2))
            {
                anim.SetBool("Walk",false);
                walkToShelf = true;
                walkFromShelf = false;
            }
        }
        
        //anim.SetBool("Walk",true);
        //transform.rotation = Quaternion.Lerp(transform.rotation, targetRotation, str);
    }
}

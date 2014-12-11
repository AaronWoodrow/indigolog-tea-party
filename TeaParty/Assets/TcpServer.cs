using UnityEngine;
using System.Collections;
using System;
using System.Text;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Threading;

public class TcpServer : MonoBehaviour {
	
	//GUIText output;
	//string theText;
	WriteToGUI writeToGUI;
	
	Queue instrs = new Queue();
	private System.Object thisLock = new System.Object();
	
	static TcpListener listener;
	IPAddress ip;
	Socket soc;
	private StreamWriter sw;
	
	private Thread t;
	bool shouldRun = false;
	
	bool readyForAction = true;
	
	// Use this for initialization
	void Start () {
		shouldRun = true;
		//output = GetComponent<WriteToGUI>().gUITextObject;
		//theText = GetComponent<WriteToGUI>().textToDisplay;
		writeToGUI = (WriteToGUI)GetComponent<WriteToGUI>();
		
		try{
			ip = Dns.GetHostEntry("localhost").AddressList[0];
			Debug.Log("IP is: " + ip);
			
			//output.text = output.text + "IP is: " + ip;
			GetComponent<WriteToGUI>().textToDisplay = GetComponent<WriteToGUI>().textToDisplay + "IP is: " + ip;
			
		} catch (Exception e){
			Debug.Log(e);
		}
		//ip = IPAddress.Any;
		
		listener = new TcpListener(ip, 9002); //2055
        listener.Start();
		Debug.Log("Server mounted, listening to port 9002"); //2055
		//output.text = output.text + "\n" + "Server mounted, listening to port 9002"; //2055
		GetComponent<WriteToGUI>().textToDisplay = GetComponent<WriteToGUI>().textToDisplay + "\nServer mounted, listening to port 9002"; //2055
		
		
		t = new Thread(new ThreadStart(Service));
        t.Start();
		
	}
	
	void OnApplicationQuit()
	{
		shouldRun = false;
		Thread.Sleep(100);
		t.Abort();
	}
	
	public void Service(){
		while(shouldRun){
			/*
			if (Input.GetKeyDown ("space")) 
			{
		        Debug.Log ("space key was pressed, stopped listening");
				writeToGUI.textToDisplay = writeToGUI.textToDisplay + "\nspace key was pressed, stopped listening";
				listener.Stop();
			}
			*/
			if (!listener.Pending()) {
	
			    //Debug.Log("Sorry, no connection requests have arrived");
			    	
			}
			else{
	
	        //Accept the pending client connection and return a TcpClient object initialized for communication.
				Debug.Log("Pending Connection...");
				writeToGUI.textToDisplay = writeToGUI.textToDisplay + "\nPending Connection...";
				soc = listener.AcceptSocket();
	            //soc.SetSocketOption(SocketOptionLevel.Socket,
	            //        SocketOptionName.ReceiveTimeout,10000);
	            Debug.Log("Connected: " + soc.RemoteEndPoint);
				writeToGUI.textToDisplay = writeToGUI.textToDisplay + "\nConnected: " + soc.RemoteEndPoint;
				//------------------------------------------------------------------
				 //string responseString = "You have successfully connected to me";	//UNCOMMENT AFTER WUMPUS TEST
		
	             //Forms and sends a response string to the connected client.
	             //Byte[] sendBytes = Encoding.ASCII.GetBytes(responseString);	//UNCOMMENT AFTER WUMPUS TEST
	             //int i = soc.Send(sendBytes);	//UNCOMMENT AFTER WUMPUS TEST
			
	            try{
	                Stream s = new NetworkStream(soc); 
	                StreamReader sr = new StreamReader(s);
	                sw = new StreamWriter(s);
	                sw.AutoFlush = true; // enable automatic flushing
	                sw.WriteLine("HELLO THIS IS THE UNITY3D SERVER!");
	                while(true){
	                    string reqFromClient = sr.ReadLine();
	                    Debug.Log("Client wrote: " + reqFromClient);
						writeToGUI.textToDisplay = writeToGUI.textToDisplay + "\nClient wrote: " + reqFromClient;
	                    //if(reqFromClient == "" || reqFromClient == null) break;
						if(reqFromClient == "end") break;	// NEW FOR WUMPUS
						
						lock(thisLock)
						{
							instrs.Enqueue(reqFromClient);	// NEW FOR WUMPUS
						}
						
	                    //sw.WriteLine(replyToClient);	//UNCOMMENT AFTER WUMPUS TEST
	                }
	                s.Close();
	            }catch(Exception e){
	                    Debug.Log(e.Message);
	            }
	            
	            Debug.Log("Disconnected: " + soc.RemoteEndPoint);
				writeToGUI.textToDisplay = writeToGUI.textToDisplay + "\nDisconnected: " + soc.RemoteEndPoint;
	
	            soc.Close();
			}
			
			Thread.Sleep(100);
		}
	}
	
	void doStuff(string instr)
	{
		/***** UNCOMMENT WHEN YOU SEE THAT INIDGOLOG CONNECTS AND THEN CHANGE WHAT'S HERE
	
		if(instr.IndexOf("robot")==0){
          		try{
		           	String stringx = instr.Substring(instr.IndexOf("(")+1,1).Trim(); //instr.IndexOf(",")
					Debug.Log(stringx);
           			String stringy = instr.Substring(instr.IndexOf(",")+1,2).Trim(); //instr.IndexOf(")")
					Debug.Log(instr);
					Debug.Log(stringy);
           			int x = int.Parse(stringx)-1;
					int y = int.Parse(stringy)-1;
					//go.transform.Translate(x, 0, y);
					go.transform.position = new Vector3(x, 0, y);

				}catch(Exception e){
					Debug.Log("Index: " + (instr.IndexOf("(")+1));
					Debug.Log("Parse error. TCP message '" + instr + "' ignored. " + e.Message);
				}
		}
		****/
		if(instr.IndexOf("set_curr")==0){
          		try{
		           	String stringx = instr.Substring(instr.IndexOf("(")+1, ((instr.IndexOf(")"))-(instr.IndexOf("(")+1))).Trim(); 
					Debug.Log(stringx);
					//GameObject.Find("ConversationBox").GetComponent<ConvoHistory>().setConvoText(("\n girl:\t" + stringx));
					GameObject.Find("girlText").GetComponent<GUIText>().text = "\n girl:\t" + stringx;

				}catch(Exception e){
					Debug.Log("Start Index: " + (instr.IndexOf("(")+1) + " End Index: " + instr.IndexOf(")") + " Length: " + instr.Length);
					Debug.Log("Parse error. TCP message '" + instr + "' ignored. " + e.Message);
				}
		}
		else if(instr.IndexOf("set_choice")==0){
          		try{
					String stringx = instr.Substring(instr.IndexOf("(")+1,1).Trim(); //Assuming the number is 1 digit.
		           	String stringy = instr.Substring(instr.IndexOf(",")+1,((instr.IndexOf(")"))-(instr.IndexOf(",")+1))).Trim();
					Debug.Log(stringx);
					//Debug.Log(instr);
					Debug.Log(stringy);
					MyTextSelection goScript = GameObject.Find ("MyText").GetComponent<MyTextSelection>();
					GUIText goText = GameObject.Find ("MyText").GetComponent<GUIText>();
					goScript.selection = true;
					if (goScript.numberOfChoices < int.Parse(stringx)){
						goText.text = goText.text + "\n" + stringx + ". " + stringy;
						goScript.numberOfChoices = int.Parse(stringx);
					}
					else {
						goScript.numberOfChoices = int.Parse(stringx);
						goText.text = stringx + ". " + stringy;
					}
           			//int x = int.Parse(stringx)-1;
					//int y = int.Parse(stringy)-1;
					//go.transform.Translate(x, 0, y);
					//go.transform.position = new Vector3(x, 0, y);

				}catch(Exception e){
					Debug.Log("Index: " + (instr.IndexOf("(")+1));
					Debug.Log("Parse error. TCP message '" + instr + "' ignored. " + e.Message);
				}
		}
		else if(instr.IndexOf("pickItem")==0){
          		try{
					String item = instr.Substring(instr.IndexOf("(")+1, ((instr.IndexOf(")"))-(instr.IndexOf("(")+1))).Trim();
		           //	String stringx = instr.Substring(instr.IndexOf("(")+1,1).Trim(); //instr.IndexOf(",")
					Debug.Log(item);
           			//String stringy = instr.Substring(instr.IndexOf(",")+1,2).Trim(); //instr.IndexOf(")")
					Debug.Log(instr);
					//Debug.Log(stringy);
           			//int x = int.Parse(stringx)-1;
					//int y = int.Parse(stringy)-1;
					//go.transform.Translate(x, 0, y);
					//go.transform.position = new Vector3(x, 0, y);
					readyForAction = false;
					StartCoroutine("pause");
					GameObject go;
					if (item == "cup1")	go = GameObject.Find("Cup1");
					else if (item == "cup2") go = GameObject.Find("Cup2");
					else if (item == "cup3") go = GameObject.Find("Cup3");
					else if (item == "cup4") go = GameObject.Find("Cup4");
					else if (item == "teapot") go = GameObject.Find("Teapot");
					else if (item == "milk") go = GameObject.Find("Milk");
					else go = GameObject.Find("Cup2");
				
					Move move = go.GetComponent<Move>();
					move.target = GameObject.Find("Lefthand");
					move.moving = true;
				
				/*
					Vector3 target = GameObject.Find("Lefthand").transform.position;
					GameObject.Find("node1").transform.position = go.transform.position;
					GameObject.Find("node2").transform.position = target;
					go.GetComponent<SplineController>().FollowSpline();
				*/
					//sw.WriteLine("explode");	// exog action TEST
				
				}catch(Exception e){
					Debug.Log("Index: " + (instr.IndexOf("(")+1));
					Debug.Log("Parse error. TCP message '" + instr + "' ignored. " + e.Message);
				}
		}
		else if(instr.IndexOf("dropItem")==0){
          		try{
					String item = instr.Substring(instr.IndexOf("(")+1, ((instr.IndexOf(")"))-(instr.IndexOf("(")+1))).Trim();
		           //	String stringx = instr.Substring(instr.IndexOf("(")+1,1).Trim(); //instr.IndexOf(",")
					//Debug.Log(stringx);
           			//String stringy = instr.Substring(instr.IndexOf(",")+1,2).Trim(); //instr.IndexOf(")")
					Debug.Log(instr);
					//Debug.Log(stringy);
           			//int x = int.Parse(stringx)-1;
					//int y = int.Parse(stringy)-1;
					//go.transform.Translate(x, 0, y);
					//go.transform.position = new Vector3(x, 0, y);
					readyForAction = false;
					StartCoroutine("pause");
					GameObject go;
					if (item == "cup1")	go = GameObject.Find("Cup1");
					else if (item == "cup2") go = GameObject.Find("Cup2");
					else if (item == "cup3") go = GameObject.Find("Cup3");
					else if (item == "cup4") go = GameObject.Find("Cup4");
					else if (item == "teapot") go = GameObject.Find("Teapot");
					else if (item == "milk") go = GameObject.Find("Milk");
					else go = GameObject.Find("Cup2");
				
					Move move = go.GetComponent<Move>();
					move.target = GameObject.Find(go.name + "Pos");
					move.moving = true;
				
				/*
					Vector3 target = GameObject.Find(go.name + "Pos").transform.position;
					GameObject.Find("node1").transform.position = go.transform.position;
					GameObject.Find("node2").transform.position = target;
					go.GetComponent<SplineController>().FollowSpline();
				*/
					//if (sw != null) sw.WriteLine("explode");	//exog action TEST
				
				}catch(Exception e){
					Debug.Log("Index: " + (instr.IndexOf("(")+1));
					Debug.Log("Parse error. TCP message '" + instr + "' ignored. " + e.Message);
				}
		}
	}
	
	IEnumerator pause()
	{
		Debug.Log(Time.time);
		yield return new WaitForSeconds(5);
		readyForAction = true;
		Debug.Log(Time.time);
	}
	
	// Update is called once per frame
	void Update () {
		
		if (readyForAction)
		{
			lock(thisLock)
			{
				if (instrs.Count > 0)
				{
					string instr = (string)instrs.Dequeue();
					doStuff(instr);
				}
			}
		}
		else
		{
			//StartCoroutine("pause");
		}
		
		if (Input.GetKeyDown(KeyCode.Alpha9) ){
			Debug.Log ("9 was clicked");
			if (sw != null) sw.WriteLine("explode(9)");
		} else if (Input.GetKeyDown(KeyCode.Alpha8) ){
			Debug.Log ("8 was clicked");
			if (sw != null) sw.WriteLine("explode(8)");
		} else if (Input.GetKeyDown(KeyCode.T) ){
			Debug.Log ("T was pressed, trying to take cup2");
			if (sw != null) sw.WriteLine("take(cup2)");
		} else if (Input.GetKeyDown(KeyCode.D) ){
			Debug.Log ("D was pressed, trying to drop cup2");
			if (sw != null) sw.WriteLine("drop(cup2)");
		} 
	}
	
	public StreamWriter getSW(){
		
		if (sw != null) return sw;
		else {
			return null;
		}
	}
}

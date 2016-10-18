using UnityEngine;
using System.Collections;

public class CoinController : MonoBehaviour {

    [Header("Platform")]
    public bool fixedToPlatorm;
    public GameObject platform;

    // Use this for initialization
    void Start () {
	    
	}
	
	// Update is called once per frame, used for rendering 
	void Update () {
	    
        

	}

    // Used for updating physics related logic
    void FixedUpdate() {

    }

    void OnCollisionEnter(Collision col) {

        if (col.gameObject.name == "Ninja") {
            gameObject.SetActive(false);
            Debug.Log("Coin collected!");
        }
    }
}

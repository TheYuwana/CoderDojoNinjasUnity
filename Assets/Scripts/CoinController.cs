using UnityEngine;
using System.Collections;

public class CoinController : MonoBehaviour {

    [Header("Platform")]
    public GameObject fixedPlatform;
    private bool _isFixed = false;

    // Use this for initialization
    void Start () {

        if (fixedPlatform != null) {
            _isFixed = true;
        }
	}
	
	// Update is called once per frame, used for rendering 
	void Update () {

        if (_isFixed) {
            transform.position = new Vector3(fixedPlatform.transform.position.x, fixedPlatform.transform.position.y + 0.5f, fixedPlatform.transform.position.z);
        }
        
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

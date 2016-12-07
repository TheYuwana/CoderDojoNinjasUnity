using UnityEngine;
using System.Collections;
using System;
using UnityEngine.EventSystems;

public class NinjaController : MonoBehaviour {

	private Animator _animator;
    private bool _isDead = false;
    private bool _respawn = false;
	private float _startJumpTime = 1f;
	private float _jumpTime = 0f;
	private bool _isJumping = false;
    private bool _isMoving = false;
	private float _moveSpeed = 4f;
	public float rotateSpeed = 100f;

    private GameObject[] _hearts;
    private int _totalLife;

    public GameObject spawnPoint;
    private Animation _spawnPointAnimation;

	private Rigidbody rb;

    public int score { get; set; }

	// Use this for initialization
	void Start () {
		_animator = GetComponent<Animator>();
		rb = GetComponent<Rigidbody>();
		_jumpTime = _startJumpTime;
        _spawnPointAnimation = spawnPoint.GetComponent<Animation>();
        _spawnPointAnimation.Play();
        _hearts = GameObject.FindGameObjectsWithTag("Heart");
        System.Array.Reverse(_hearts);
        _totalLife = _hearts.Length;
        score = 0;
    }

	// Update is called once per frame
	void Update () {


        if (_animator.GetCurrentAnimatorStateInfo(0).IsName("idle") && _respawn == true) {

            transform.position = spawnPoint.transform.position;
            _spawnPointAnimation.Play();
            _respawn = false;
            _isDead = false;
        }

        if (_isDead) {

            if (_animator.GetCurrentAnimatorStateInfo(0).IsName("fell")) {
                _respawn = true;
                _animator.SetBool("Die", false);
            }

        } else {

            // Constant variable updates
            _isMoving = false;

            if (_isJumping) {
                _jumpTime = _jumpTime - Time.deltaTime;

                if (_jumpTime > _startJumpTime - 0.25f) {
                    rb.AddForce(transform.up * 25f);
                }

                if (_jumpTime < 0) {
                    _isJumping = false;
                    _animator.SetBool("Jump", false);
                    _jumpTime = _startJumpTime;
                }
            }

            float rotateSpeedTmp;
            _animator.SetBool("Forward", false);
            _animator.SetBool("Backwards", false);

            //Ninja movement
            if (Input.GetKey(KeyCode.W)) {
                _isMoving = true;
                _animator.SetBool("Forward", true);
                transform.Translate(Vector3.forward * -_moveSpeed * Time.deltaTime);
            }

            if (Input.GetKey(KeyCode.S)) {
                _isMoving = true;
                _animator.SetBool("Backwards", true);
                transform.Translate(Vector3.forward * _moveSpeed * Time.deltaTime);
            }
            // Links
            if (Input.GetKey(KeyCode.A)) {
                if (_animator.GetBool("Backwards")) {
                    rotateSpeedTmp = rotateSpeed;
                } else {
                    rotateSpeedTmp = -rotateSpeed;
                }
                transform.Rotate(Vector3.up, rotateSpeedTmp * Time.deltaTime);
            }
            // Rechts
            if (Input.GetKey(KeyCode.D)) {
                if (_animator.GetBool("Backwards")) {
                    rotateSpeedTmp = -rotateSpeed;
                } else {
                    rotateSpeedTmp = rotateSpeed;
                }
                transform.Rotate(Vector3.up, rotateSpeedTmp * Time.deltaTime);
            }

            // Springen
            if (Input.GetKey(KeyCode.Space) && !_isJumping) {
                _animator.SetBool("Jump", true);
                _isJumping = true;
            }

        }        
	}

    
    void OnCollisionEnter(Collision col) {

        //Ninja COllision script
        if (col.gameObject.name == "Water") {
            _animator.Play("fell", 0);
            _animator.SetBool("Forward", false);
            _animator.SetBool("Jump", false);
            _animator.SetBool("Backwards", false);
            _animator.SetBool("Die", true);
            _isDead = true;
            _totalLife = _totalLife - 1;
            _hearts[_totalLife].SetActive(false);
        }

        if (col.gameObject.tag == "Coin") {

            EventManager.TriggerEvent("setScore");
        }
    }

    void OnCollisionStay(Collision col) {

        if (col.gameObject.tag == "Platform") {

            if (!_isMoving) {

                
                // TODO: Need to figure out how to make the player move with the platform
                transform.position = new Vector3(
                    col.gameObject.transform.position.x + (transform.position.x - col.gameObject.transform.position.x),
                    col.gameObject.transform.position.y + (col.gameObject.transform.localScale.y + 0.625f),
                    col.gameObject.transform.position.z + (transform.position.z - col.gameObject.transform.position.z));
            }   
        }
    }
}

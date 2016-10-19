using UnityEngine;
using System.Collections;

public class NinjaController : MonoBehaviour {

	private Animator _animator;
	private float _startJumpTime = 1f;
	private float _jumpTime = 0f;
	private bool _isJumping = false;
    private bool _isMoving = false;
	private float _moveSpeed = 4f;
	public float rotateSpeed = 100f;

	private Rigidbody rb;

	// Use this for initialization
	void Start () {
		_animator = GetComponent<Animator>();
		rb = GetComponent<Rigidbody>();
		_jumpTime = _startJumpTime;
	}

	// Update is called once per frame
	void Update () {

        // Constant variable updates
        _isMoving = false;

        if (_isJumping) {
			_jumpTime = _jumpTime - Time.deltaTime;

            if (_jumpTime > _startJumpTime-0.5f) {
                 rb.AddForce(transform.up * 15f);
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

		if (Input.GetKey(KeyCode.W)){
            _isMoving = true;
            _animator.SetBool("Forward", true);
			transform.Translate(Vector3.forward * -_moveSpeed * Time.deltaTime);
		}

		if (Input.GetKey(KeyCode.S)){
            _isMoving = true;
            _animator.SetBool("Backwards", true);
			transform.Translate(Vector3.forward * _moveSpeed * Time.deltaTime);
		}

		if (Input.GetKey(KeyCode.A)){
			if (_animator.GetBool ("Backwards")) {
				rotateSpeedTmp = rotateSpeed;
			} else {
				rotateSpeedTmp = -rotateSpeed;
			}
			transform.Rotate(Vector3.up, rotateSpeedTmp * Time.deltaTime);
		}

		if (Input.GetKey(KeyCode.D)){
			if (_animator.GetBool ("Backwards")) {
				rotateSpeedTmp = -rotateSpeed;
			} else {
				rotateSpeedTmp = rotateSpeed;
			}
			transform.Rotate(Vector3.up, rotateSpeedTmp * Time.deltaTime);
		}

		if (Input.GetKeyDown(KeyCode.Space) && !_isJumping) {
            _animator.SetBool("Jump", true);
			_isJumping = true;
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

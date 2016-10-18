using UnityEngine;
using System.Collections;

public class CharacterController : MonoBehaviour {

	private Animator _animator;
	private float _startJumpTime = 0.5f;
	private float _jumpTime = 0f;
	private bool _isJumping = false;
	private float _moveSpeed = 4f;
	public float rotateSpeed = 100f;

	public Rigidbody rb;

	// Use this for initialization
	void Start () {
		_animator = GetComponent<Animator>();
		rb = GetComponent<Rigidbody>();
		_jumpTime = _startJumpTime;
	}

	// Update is called once per frame
	void Update () {
		if (_isJumping) {
			_jumpTime = _jumpTime - Time.deltaTime;

			rb.AddForce(transform.up * 15f);

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
			_animator.SetBool("Forward", true);
			transform.Translate(Vector3.forward * -_moveSpeed * Time.deltaTime);
		}

		if (Input.GetKey(KeyCode.S)){
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
}

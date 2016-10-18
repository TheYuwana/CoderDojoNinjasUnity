using UnityEngine;
using System.Collections;

public class PlayerController : MonoBehaviour {

    private Animator _animator;
    private float _jumpTime = 0.5f;
    private bool _isJumping = false;
    private float _moveSpeed = 0.1f;

	// Use this for initialization
	void Start () {
        _animator = GetComponent<Animator>();
	}
	
	// Update is called once per frame
	void Update () {

        if (_isJumping) {
            _jumpTime = _jumpTime - Time.deltaTime;

            if (_jumpTime < 0) {
                _isJumping = false;
                _animator.SetBool("Jump", false);
                _jumpTime = 0.5f;
            }
        }

        _animator.SetBool("Forward", false);

        if (Input.GetKey(KeyCode.W)){
            _animator.SetBool("Forward", true);
            transform.Translate(Vector3.forward * -_moveSpeed);

        }

        if (Input.GetKeyDown(KeyCode.Space)) {
            _animator.SetBool("Jump", true);
            _isJumping = true;
        }
    }
}

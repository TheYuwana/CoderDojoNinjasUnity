using UnityEngine;

public class CycleAnimations : MonoBehaviour
{
    [SerializeField]
    private string[] _animationTriggers = new string[]
    {
		"idle",
        "run",
        "fell",
        "attack", 
		"hit",       
        "dodge left",
        "dodge right",
        "strafe left",
        "strafe right",
        "jump up",
        "jump right",
        "jump left",
		"special",
    };

    private int _currentIndex = 0;
    private Animator _animator;

    private void Awake()
    {
        _animator = GetComponent<Animator>();
    }
	
	private void OnGUI ()
	{
        var style = GUI.skin.label;
        style.fontSize = 40;
        GUILayout.BeginVertical();
        GUILayout.Space(40);
        GUILayout.BeginHorizontal();
		GUILayout.Space(40);
        GUILayout.Label(_animationTriggers[_currentIndex], style);
        GUILayout.EndHorizontal();
        GUILayout.EndVertical();
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            _currentIndex = (_currentIndex + 1) % _animationTriggers.Length;
            _animator.SetTrigger(_animationTriggers[_currentIndex]);
        }
    }
}

using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class CountdownTimer : MonoBehaviour {
	public float timeLeft = 300.0f;
	private Text timerText;
	private float startTime;

	private int minutes;
	private int seconds;

	void Start () {
		startTime = Time.time;
		timerText = GetComponent<Text> ();
	}
	
	// Update is called once per frame
	void Update () {
		if (timeLeft > 1) {
			timeLeft -= Time.deltaTime;

			minutes = ((int)timeLeft / 60);
			seconds = ((int)timeLeft % 60);

			timerText.text = string.Format ("{0:00}:{1:00}", minutes, seconds);
		} else {
			timerText.text = "Game over!";
		}
	}
}

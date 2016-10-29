using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.Events;
using System;

public class GameManager : MonoBehaviour {

    public GameObject ninja;
    private NinjaController _ninjaController;

    public GameObject score;
    private Text _scoreText;

    private GameObject[] _coins;
    private int _totalCoins;
    private int _collectedCoins;

    private UnityAction _scoreAction;

    void Awake() {
        _scoreAction = new UnityAction(setScore);
    }

	// Use this for initialization
	void Start () {
        _coins = GameObject.FindGameObjectsWithTag("Coin");
        _totalCoins = _coins.Length;

        _ninjaController = ninja.GetComponent<NinjaController>();
        _collectedCoins = _ninjaController.score;

        _scoreText = score.GetComponent<Text>();
        _scoreText.text = string.Format("{0:00} / {1:00}", _collectedCoins, _totalCoins);
    }
	
	// Update is called once per frame
	void Update () {
	
	}

    // Events
    void OnEnable() {
        EventManager.StartListening("setScore", _scoreAction);
    }

    void OnDisable() {
        EventManager.StopListening("setScore", _scoreAction);
    }
    

    void setScore() {
        _collectedCoins = _collectedCoins + 1;
        _scoreText.text = string.Format("{0:00} / {1:00}", _collectedCoins, _totalCoins);
    }
}

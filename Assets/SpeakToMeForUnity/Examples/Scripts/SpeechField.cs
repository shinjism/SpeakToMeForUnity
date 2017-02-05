using UnityEngine;
using UnityEngine.UI;

public class SpeechField : MonoBehaviour
{
	InputField speechField;

	void Start()
	{
		speechField = GetComponent<InputField>();
	}

	public void OnCallback(string message)
	{
		Debug.Log(message);

		speechField.text = message;
	}
}

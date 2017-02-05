using UnityEngine;
using UnityEngine.UI;

public class RecordButton : MonoBehaviour
{
	Button recordButton;
	Text recordButtonText;

	void Start()
	{
		SpeakToMeForUnity.PrepareRecording();

		recordButton = GetComponent<Button>();
		recordButtonText = transform.FindChild("Text").GetComponent<Text>();
	}

	public void OnCallback(string message) {
		Debug.Log(message);

		string[] data = message.Split(':');
		if (data.Length != 2)
			return;

		recordButton.interactable = (data[0] == "true");
		recordButtonText.text = data[1];
	}

	public void OnTapped()
	{
		SpeakToMeForUnity.RecordButtonTapped();
	}
}

using System.Runtime.InteropServices;

public class SpeakToMeForUnity
{
	#if UNITY_IOS && !UNITY_EDITOR
	[DllImport("__Internal")]
	private static extern void _prepareRecording();
	[DllImport("__Internal")]
	private static extern void _recordButtonTapped();
	#endif

	public static void PrepareRecording()
	{
		#if UNITY_IOS && !UNITY_EDITOR
		_prepareRecording();
		#endif
	}

	public static void RecordButtonTapped()
	{
		#if UNITY_IOS && !UNITY_EDITOR
		_recordButtonTapped();
		#endif
	}
}

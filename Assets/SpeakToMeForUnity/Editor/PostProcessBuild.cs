using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.IO;

namespace SpeakToMeForUnity
{
    public static class PostProcessBuild
	{
        [PostProcessBuild(100)]
        public static void OnPostProcessBuild(BuildTarget buildTarget, string buildPath)
		{
			if (buildTarget != BuildTarget.iOS) {
				return;
			}

			var project = new PBXProject();
            var projPath = PBXProject.GetPBXProjectPath(buildPath);

			project.ReadFromFile(projPath);

			var projName = "SpeakToMeForUnity";
			var targetGuid = project.TargetGuidByName(PBXProject.GetUnityTargetName());
			project.SetBuildProperty(targetGuid, "SWIFT_OBJC_INTERFACE_HEADER_NAME", string.Format("{0}-Swift.h", projName));
			project.SetBuildProperty(targetGuid, "SWIFT_OBJC_BRIDGING_HEADER", string.Format("$(SRCROOT)/Libraries/{0}/Plugins/iOS/UnitySwift-Bridging-Header.h", projName));
			project.AddBuildProperty(targetGuid, "LD_RUNPATH_SEARCH_PATHS", "@executable_path/Frameworks");

			project.WriteToFile(projPath);
			
			string plistPath = buildPath + "/Info.plist";
			PlistDocument plist = new PlistDocument();

			plist.ReadFromString(File.ReadAllText(plistPath));

			PlistElementDict rootDict = plist.root;
			rootDict.SetString("NSMicrophoneUsageDescription", "To listen your speech.");
			rootDict.SetString("NSSpeechRecognitionUsageDescription", "To recognize your speech.");

			File.WriteAllText(plistPath, plist.WriteToString());
		}
    }
}

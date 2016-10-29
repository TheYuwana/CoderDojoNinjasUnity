using UnityEditor;
using UnityEngine;

public class CaptureScreenShot
{
    [MenuItem("Tools/HAB/Capture ScreenShot")]
    private static void Capture()
    {
        Application.CaptureScreenshot("screenshot.png", 1);
    }
}

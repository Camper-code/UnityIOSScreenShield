using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

namespace CampStudio.UnityIOSScreenShield
{
    public class ScreenShield
    {
        /// <summary>
        /// Activate the screen shield. If user start screen recording, it will be blocked.
        /// </summary>
        public static void ActivateShield()
        {
            BlockScreenRecording();
        }

        #if UNITY_EDITOR
        private static void BlockScreenRecording() {
            Debug.Log("Screen recording is blocked on iOS device.");
        }
        #else
        [DllImport("__Internal")]
        private static extern void BlockScreenRecording();
        #endif
    }
}

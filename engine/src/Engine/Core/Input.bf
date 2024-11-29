using System;
using System.Collections;

namespace BeefMakerEngine
{
    public static class Input
    {
        private static Window window;

        private static Dictionary<KeyCode, KeyState> keyStates;

        public static void Initialize(Window window)
        {
            Input.window = window;

            keyStates = new Dictionary<KeyCode, KeyState>();
            for (var key in Enum.GetEnumerator(typeof(KeyCode)))
            {
                keyStates.Add((KeyCode)key.value, .None);
            }
        }

        public static bool GetKeyDown(KeyCode keyCode)
        {
            return keyStates[keyCode] == .Pressed;
        }

        public static bool GetKeyUp(KeyCode keyCode)
        {
            return keyStates[keyCode] == .Released;
        }

        public static bool GetKey(KeyCode keyCode)
        {
            return keyStates[keyCode] == .Held;
        }

        private static void SetKeyState(KeyCode keyCode, KeyState keyState)
        {
            keyStates[keyCode] = keyState;
        }

        private static KeyState GetKeyState(KeyCode keyCode)
        {
            KeyState keyState;
            if (!keyStates.TryGetValue(keyCode, out keyState))
            {
                keyState = .None;
                keyStates.Add(keyCode, .None);
            }
            return keyState;
        }
    }
}
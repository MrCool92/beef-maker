namespace BeefMakerEngine
{
    public static class SceneManager
    {
        public static Scene activeScene { get; private set; }

        private static Scene scene ~ delete _;

        public static void Initialize()
        {
            scene = new Scene();
            activeScene = scene;
        }
    }
}
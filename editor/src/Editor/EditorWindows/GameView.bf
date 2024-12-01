using BeefMakerEngine;

namespace BeefMakerEditor
{
    public class GameView : SceneView
    {
        private Box boxObject ~ delete _;

        public this()
        {
            name = "Game View";

            boxObject = new Box();
        }

        protected override void OnUpdate()
        {
            if (Input.GetKey(.W))
                boxObject.Move(.(0, 1, 0));

            if (Input.GetKey(.S))
                boxObject.Move(.(0, -1, 0));

            if (Input.GetKey(.A))
                boxObject.Move(.(-1, 0, 0));

            if (Input.GetKey(.D))
                boxObject.Move(.(1, 0, 0));

            if (Input.GetKey(.X))
                boxObject.Move(.(0, 0, 1));

            if (Input.GetKey(.Q))
                camera.Move(.(0, 0, 1));

            if (Input.GetKey(.E))
                camera.Move(.(0, 0, -1));

            if (Input.GetKey(.T))
                camera.Move(.(0, 1, 0));

            if (Input.GetKey(.G))
                camera.Move(.(0, -1, 0));

            if (Input.GetKey(.F))
                camera.Move(.(-1, 0, 0));

            if (Input.GetKey(.H))
                camera.Move(.(1, 0, 0));
        }

        protected override void OnRender()
        {
            GL.glClearColor(1f, 1f, 1f, 1f);
            GL.glClear(GL.GL_COLOR_BUFFER_BIT);
            boxObject.Render(camera);
        }
    }
}
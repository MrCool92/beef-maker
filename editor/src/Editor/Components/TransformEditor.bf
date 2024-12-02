namespace BeefMakerEngine
{
    extension Transform
    {
        public override void OnImGui()
        {
            float[3] newLocalPosition = this.localPosition;
            if (GUI.Vector3Field("Position", newLocalPosition, "%.2f"))
            {
                this.localPosition = newLocalPosition;
            }

            float[3] localEulerAngles = this.localEulerAngles;
            if (GUI.Vector3Field("Rotation", localEulerAngles, "%.2f"))
            {
                this.localEulerAngles = localEulerAngles;
            }

            float[3] localScale = this.localScale;
            if (GUI.Vector3Field("Scale", localScale, "%.2f"))
            {
                this.localScale = localScale;
            }
        }
    }
}

using System;
using System.Collections;

namespace BeefMakerEngine
{
    public static class PrimitiveObject
    {
        public static void Initialize()
        {
            Cube.[Friend]sharedMesh = Cube.Get();

            Sphere.[Friend]sharedMesh = Sphere.GenerateSphere(0.5f, 36, 18);
        }

        public static class Cube
        {
            private static float[] vertices = new .( //
                // Front face
                -0.5f, -0.5f,  0.5f, // Bottom-left
                0.5f, -0.5f,  0.5f, // Bottom-right
                0.5f,  0.5f,  0.5f, // Top-right
                -0.5f,  0.5f,  0.5f, // Top-left

                // Back face
                -0.5f, -0.5f, -0.5f, // Bottom-left
                0.5f, -0.5f, -0.5f, // Bottom-right
                0.5f,  0.5f, -0.5f, // Top-right
                -0.5f,  0.5f, -0.5f // Top-left
                );

            private static uint32[] indices = new .( //
                // Front face
                0, 1, 2, // First triangle
                2, 3, 0, // Second triangle

                // Back face
                4, 5, 6, // First triangle
                6, 7, 4, // Second triangle

                // Left face
                4, 0, 3, // First triangle
                3, 7, 4, // Second triangle

                // Right face
                1, 5, 6, // First triangle
                6, 2, 1, // Second triangle

                // Top face
                3, 2, 6, // First triangle
                6, 7, 3, // Second triangle

                // Bottom face
                4, 5, 1, // First triangle
                1, 0, 4 // Second triangle
                );

            private static Mesh sharedMesh ~ delete _;

            [Inline] public static Mesh Get() => new Mesh(vertices, indices);

            [Inline] public static Mesh GetShared() => sharedMesh;
        }

        public static class Sphere
        {
            private static Mesh sharedMesh ~ delete _;

            [Inline] public static Mesh GetShared() => sharedMesh;

            public static Mesh GenerateSphere(float radius, int sectorCount, int stackCount)
            {
                float[] vertices;
                uint32[] indices;
                GenerateSphere(radius, sectorCount, stackCount, out vertices, out indices);
                return new Mesh(vertices, indices);
            }

            public static void GenerateSphere(float radius, int sectorCount, int stackCount, out float[] vertices, out uint32[] indices)
            {
                var vertexList = scope List<float>();
                var indexList = scope List<uint32>();

                float x, y, z, xy;
                float sectorStep = 2 * Math.PI_f / sectorCount;
                float stackStep = Math.PI_f / stackCount;
                float sectorAngle, stackAngle;

                for (int i = 0; i <= stackCount; ++i)
                {
                    stackAngle = (float)Math.PI_f / 2 - i * stackStep;
                    xy = radius * Math.Cos(stackAngle);
                    z = radius * Math.Sin(stackAngle);

                    for (int j = 0; j <= sectorCount; ++j)
                    {
                        sectorAngle = j * sectorStep;

                        x = xy * Math.Cos(sectorAngle);
                        y = xy * Math.Sin(sectorAngle);
                        vertexList.Add(x);
                        vertexList.Add(y);
                        vertexList.Add(z);
                    }
                }

                for (int i = 0; i < stackCount; ++i)
                {
                    uint32 k1 = (uint32)(i * (sectorCount + 1));
                    uint32 k2 = (uint32)(k1 + sectorCount + 1);

                    for (int j = 0; j < sectorCount; ++j,++k1,++k2)
                    {
                        if (i != 0)
                        {
                            indexList.Add(k1);
                            indexList.Add(k2);
                            indexList.Add(k1 + 1);
                        }

                        if (i != (stackCount - 1))
                        {
                            indexList.Add(k1 + 1);
                            indexList.Add(k2);
                            indexList.Add(k2 + 1);
                        }
                    }
                }

                vertices = new float[vertexList.Count];
                vertexList.CopyTo(vertices);

                indices = new uint32[indexList.Count];
                indexList.CopyTo(indices);
            }
        }
    }
}

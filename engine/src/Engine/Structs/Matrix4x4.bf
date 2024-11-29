using System;

namespace BeefMakerEngine
{
    public struct Matrix4x4
    {
        public static readonly Matrix4x4 zero = .(
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
            );

        public static readonly Matrix4x4 identity = .(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
            );

        public float[16] m;

        public float m00
        {
            [Inline] get
            {
                return m[0];
            }
            [Inline] set mut
            {
                m[0] = value;
            }
        }

        public float m01
        {
            [Inline] get
            {
                return m[1];
            }
            [Inline] set mut
            {
                m[1] = value;
            }
        }

        public float m02
        {
            [Inline] get
            {
                return m[2];
            }
            [Inline] set mut
            {
                m[2] = value;
            }
        }

        public float m03
        {
            [Inline] get
            {
                return m[3];
            }
            [Inline] set mut
            {
                m[3] = value;
            }
        }

        public float m10
        {
            [Inline] get
            {
                return m[4];
            }
            [Inline] set mut
            {
                m[4] = value;
            }
        }

        public float m11
        {
            [Inline] get
            {
                return m[5];
            }
            [Inline] set mut
            {
                m[5] = value;
            }
        }

        public float m12
        {
            [Inline] get
            {
                return m[6];
            }
            [Inline] set mut
            {
                m[6] = value;
            }
        }

        public float m13
        {
            [Inline] get
            {
                return m[7];
            }
            [Inline] set mut
            {
                m[7] = value;
            }
        }

        public float m20
        {
            [Inline] get
            {
                return m[8];
            }
            [Inline] set mut
            {
                m[8] = value;
            }
        }

        public float m21
        {
            [Inline] get
            {
                return m[9];
            }
            [Inline] set mut
            {
                m[9] = value;
            }
        }

        public float m22
        {
            [Inline] get
            {
                return m[10];
            }
            [Inline] set mut
            {
                m[10] = value;
            }
        }

        public float m23
        {
            [Inline] get
            {
                return m[11];
            }
            [Inline] set mut
            {
                m[11] = value;
            }
        }

        public float m30
        {
            [Inline] get
            {
                return m[12];
            }
            [Inline] set mut
            {
                m[12] = value;
            }
        }

        public float m31
        {
            [Inline] get
            {
                return m[13];
            }
            [Inline] set mut
            {
                m[13] = value;
            }
        }

        public float m32
        {
            [Inline] get
            {
                return m[14];
            }
            [Inline] set mut
            {
                m[14] = value;
            }
        }

        public float m33
        {
            [Inline] get
            {
                return m[15];
            }
            [Inline] set mut
            {
                m[15] = value;
            }
        }

        public this(Vector4 column0, Vector4 column1, Vector4 column2, Vector4 column3)
        {
            m = .(
                column0.x, column1.x, column2.x, column3.x,
                column0.y, column1.y, column2.y, column3.y,
                column0.z, column1.z, column2.z, column3.z,
                column0.w, column1.w, column2.w, column3.w
                );
        }

        public this(
            float m00, float m01, float m02, float m03,
            float m10, float m11, float m12, float m13,
            float m20, float m21, float m22, float m23,
            float m30, float m31, float m32, float m33)
        {
            m = .(
                m00, m01, m02, m03,
                m10, m11, m12, m13,
                m20, m21, m22, m23,
                m30, m31, m32, m33
                );
        }

        public Vector3 GetTranslation()
        {
            return .(m30, m31, m32);
        }

        public void SetTranslation(Vector3 translation) mut
        {
            m30 = translation.x;
            m31 = translation.y;
            m32 = translation.z;
        }

        public static Matrix4x4 LookAt(Vector3 position, Vector3 target, Vector3 up)
        {
            Vector3 forward = (target - position).normalized;
            Vector3 right = Vector3.Cross(up, forward).normalized;
            Vector3 newUp = Vector3.Cross(forward, right);

            Matrix4x4 result = default;
            result.m00 = right.x;
            result.m01 = newUp.x;
            result.m02 = forward.x;
            result.m03 = 0f;
            result.m10 = right.y;
            result.m11 = newUp.y;
            result.m12 = forward.y;
            result.m13 = 0f;
            result.m20 = right.z;
            result.m21 = newUp.z;
            result.m22 = forward.z;
            result.m23 = 0f;
            result.m30 = -Vector3.Dot(right, position);
            result.m31 = -Vector3.Dot(newUp, position);
            result.m32 = -Vector3.Dot(forward, position);
            result.m33 = 1f;
            return result;
        }

        public static Matrix4x4 Perspective(float fovY, float aspect, float near, float far)
        {
            System.Diagnostics.Debug.Assert(fovY > 0, "Fov must be larger then zero!");
            System.Diagnostics.Debug.Assert(near > 0, "Near should be larger then zero!");
            System.Diagnostics.Debug.Assert(far > 0, "Far should be larger then zero!");
            System.Diagnostics.Debug.Assert(near < far, "Near should be less then far!");

            float tanHalfFovy = System.Math.Tan(fovY / 2.0f);

            Matrix4x4 result = default;

            result.m00 = 1 / (aspect * tanHalfFovy);
            result.m01 = result.m02 = result.m03 = 0;

            result.m11 = 1 / tanHalfFovy;
            result.m10 = result.m12 = result.m13 = 0;

            result.m20 = result.m21 = 0;
            result.m22 = -(far + near) / (far - near);
            result.m23 = 1;

            result.m30 = result.m31 = result.m33 = 0;
            result.m32 = (2 * far * near) / (far - near);

            return result;
        }

        public override void ToString(String strBuffer)
        {
            strBuffer.AppendF("Matrix4x4\r\n{},{},{},{}\r\n{},{},{},{}\r\n{},{},{},{}\r\n{},{},{},{}", m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15]);
        }

        public static operator float*(ref Matrix4x4 matrix) => &matrix.m[0];
    }
}
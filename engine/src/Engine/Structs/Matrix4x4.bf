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

        public Quaternion GetRotation()
        {
            Vector3 right   = new Vector3(m00, m10, m20).normalized;
            Vector3 up      = new Vector3(m01, m11, m21).normalized;
            Vector3 forward = new Vector3(m02, m12, m22).normalized;

            Matrix4x4 rotationMatrix = .(
                right.x, up.x, forward.x, 0,
                right.y, up.y, forward.y, 0,
                right.z, up.z, forward.z, 0,
                0, 0, 0, 1
                );

            return Quaternion.FromMatrix(rotationMatrix);
        }

        public void SetRotation(Quaternion rotation) mut
        {
            float xx = rotation.x * rotation.x;
            float yy = rotation.y * rotation.y;
            float zz = rotation.z * rotation.z;
            float xy = rotation.x * rotation.y;
            float xz = rotation.x * rotation.z;
            float yz = rotation.y * rotation.z;
            float wx = rotation.w * rotation.x;
            float wy = rotation.w * rotation.y;
            float wz = rotation.w * rotation.z;

            m00 = 1 - 2 * (yy + zz);
            m01 = 2 * (xy - wz);
            m02 = 2 * (xz + wy);

            m10 = 2 * (xy + wz);
            m11 = 1 - 2 * (xx + zz);
            m12 = 2 * (yz - wx);

            m20 = 2 * (xz - wy);
            m21 = 2 * (yz + wx);
            m22 = 1 - 2 * (xx + yy);
        }

        public Vector3 GetScale()
        {
            float scaleX = Math.Sqrt(m00 * m00 + m01 * m01 + m02 * m02);
            float scaleY = Math.Sqrt(m10 * m10 + m11 * m11 + m12 * m12);
            float scaleZ = Math.Sqrt(m20 * m20 + m21 * m21 + m22 * m22);

            return .(scaleX, scaleY, scaleZ);
        }

        public void SetScale(Vector3 scale) mut
        {
            Vector3 column0 = .(m00, m01, m02).normalized;
            Vector3 column1 = .(m10, m11, m12).normalized;
            Vector3 column2 = .(m20, m21, m22).normalized;

            // Apply the new scale
            column0 *= scale.x;
            column1 *= scale.y;
            column2 *= scale.z;

            // Set the new basis vectors back to the matrix
            m00 = column0.x; m01 = column0.y; m02 = column0.z;
            m10 = column1.x; m11 = column1.y; m12 = column1.z;
            m20 = column2.x; m21 = column2.y; m22 = column2.z;
        }

        public static Matrix4x4 LookAt(Vector3 position, Vector3 target, Vector3 up)
        {
            Vector3 forward = (target - position).normalized;
            Vector3 right = Vector3.Cross(up, forward).normalized;
            Vector3 newUp = Vector3.Cross(forward, right);

            Matrix4x4 m = default;
            m.m00 = right.x;
            m.m01 = newUp.x;
            m.m02 = forward.x;
            m.m03 = 0f;
            m.m10 = right.y;
            m.m11 = newUp.y;
            m.m12 = forward.y;
            m.m13 = 0f;
            m.m20 = right.z;
            m.m21 = newUp.z;
            m.m22 = forward.z;
            m.m23 = 0f;
            m.m30 = -Vector3.Dot(right, position);
            m.m31 = -Vector3.Dot(newUp, position);
            m.m32 = -Vector3.Dot(forward, position);
            m.m33 = 1f;
            return m;
        }

        public static Matrix4x4 Perspective(float fovY, float aspect, float near, float far)
        {
            System.Diagnostics.Debug.Assert(fovY > 0, "Fov must be larger then zero!");
            System.Diagnostics.Debug.Assert(near > 0, "Near should be larger then zero!");
            System.Diagnostics.Debug.Assert(far > 0, "Far should be larger then zero!");
            System.Diagnostics.Debug.Assert(near < far, "Near should be less then far!");

            float tanHalfFovy = System.Math.Tan(fovY / 2.0f);

            Matrix4x4 m = default;

            m.m00 = 1 / (aspect * tanHalfFovy);
            m.m01 = m.m02 = m.m03 = 0;

            m.m11 = 1 / tanHalfFovy;
            m.m10 = m.m12 = m.m13 = 0;

            m.m20 = m.m21 = 0;
            m.m22 = -(far + near) / (far - near);
            m.m23 = 1;

            m.m30 = m.m31 = m.m33 = 0;
            m.m32 = (2 * far * near) / (far - near);

            return m;
        }

        public override void ToString(String strBuffer)
        {
            strBuffer.AppendF("Matrix4x4\r\n{},{},{},{}\r\n{},{},{},{}\r\n{},{},{},{}\r\n{},{},{},{}", m[0], m[1], m[2], m[3], m[4], m[5], m[6], m[7], m[8], m[9], m[10], m[11], m[12], m[13], m[14], m[15]);
        }

        public static operator float*(ref Matrix4x4 matrix) => &matrix.m[0];

        public static Matrix4x4 TRS(Vector3 position, Quaternion rotation, Vector3 scale)
        {
            Matrix4x4 m = rotation.ToMatrix4x4();

            m.m00 *= scale.x;
            m.m01 *= scale.x;
            m.m02 *= scale.x;

            m.m10 *= scale.y;
            m.m11 *= scale.y;
            m.m12 *= scale.y;

            m.m20 *= scale.z;
            m.m21 *= scale.z;
            m.m22 *= scale.z;

            m.m30 = position.x;
            m.m31 = position.y;
            m.m32 = position.z;

            return m;
        }
    }
}
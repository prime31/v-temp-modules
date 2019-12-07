using System;
using System.Collections.Generic;

namespace Generator
{
    public static class Statics
    {
        public static Dictionary<string, string> CTypeToVType = new Dictionary<string, string>
        {
            {"GLbyte", "i8"},
            {"GLchar", "i8"},
            {"GLshort", "i16"},
            {"GLint", "int"},
            {"GLubyte", "byte"},
            {"GLushort", "u16"},
            {"GLuint", "u32"},
            {"GLfloat", "f32"},
            {"GLdouble", "f64"},
            {"GLenum", "u32"},
            {"GLsizei", "int"},
            {"GLbitfield", "u32"},
            {"GLboolean", "bool"},
            {"GLsync", "voidptr"},
            {"GLbyte*", "[]i8"},
            {"GLshort*", "[]i16"},
            {"GLint*", "[]int"},
            {"GLintptr", "[]int"},
            {"GLubyte*", "[]byte"},
            {"GLushort*", "[]u16"},
            {"GLuint*", "[]u32"},
            {"GLfloat*", "[]f32"},
            {"GLdouble*", "[]f64"},
            {"GLenum*", "[]u32"},
            {"GLsizei*", "[]int"},
            {"GLsizeiptr", "[]int"},
            {"GLboolean*", "[]bool"},
            {"GLchar*", "string"},
            {"GLchar**", "voidptr"},
            {"void*", "voidptr"},
            {"void**", "*voidptr"},
            {"GLDEBUGPROC", "voidptr"},
            {"ptr", "voidptr"},
            {"GLintptr*", "*voidptr"},
            {"GLsizeiptr*", "*voidptr"},
            {"GLint64", "i64"},
            {"GLuint64", "u64"},
            {"GLint64*", "[]i64"},
            {"GLuint64*", "[]u64"}
        };

        public static string GetVTypeForCType(string cType, bool isReturn)
        {
            var suffix = isReturn ? $" // {cType}" : "";

            // first, get direct matches out of the way
            if (CTypeToVType.ContainsKey(cType))
                return CTypeToVType[cType] + suffix;

            // change pointers to V style
            // if (cType.EndsWith("*"))
            //     return "&" + GetVTypeForCType(cType.Substring(0, cType.Length - 1));

            Console.WriteLine($"No V for {cType}");

            return null;
        }
    }
}
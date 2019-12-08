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
            {"GLenum", "int"},
            {"GLsizei", "int"},
            {"GLbitfield", "u32"},
            {"GLboolean", "bool"},
            {"GLsync", "voidptr"},
            {"GLbyte*", "&i8"},
            {"GLshort*", "&i16"},
            {"GLint*", "&int"},
            {"GLintptr", "int"},
            {"GLubyte*", "byteptr"},
            {"GLushort*", "&u16"},
            {"GLuint*", "&u32"},
            {"GLfloat*", "&f32"},
            {"GLdouble*", "&f64"},
            {"GLenum*", "&int"},
            {"GLsizei*", "&int"},
            {"GLsizeiptr", "int"},
            {"GLboolean*", "&bool"},
            {"GLchar*", "byteptr"},
            {"GLchar**", "voidptr"},
            {"void*", "voidptr"},
            {"void**", "&voidptr"},
            {"GLDEBUGPROC", "voidptr"},
            {"ptr", "voidptr"},
            {"GLintptr*", "&GLintptr"},
            {"GLsizeiptr*", "voidptr"},
            {"GLint64", "i64"},
            {"GLuint64", "u64"},
            {"GLint64*", "&i64"},
            {"GLuint64*", "&u64"}
        };

        public static Dictionary<string, string> CTypeToVWrapperType = new Dictionary<string, string>
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
            {"GLenum", "int"},
            {"GLsizei", "int"},
            {"GLbitfield", "u32"},
            {"GLboolean", "bool"},
            {"GLsync", "voidptr"},
            {"GLbyte*", "[]i8"},
            {"GLshort*", "[]i16"},
            {"GLint*", "[]int"},
            {"GLintptr", "int"},
            {"GLubyte*", "voidptr"},
            {"GLushort*", "[]u16"},
            {"GLuint*", "[]u32"},
            {"GLfloat*", "[]f32"},
            {"GLdouble*", "[]f64"},
            {"GLenum*", "[]int"},
            {"GLsizei*", "[]int"},
            {"GLsizeiptr", "int"},
            {"GLboolean*", "[]bool"},
            {"GLchar*", "string"},
            {"GLchar**", "voidptr"},
            {"void*", "voidptr"},
            {"void**", "&voidptr"},
            {"GLDEBUGPROC", "voidptr"},
            {"ptr", "voidptr"},
            {"GLintptr*", "&int"},
            {"GLsizeiptr*", "&voidptr"},
            {"GLint64", "i64"},
            {"GLuint64", "u64"},
            {"GLint64*", "[]i64"},
            {"GLuint64*", "[]u64"}
        };

        public static string GetVTypeForCType(string cType, bool isReturn, bool isVWrapper = false)
        {
            // document the GLType for returns if this isnt the V wrapper method
            var suffix = "";
            if (isReturn)
            {
                if (isVWrapper)
                    suffix = $" {cType}";
                else
                    suffix = $" // {cType}";
            }

            if (isVWrapper && CTypeToVWrapperType.TryGetValue(cType, out var vWrapperType))
                return vWrapperType;

            // first, get direct matches out of the way
            if (CTypeToVType.ContainsKey(cType))
                return CTypeToVType[cType] + suffix;

            Console.WriteLine($"No V for {cType}");

            return "voidptr";
        }
    }
}
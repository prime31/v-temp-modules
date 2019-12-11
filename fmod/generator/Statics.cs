using System;
using System.Collections.Generic;

namespace Generator
{
    public static class Statics
    {
        public static Dictionary<string, string> CTypeToVWrapperType = new Dictionary<string, string>
        {
            {"FMOD_BOOL", "int"},
            {"void*", "voidptr"},
            {"void**", "voidptr"},
            {"int", "int"},
            {"long", "i64"},
            {"float", "f32"},
            {"char", "byte"},
            {"unsignedint", "u32"},
            {"unsignedlong", "u64"},
            {"unsignedlonglong", "u64"}
        };

        public static string GetVTypeForCType(string cType)
        {
            if (CTypeToVWrapperType.ContainsKey(cType))
                return CTypeToVWrapperType[cType];

            if (cType.StartsWith("FMOD") || cType.StartsWith("fn(") || cType.StartsWith("C."))
                return "int";

            Console.WriteLine($"No V for {cType}");

            return "UNKNOWN_TYPE";
        }
    }
}
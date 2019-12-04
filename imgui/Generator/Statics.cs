using System.Collections.Generic;

namespace Generator
{
    public static class Statics
    {
        public static Dictionary<string, string> CTypeToVType = new Dictionary<string, string>
        {
            {"float", "f32"},
            {"ImU32", "int"},
            {"const ImVec4", "ImVec4"},
            {"void*", "voidptr"},
            {"float", "f32"},
            {"float", "f32"},
            {"const char*", "byteptr"},
            {"unsigned int", "int"},
            {"size_t", "u32"},
            {"char", "byte"}
        };

        public static string GetVTypeForCType(string cType)
        {
            // first, get direct matches out of the way
            if (CTypeToVType.ContainsKey(cType))
                return CTypeToVType[cType];

            // strip const
            if (cType.Contains("const "))
                cType = cType.Replace("const ", "");

            // check again for a direct match
            if (CTypeToVType.ContainsKey(cType))
                return CTypeToVType[cType];

            // change pointers to V style
            if (cType.EndsWith("*"))
                return "&" + GetVTypeForCType(cType.Substring(0, cType.Length - 1));
            
            if (cType.Contains("["))
            {
                var t = cType.Substring(0, cType.IndexOf("["));
                var num = cType.Substring(cType.IndexOf("["), 1);
                return $"[{num}]{t}";
            }
            
            return null;
        }
    }
}
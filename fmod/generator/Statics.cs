using System;
using System.Collections.Generic;
using System.Linq;

namespace Generator
{
    public static class Statics
    {
        static string[] Structs = new string[] {
            "FMOD_SYSTEM",
            "FMOD_SOUND",
            "FMOD_CHANNELCONTROL",
            "FMOD_CHANNEL",
            "FMOD_CHANNELGROUP",
            "FMOD_SOUNDGROUP",
            "FMOD_REVERB3D",
            "FMOD_DSP",
            "FMOD_DSPCONNECTION",
            "FMOD_POLYGON",
            "FMOD_GEOMETRY",
            "FMOD_SYNCPOINT",
            "FMOD_ASYNCREADINFO",

            "FMOD_CREATESOUNDEXINFO",

            "FMOD_STUDIO_SYSTEM",
            "FMOD_STUDIO_EVENTDESCRIPTION",
            "FMOD_STUDIO_EVENTINSTANCE",
            "FMOD_STUDIO_BUS",
            "FMOD_STUDIO_VCA",
            "FMOD_STUDIO_BANK",
            "FMOD_STUDIO_COMMANDREPLAY"
        };

        static Dictionary<string, string> CTypeToVWrapperType = new Dictionary<string, string>
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
            {"unsignedlonglong", "u64"},
            {"const char *", "byteptr"}
        };

        public static string GetVTypeForCType(string cType)
        {
            if (CTypeToVWrapperType.ContainsKey(cType))
                return CTypeToVWrapperType[cType];

            if (cType.Contains("_CALLBACK"))
                return cType;

            if (Structs.Contains(cType))
                return cType;
            
            if (cType.Contains("**"))
                return "voidptr";

            // TODO: we should filter for FMOD enums here because #defines can be unsigned
            if (cType.StartsWith("FMOD") || cType.StartsWith("C."))
                return "int";

            Console.WriteLine($"No V for {cType}");

            return "UNKNOWN_TYPE";
        }
    }
}
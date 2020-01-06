using CppAst;

namespace Generator
{
    public static class CppTypedefExt
    {
		public static bool IsPrimitiveType(this CppTypedef typedef)
            => typedef.ElementType.TypeKind == CppTypeKind.Primitive;

        public static CppPrimitiveType ElementTypeAsPrimitive(this CppTypedef typedef)
            => typedef.ElementType as CppPrimitiveType;
	}
}
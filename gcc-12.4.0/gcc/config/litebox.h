/* Useful if you wish to make target-specific GCC changes. */
#undef TARGET_LITEBOX
#define TARGET_LITEBOX 1

/* Default arguments you want when running your
   x86_64-litebox-gcc toolchain */
#undef LIB_SPEC
#define LIB_SPEC "%{!shared:-lc}" /* link against C standard library */

/* Files that are linked before user code.
   The %s tells GCC to look for these files in the library directory. */
#undef STARTFILE_SPEC
#define STARTFILE_SPEC "%{!shared:crt0.o%s} %{!shared:crti.o%s} %{!shared:crtbegin.o%s}"

/* Files that are linked after user code. */
#undef ENDFILE_SPEC
#define ENDFILE_SPEC "%{!shared:crtend.o%s} %{!shared:crtn.o%s}"

#undef LINK_SPEC
#define LINK_SPEC "%{shared:-shared} %{static:-static} %{!shared: %{!static: %{rdynamic:-export-dynamic}}}"

/* Additional predefined macros. */
#undef TARGET_OS_CPP_BUILTINS
#define TARGET_OS_CPP_BUILTINS()      \
  do {                                \
    builtin_define ("__litebox__");      \
    builtin_define ("__unix__");      \
    builtin_assert ("system=litebox");   \
    builtin_assert ("system=unix");   \
    builtin_assert ("system=posix");   \
  } while(0);

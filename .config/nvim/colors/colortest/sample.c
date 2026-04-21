/*
 * C test file — exercises preprocessor, labels, function-macros, typedefs.
 * See README.md in this directory.
 */

// ─── Preprocessor directives (@keyword.directive, @keyword.directive.define) ─
#include <stdio.h>                       // @keyword.directive / Include
#include <stdlib.h>                      // same
#include "local.h"                       // @string (in quotes)

#define MAX_SIZE 100                     // @keyword.directive.define / @constant.macro / Define
#define SQUARE(x) ((x) * (x))            // @function.macro / Macro
#define MIN(a, b) ((a) < (b) ? (a) : (b))   // @function.macro

#ifdef DEBUG                             // @keyword.directive / PreCondit
  #define LOG(msg) printf("%s\n", msg)
#else
  #define LOG(msg)
#endif                                   // @keyword.directive

#if defined(__linux__)                   // PreCondit
  #warning "Linux build"
#elif defined(__APPLE__)
  #pragma message "macOS build"
#endif

// ─── Typedefs and structures (@type.definition / Typedef / Structure) ───────
typedef unsigned long ULONG;             // @keyword.type / Typedef
typedef const char *CStr;

typedef struct Point {                   // @keyword.type / Structure
    int x;                               // @variable.member
    int y;                               // @variable.member
    struct Point *next;
} Point;                                 // @type.definition

typedef enum Color {                     // @keyword.type
    RED = 0,
    GREEN = 1,
    BLUE = 2,
} Color;

typedef union Data {
    int   i;
    float f;
    char  s[16];
} Data;

// ─── Storage class / modifiers (@keyword.modifier / StorageClass) ───────────
static const int GLOBAL_CONST = 42;     // static / const → @keyword.modifier
extern int external_var;                 // extern → @keyword.modifier
static volatile int flag = 0;            // volatile → @keyword.modifier

// ─── Function prototypes and definitions ────────────────────────────────────
static int compute(int a, int b);        // @function / @variable.parameter

int add(int x, int y) {                  // @function
    return x + y;                        // @keyword.return
}

// ─── Main: labels and goto ──────────────────────────────────────────────────
int main(int argc, char *argv[]) {       // @variable.parameter / @type / @type.builtin
    int i = 0;

    // goto + labels (@keyword (goto) + @label)
    if (argc < 2) goto end;              // goto → @keyword

    for (i = 0; i < 10; i++) {           // for → @keyword.repeat
        if (i == 5) goto cleanup;
        printf("%d\n", SQUARE(i));       // printf → @function.call ; SQUARE → @function.macro
    }

cleanup:                                  // @label
    printf("cleaning up\n");
    goto end;

end:                                      // @label
    return 0;                             // @number / Number
}

// ─── Preprocessor-heavy macros ──────────────────────────────────────────────
#define CONCAT(a, b) a##b                // @function.macro with ## (token paste)
#define STRINGIFY(x) #x                  // @function.macro with # (stringify)
#define ARRAY_SIZE(a) (sizeof(a) / sizeof((a)[0]))

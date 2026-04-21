"""
Python test file for colorscheme verification. See README.md for full usage.
Annotations use `# @group.name` form on the line that triggers the capture.
"""

# ─── Comments ────────────────────────────────────────────────────────────────
# regular comment                                @comment
"""triple-quoted docstring                       @string.documentation"""
# TODO: implement                                @comment.todo / ExtraTodo
# FIXME: broken                                  ExtraTodo
# NOTE: informational                            @comment.note / ExtraTodo
# HACK: workaround                               ExtraTodo
# XXX: suspicious                                ExtraTodo
# OPTIMIZE: slow                                 ExtraTodo
# WARNING: careful                               @comment.warning
# ERROR: something is wrong                      @comment.error

# ─── Imports / modules ───────────────────────────────────────────────────────
import os                                      # @keyword.import / @module
from typing import Optional, List, Final       # @keyword.import / @type

# ─── Numbers, strings, characters ────────────────────────────────────────────
count = 42                                     # @number / Number
hex_val = 0xFF                                 # @number
binary = 0b1010                                # @number
ratio = 3.14                                   # @number.float / Float
message = "hello"                              # @string / String
char = 'x'                                     # @character / Character
raw_string = r"\d+"                            # @string
escaped = "line1\nline2\tend"                  # @string + @string.escape
fstring = f"value {count:03d}"                 # @string with interpolation

# ─── Constants and booleans ─────────────────────────────────────────────────
CONSTANT = 42                                  # @constant / Constant
PI = 3.14159                                   # @constant
NAME: Final = "Alice"                          # @constant + @lsp.mod.readonly (LSP)
flag_true = True                               # @constant.builtin / @boolean / Boolean
flag_false = False                             # @constant.builtin
none_val = None                                # @constant.builtin

# ─── Decorators (attributes) ────────────────────────────────────────────────
@staticmethod                                  # @attribute
@classmethod                                   # @attribute
def _marker():
    pass

# ─── Classes, constructors, fields ──────────────────────────────────────────
class MyClass:                                 # @type + @constructor (definition)
    """Class docstring."""                     # @string.documentation

    class_field: int = 0                       # @variable.member / @property
    _private: str = ""                         # @variable.member

    def __init__(self, value: int) -> None:    # @function.method (definition)
        self.instance_field = value            # self → @variable.builtin ; self.X → @variable.member
        self.name: str = "default"

    def method(self, x: int) -> int:           # @function.method (definition)
        """Method docstring."""
        return self.class_field + x

    @property
    def computed(self) -> int:                 # @function.method
        return self._private

    @classmethod
    def factory(cls) -> "MyClass":             # @function.method
        return cls(0)                          # cls → @variable.builtin ; cls(…) → @function.call


instance = MyClass(42)                         # MyClass(…) → @constructor call
instance.method(7)                             # .method → @function.method.call
x = instance.class_field                       # .class_field → @property

# ─── Functions: definitions vs calls ────────────────────────────────────────
def my_function(arg: int, *args, **kwargs) -> str:   # @function (definition)
    """Docstring."""
    return str(arg)                            # str → @type.builtin / @function.builtin

def compute(x: int, y: int) -> int:            # @function (definition)
    result = x + y                             # @variable / Identifier
    return my_function(result)                 # @function.call

print("hello")                                 # print → @function.builtin / Special
len([1, 2, 3])                                 # len → @function.builtin
my_function(42)                                # @function.call

# ─── Built-in types ─────────────────────────────────────────────────────────
isinstance(count, int)                         # int → @type.builtin / Type
isinstance(message, str)                       # str → @type.builtin
x = list()                                     # list → @type.builtin
y = dict()                                     # dict → @type.builtin

# ─── Operators, punctuation ─────────────────────────────────────────────────
result = 1 + 2 - 3 * 4 / 2                     # @operator / Operator
condition = True and False or not None         # @keyword.operator
items = [1, 2, 3]                              # @punctuation.bracket + @punctuation.delimiter
mapping = {"a": 1, "b": 2}                     # @punctuation.bracket + @property (keys)
tup = (1, 2, 3)                                # @punctuation.bracket
interp = f"{count:,.2f} items"                 # : and , inside {} → @punctuation.special

# ─── Control flow keywords ──────────────────────────────────────────────────
for i in range(10):                            # for / in → @keyword.repeat
    if i < 5:                                  # if → @keyword.conditional
        continue                               # @keyword
    elif i > 8:                                # elif → @keyword.conditional
        break                                  # @keyword
    else:                                      # else → @keyword.conditional
        pass                                   # @keyword

def control_flow_demo():
    enclosed = 0
    while False:                                # while → @keyword.repeat / Repeat
        yield count                             # yield → @keyword.coroutine / @keyword.return
        return count                            # return → @keyword.return

    try:                                        # @keyword.exception / Exception
        1 / 0
    except ZeroDivisionError as e:              # except → @keyword.exception
        raise                                   # raise → @keyword.exception
    finally:
        pass

    def nested():
        global global_var                       # global → @keyword.modifier
        nonlocal enclosed                       # nonlocal → @keyword.modifier

async def coroutine():                         # async → @keyword.coroutine
    import asyncio
    await asyncio.sleep(1)                     # await → @keyword.coroutine

lambda_fn = lambda x: x * 2                    # lambda → @keyword.function

# ─── Conditional / Repeat (Vim syntax base groups) ──────────────────────────
# Above `if` / `elif` / `else` / `for` / `while` also cascade into base groups
# Conditional and Repeat via treesitter defaults.

# ─── Trailing whitespace (ExtraWhitespace via augroup) ──────────────────────
trailing_demo = True
#              ^^^ three trailing spaces above should render pink

# ─── Implicitly exercised base syntax groups ────────────────────────────────
#
#   Normal, Identifier, Function, Statement, PreProc, Type, Underlined, Todo,
#   String, Character, Number, Boolean, Constant, Special, SpecialChar,
#   Operator, Keyword, Comment, Delimiter, Exception, Conditional, Repeat,
#   Ignore (rare — for text explicitly marked uninteresting)
#
# All cascade from treesitter captures above via default links in
# runtime/lua/vim/... and src/nvim/highlight_group.c.
#
# ─── Language-specific captures not triggered by Python ─────────────────────
#
#   @variable.global — some grammars tag global-scope variables distinctly
#                      (e.g., global-scope Vim g: variables, Lua globals).
#   See sample.c, sample.js, sample.md, sample.html, sample.diff for gaps.

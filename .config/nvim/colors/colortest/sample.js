/*
 * JavaScript test file — exercises @string.regexp, @character.special,
 * template literals (@punctuation.special), and @string.special.symbol.
 * See README.md in this directory.
 */

// ─── Regex literals (@string.regexp) ────────────────────────────────────────
const simple = /foo/;                          // @string.regexp
const withFlags = /bar/gi;                     // @string.regexp
const complex = /^\d{3}-\d{4}$/i;              // @string.regexp + @character.special (\d)
const email = /[^@]+@[^@]+\.[^@]+/;            // @string.regexp
const escape = /\r\n/;                         // @string.regexp + @character.special

// Inline regex inside method calls
"hello world".match(/(\w+)\s+(\w+)/);          // @string.regexp
"abc123".replace(/\d+/g, "X");                 // @string.regexp

// ─── Template literals ──────────────────────────────────────────────────────
const name = "world";                          // @string / String
const greeting = `Hello, ${name}!`;            // @string + ${…} → @punctuation.special
const multiline = `line 1
line 2
${42 * 2} computed`;                            // template interpolation

// Tagged template literal
const html = `<div>${name}</div>`;
const styled = css`color: red;`;               // tag function on template

// ─── Symbols (@string.special.symbol) ───────────────────────────────────────
const sym = Symbol("id");                      // Symbol(…) — not a JS literal syntax
const unique = Symbol.iterator;                // Symbol.iterator

// ─── Strings with escapes (@string.escape) ──────────────────────────────────
const escaped = "tab:\there\nnew line";        // @string.escape
const unicode = "\u00e9";                      // @string.escape
const hex = "\x41";                             // @string.escape

// ─── Labels (JS has labeled statements) ─────────────────────────────────────
outer:                                         // @label / Label
for (let i = 0; i < 10; i++) {
  inner:                                       // @label
  for (let j = 0; j < 10; j++) {
    if (j === 5) break outer;                  // break outer → @label reference
    if (j === 3) continue inner;               // continue inner → @label reference
  }
}

// ─── Number literals (@number / @number.float) ─────────────────────────────
const int = 42;                                // @number
const float = 3.14;                            // @number.float
const bigint = 9007199254740993n;              // @number
const sci = 1.5e10;                            // @number.float
const hex_num = 0xff;                          // @number
const oct = 0o17;                              // @number
const bin = 0b1010;                            // @number

// ─── Arrow functions / classes ──────────────────────────────────────────────
const add = (a, b) => a + b;                   // @function
const square = x => x * x;                     // @function

class Rectangle {                              // @type + @constructor
  constructor(w, h) {                          // @function.method
    this.width = w;                            // this → @variable.builtin ; .width → @property
    this.height = h;
  }

  get area() {                                 // getter — @function.method
    return this.width * this.height;
  }

  static create(size) {                        // static → @keyword.modifier
    return new Rectangle(size, size);          // new → @keyword
  }
}

const r = new Rectangle(10, 5);                // new → @keyword ; Rectangle(…) → @constructor call
console.log(r.area);                           // console.log → @function.method.call

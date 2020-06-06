---
layout: default
title: About
---
pijamas
=======
[![Build Status](https://travis-ci.org/Zardoz89/pijamas.svg?branch=master)](https://travis-ci.org/Zardoz89/pijamas)
[![Build status](https://ci.appveyor.com/api/projects/status/7rwhguv6wfvyrufs/branch/master?svg=true)](https://ci.appveyor.com/project/Zardoz89/pijamas/branch/master)

- - -

<img src="https://zardoz89.github.io/pijamas/assets/img/logo-big.png" align="left"/>
A BDD assertion library for D.

Forked from [Yamadacpc's Pyjamas](http://yamadapc.github.io/pyjamas/)

## Example
```d
import pyjamas;

10.should.equal(10);
5.should.not.equal(10);
[1, 2, 3, 4].should.include(3);
```

## Introduction

Pyjamas, and by extension Pijamas, is an assertion library heavily inspired by [visionmedia'ś
should.js](https://github.com/visionmedia/should.js) module for Node.JS.

## General Assertions

Pijamas exports a single function `should` meant for public use. Because of D's
lookup shortcut syntax, one is able to use both `should(obj)` and `obj.should`
to get an object wrapped around an `Assertion` instance.

#### `.be` `.as` `.of` `.a` `.and` `.have` `.which`

These methods all are aliases for an identity function, returning the assertion
instance without modification. This allows one to have a more fluent API, by
chaining statements together:

```d
10.should.be.equal(10);
[1, 2, 3, 4].should.have.length(4);
```

#### `Assertion not()`

This function negates the wrapper assertion. With it, one can express fluent
assertions without much effort:
```d
10.should.not.equal(2);
```

#### `T equal(U)(U other, string file = __FILE__, size_t line = __LINE__);`

Asserts for equality between two objects. Returns the value wrapped around the
assertion.
```d
[1, 2, 3, 4].should.equal([1, 2, 3, 4]);
255.should.equal(10); // Throws an Exception "expected 255 to equal 10"
```

#### `T approxEqual(U)(U other, U maxRelDiff = 1e-2, U maxAbsDiff = 1e-05, string file = __FILE__, size_t line = __LINE__);`

Asserts for aproximated equality of float types. Returns the value wrapped around the
assertion.
```d
(1.0f).should.be.approxEqual(1.00000001);
(1.0f).should.not.be.approxEqual(1.001);
```

#### `T exist(string file = __FILE__, size_t line = __LINE__);`

Asserts whether a value exists - currently simply compares it with `null`, if it
is convertible to `null` (actually strings, pointers and classes). Returns the 
value wrapped around the assertion.
```d
auto exists = "I exist!";
should(exists).exist;
string doesntexist;
doesntexist.should.exist; // Throws an Exception "expected null to exist"
```

#### `bool biggerThan(U)(U other, string file = __FILE__, size_t line = __LINE__);`

Asserts if a value is bigger than another value. Returns the result.
```d
"z".should.be.biggerThan("a");
10.should.be.biggerThan(1);
```

#### `bool biggerOrEqualThan(U)(U other, string file = __FILE__, size_t line = __LINE__);`

Asserts if a value is bigger or euqal than another value. Returns the result.
```d
10.should.be.biggerOrEqualThan(1);
10.should.be.biggerOrEqualThan(10);
```

#### `bool smallerThan(U)(U other, string file = __FILE__, size_t line = __LINE__)`

Asserts if a value is smaller than another value. Returns the result.
```d
10.should.be.smallerThan(100);
false.should.be.smallerThan(true);
```

#### `bool smallerOrEqualThan(U)(U other, string file = __FILE__, size_t line = __LINE__)`

Asserts if a value is smaller or equal than another value. Returns the result.
```d
10.should.be.smallerOrEqualThan(100);
10.should.be.smallerOrEqualThan(10);
```

#### `U include(U)(U other, string file = __FILE__, size_t line = __LINE__);`

Asserts for an input range wrapped around an `Assertion` to contain/include a
value.
```d
[1, 2, 3, 4].should.include(3);
"something".should.not.include('o');
"something".should.include("th");
```

#### `U length(U)(U length, string file = __FILE__, size_t line = __LINE__);`

Asserts for the `.length` property or function value to equal some value.

```d
[1, 2, 3, 4].should.have.length(4);
"abcdefg".should.have.length(0);
// ^^ - Throws an Exception "expected 'abcdefg' to have length of 0"
```

#### `bool empty(string file = __FILE__, size_t line = __LINE__);`

Asserts that the .lenght property or function value is equal to 0;

```d
[].should.be.empty;
"".should.be.empty;
```

#### `auto match(RegEx)(RegEx re, string file = __FILE__, size_t line = __LINE__);`

Asserts for a string wrapped around the Assertion to match a regular expression.
```d
"something weird".should.match(`[a-z]+`);
"something weird".should.match(regex(`[a-z]+`));
"something 2 weird".should.not.match(ctRegex!`^[a-z]+$`));
"1234numbers".should.match(`[0-9]+[a-z]+`);
"1234numbers".should.not.match(`^[a-z]+`);
```

#### `bool True(string file = __FILE__, size_t = line = __LINE__);` and `.False`

Both functions have the same signature.
Asserts for a boolean value to be equal to `true` or to ``false`.`

```d
true.should.be.True;
false.should.be.False;
```

#### `bool sorted(string file = __FILE__, size_t line = __LINE__);`

Asserts whether a forward range is sorted.

```d
[1, 2, 3, 4].should.be.sorted;
[1, 2, 0, 4].should.not.be.sorted;
```

#### `void key(U)(U other, string file = __FILE__, size_t line = __LINE__);`

Asserts for an associative array to have a key equal to `other`.

```d
["something": 10].should.have.key("something");
```

#### `void Throw(T : Throwable)(string file = __FILE__, size_t line = __LINE__);`

Asserts whether a callable object wrapped around the assertion throws an
exception of type T.
```d
void throwing()
{
  throw new Exception("I throw with 0!");
}

should(&throwing).Throw!Exception;

void notThrowing()
{
  return;
}

should(&notThrowing).not.Throw;
```

## Need more documentation?

I know the documentation is still somewhat lacking, but it's better than
nothing, I guess? :)

Try looking at the test suite in [`tests/pyjamas_spec.d`](/tests/pyjamas_spec.d)
to see some "real world" testing of the library. Even though we are using [Silly](https://gitlab.com/AntonMeep/silly)
testing runner, this library is supposed to be framework agnostic.

BTW, I'll be glad to accept help in writting the documentation.

## Tests

Run tests with:

```
dub test
```

## Why 'Pijamas'

The original project was name "Pyjamas", a name that could be confuse, and have
name clash on search engines, with Python's Pyjamas framework. So a new name
sees a good idea. Pijamas is the word on Spanish and English for "Pyjamas", so
it's a start. If anyone have a better name, hurry up to suggest it.

## License

This code is licensed under the MIT license. See the [LICENSE](LICENSE) file
for more information.


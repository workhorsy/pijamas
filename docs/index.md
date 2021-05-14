---
layout: default
title: About
---
pijamas
=======
[![DUB](https://img.shields.io/dub/v/pijamas)](https://code.dlang.org/packages/pijamas)
![Build status](https://img.shields.io/github/checks-status/Zardoz89/pijamas/master)
[![codecov](https://codecov.io/gh/Zardoz89/pijamas/branch/master/graph/badge.svg?token=LWSVAL95DG)](https://codecov.io/gh/Zardoz89/pijamas)

- - -

<img src="https://zardoz89.github.io/pijamas/assets/img/logo-big.png" align="left"/>
A BDD fluent assertion library for D.

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

It aspires to be totally independent of the unit test runner and be IDE friendly. Also, it 
offers a fluent like syntax that allow to make human reaable assertions.

<img src="https://zardoz89.github.io/pijamas/assets/img/ide.png" style="margin: 0 auto; display: block;" />

A failing assertation throws an AssertException with information of what was
expected, and file and line number where it failed. An AssertException it's an
alias to AsertError or to UnitTestException if Unit-thereaded it's present.

<img src="https://zardoz89.github.io/pijamas/assets/img/error.png" />

## Usage

Simply add pijamas as a dependency :

dub.sdl:
```sdl
configuration "unittest" {
    dependency "pijamas" version="<current version>"
}
```

dub.json:
```json
"configurations": [
    {
        "name": "unittest",
        "dependencies": {
            "pijamas": "<current version>"
        }
    }
]
```

And import pijamas where you nee it.


### General Assertions

Pijamas exports two functions `should` and `expect` meant for public use. Because of D's
lookup shortcut syntax, one is able to use both `should(obj)`, `expect(obj)`, 
`obj.should` and `obj.expect` to get an object wrapped around an `Assertion` instance.

#### `.be` `.to` `.as` `.of` `.a` `.and` `.have` `.which`

These methods all are aliases for an identity function, returning the assertion
instance without modification. This allows one to have a more fluent API, by
chaining statements together:

```d
10.should.be.equal(10);
[1, 2, 3, 4].should.have.length(4);
10.expect.to.not.be.equal(0);
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

#### `T approxEqual(U)(U other, U maxRelDiff = CommonDefaultFor!(T,U), U maxAbsDiff = 0.0, string file = __FILE__, size_t line = __LINE__);`

Asserts for approximated equality of float types. Returns the value wrapped around the
assertion. See Phobos std.math.isClose().
```d
(1.0f).should.be.approxEqual(1.00000001);
(1.0f).should.not.be.approxEqual(1.01);
```
#### `T close(U)(U other, U maxRelDiff = CommonDefaultFor!(T,U), U maxAbsDiff = 0.0, string file = __FILE__, size_t line = __LINE__);`

Alias of approxEqual

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
"".expect.to.be.empty;
```

#### `auto match(RegEx)(RegEx re, string file = __FILE__, size_t line = __LINE__);`

Asserts for a string wrapped around the Assertion to match a regular expression.
```d
"something weird".expect.to.match(`[a-z]+`);
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
to see some "real world" testing of the library. 
BTW, I'll be glad to accept help in writting the documentation.

## Tests

Run tests with:

```
dub test --root=tests/silly 
```

but you can try any other test runner :
```
dub test --root=tests/unit-threaded
dub test --root=tests/dunit
dub test --root=tests/d-unit
dub run trial:runner@~master
```
A special config "fail-tests", exists (but only works on silly and on dunit) that 
enforces to fail some tests to help debug Pijamas mesages.

## Why 'Pijamas'

The original project was name "Pyjamas", a name that could be confuse, and have
name clash on search engines, with Python's Pyjamas framework. So a new name
sees a good idea. Pijamas is the word on Spanish and English for "Pyjamas", so
it's a start. If anyone have a better name, hurry up to suggest it.

And the real why. Because Pyjamas had a nice syntax compared against others 
libraries, but sadly was abandoned.

Also, was the only barely working assert (at the time) library that don't 
poluttes dub.selections with unit-threaded when you aren't using unit-threaded.
Even though we are using [Silly](https://gitlab.com/AntonMeep/silly)
testing runner, this library is supposed to be framework agnostic. The fact, 
it's tha the test suite has been testes running it with 
[unit-threaded](https://github.com/atilaneves/unit-threaded), 
[dunit](https://github.com/nomad-software/dunit), 
[d-unit](https://github.com/linkrope/dunit), [silly](https://gitlab.com/AntonMeep/silly)
and [trial](http://trial.szabobogdan.com/).


## License

This code is licensed under the MIT license. See the [LICENSE](LICENSE) file
for more information.


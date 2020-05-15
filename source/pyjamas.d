/**
 * Pijamas, a BDD assertion library for D.
 *
 * Authors: Pedro Tacla Yamada, Luis Panadero Guardeño
 * License: Licensed under the MIT license. See LICENSE for more information.
 */
module pyjamas;

import std.algorithm : canFind, isSorted;
import std.conv : to;
import std.range : isInputRange, isForwardRange, hasLength, ElementEncodingType,
                   empty;
import std.regex : Regex, StaticRegex;// & std.regex.match
import std.string : format;
import std.traits : hasMember, isSomeString, isCallable, isAssociativeArray,
                    isImplicitlyConvertible, Unqual;

/**
 * Pijamas exports a single function should meant for public use. Because of D’s lookup shortcut syntax, one is able
 * to use both should(obj) and obj.should to get an object wrapped around an Assertion instance
 */
Assertion!T should(T)(T context)
{
  return new Assertion!T(context);
}

/// Class returned by should, that it's used to generate the fluent API
class Assertion(T)
{
  static bool callable = isCallable!T;
  bool negated = false;
  string operator = "be";
  T context;

  this() {};
  this(T _context)
  {
    context = _context;
  }

  /// Identity function. Simply does nothing beyond making assertation more human friendly
  alias be = id;
  ///ditto
  alias as = id;
  ///ditto
  alias of = id;
  ///ditto
  alias a = id;
  ///ditto
  alias and = id;
  ///ditto
  alias have = id;
  ///ditto
  alias which = id;
  ///ditto
  Assertion id()
  {
    return this;
  }

  /**
   * This function negates the wrapper assertion. With it, one can express fluent assertions without much effort.
   *
   * Examples:
   * ```
   * 10.should.not.equal(2); // OK
   * 10.should.not.equal(10); // Throws an Exception "expected 10 not to be 10"
   * ```
   */
  Assertion not()
  {
    negated = !negated;
    return this;
  }

  // Helper that evaluates the asserted expression
  U ok(U)(U expr,
          lazy string message,
          string file = __FILE__,
          size_t line = __LINE__)
  {
    if(negated ? !expr : expr) return expr;
    throw new Exception(message, file, line);
  }

  /**
   * Asserts for equality between two objects. Returns the value wrapped around the assertion.
   *
   * Examples:
   * ```
   * [1, 2, 3, 4].should.equal([1, 2, 3, 4]);
   * 255.should.equal(10); // Throws an Exception "expected 255 to equal 10"
   * ```
   */
  T equal(U)(U other,
             string file = __FILE__,
             size_t line = __LINE__)
  {
    auto t_other = other.to!T;
    ok(context == other, message(other), file, line);
    return context;
  }

  /**
   * Asserts whether a value exists - currently simply compares it with null, if it is a pointer, a class or a string.
   * Returns the value wrapped around the assertion.
   *
   * Examples:
   * ```
   * auto exists = "I exist!";
   * should(exists).exist;
   * string doesntexist;
   * doesntexist.should.exist; // Throws an Exception "expected null to exist"
   * Object aObject;
   * aClass.should.not.exists;
   * ```
   */
  T exist(string file = __FILE__, size_t line = __LINE__)
  {
    import std.traits : isPointer, isSomeString;
    static if(isPointer!T || isSomeString!T || __traits(compiles, () { T t; assert(t is null);}))
    {
      if(context is null)
      {
        ok(false, message, file, line);
      }
    }
    return context;
  }

  // Generates string message when an assertation fails
  string message(U)(U other)
  {
    return format("expected %s to %s%s%s", context.to!string,
                                           (negated ? "not " : ""),
                                           operator,
                                           (" " ~ other.to!string));
  }

  // Generates string message when an assertation fails
  string message()
  {
    return format("expected %s to %s%s", context.to!string,
                                         (negated ? "not " : ""),
                                         operator);
  }

  /**
   * Asserts if a value is bigger than another value. Returns the result.
   *
   * Examples:
   * ```
   * "z".should.be.biggerThan("a");
   * 10.should.be.biggerThan(1);
   * ```
   */
  bool biggerThan(U)(U other, string file = __FILE__, size_t line = __LINE__)
  {
    operator = "be bigger than";
    return ok(context > other, message(other), file, line);
  }

  /**
   * Asserts if a value is smaller than another value. Returns the result.
   *
   * Examples:
   * ```
   * 10.should.be.smallerThan(100);
   * false.should.be.smallerThan(true);
   * ```
   */
  bool smallerThan(U)(U other, string file = __FILE__, size_t line = __LINE__)
  {
    operator = "be smaller than";
    return ok(context < other, message(other), file, line);
  }

  static if(isForwardRange!T && __traits(compiles, context.isSorted))
  {
    /**
     * Asserts whether a forward range is sorted.
     *
     * Examples:
     * ```
     * [1, 2, 3, 4].should.be.sorted;
     * [1, 2, 0, 4].should.not.be.sorted;
     * ```
     */
    bool sorted(string file = __FILE__, size_t line = __LINE__)
    {
      operator = "be sorted";
      return ok(context.isSorted, message, file, line);
    }
  }

  static if(isAssociativeArray!T) {
    /**
     * Asserts for an associative array to have a key equal to other.
     *
     * Examples:
     * ```
     * ["something": 10].should.have.key("something");
     * ```
     */
    void key(U)(U other, string file = __FILE__, size_t line = __LINE__)
    {
      operator = "have key";
      ok(!(other !in context), message(other), file, line);
    }
  }

  static if(isInputRange!T || isAssociativeArray!T)
  {
    /**
     * Asserts for an input range wrapped around an Assertion to contain/include a value.
     *
     * Examples:
     * ```
     * [1, 2, 3, 4].should.include(3);
     * "something".should.not.include('o');
     * "something".should.include("th");
     * ```
     */
    U include(U)(U other, string file = __FILE__, size_t line = __LINE__)
    {
      static if(isAssociativeArray!T) auto pool = context.values;
      else auto pool = context;

      operator = "contain value";
      ok(canFind(pool, other), message(other), file, line);
      return other;
    }

    ///ditto
    alias value = include;
    ///ditto
    alias contain = include;
  }

  static if(hasLength!T || hasMember!(T, "string") || isSomeString!T)
  {
    /**
     * Asserts for the .length property or function value to equal some value.
     *
     * Examples:
     * ```
     * [1, 2, 3, 4].should.have.length(4);
     * "abcdefg".should.have.length(0);
     * // ^^ - Throws an Exception "expected 'abcdefg' to have length of 0"
     * ```
     */
    U length(U)(U len, string file = __FILE__, size_t line = __LINE__)
    {
      operator = "have length of";
      ok(context.length == len, message(len), file, line);
      return len;
    }
  }

  import std.regex : Regex, isRegexFor;
  import std.traits : isSomeString;
  static if(isSomeString!T)
  {

    /**
     * Asserts for a string wrapped around the Assertion to match a regular expression.
     *
     * Examples:
     * ```
     * "something weird".should.match(`[a-z]+`);
     * "something weird".should.match(regex(`[a-z]+`));
     * "something 2 weird".should.not.match(ctRegex!(`^[a-z]+$`));
     * "1234numbers".should.match(`[0-9]+[a-z]+`);
     * "1234numbers".should.not.match(`^[a-z]+`);
     * ```
     */
    auto match(RegEx)(RegEx re, string file = __FILE__, size_t line = __LINE__)
      if (isSomeString!T && isRegexFor!(RegEx, T))
    {
      import std.regex : match;
      auto m = match(context, re);
      operator = "match";
      ok(!m.empty, message(re), file, line);
      return m;
    }

    ///ditto
    auto match(U)(U re, string file = __FILE__, size_t line = __LINE__)
      if (isSomeString!T && isSomeString!U)
    {
      import std.regex : regex, match;
      auto m = match(context, regex(re));
      operator = "match";
      ok(!m.empty, message(re), file, line);
      return m;
    }
  }

  static if(is(T == bool))
  {
    /**
     * Asserts for a boolean value to be equal to true.
     *
     * Examples:
     * ```
     * true.should.be.True;
     * (1 == 1).should.be.True;
     * ```
     */
    bool True(string file = __FILE__, size_t line = __LINE__)
    {
      return ok(context == true, message(true), file, line);
    }

    /**
     * Asserts for a boolean value to be equal to true.
     *
     * Examples:
     * ```
     * false.should.be.False;
     * (1 != 1).should.be.False;
     * ```
     */
    bool False(string file = __FILE__, size_t line = __LINE__)
    {
      return !ok(context == false, message(false), file, line);
    }
  }

  static if(isCallable!T)
 {
    /**
     * Asserts whether a callable object wrapped around the assertion throws an exception of type T.
     *
     * Examples:
     * ```
     * void throwing()
     * {
     *   throw new Exception("I throw with 0!");
     * }

     * should(&throwing).Throw!Exception;

     * void notThrowing()
     * {
     *   return;
     * }
     *
     * should(&notThrowing).not.Throw;
     * ```
     */
    void Throw(T : Throwable = Exception)(string file = __FILE__,
                                          size_t line = __LINE__)
    {
      operator = "throw";
      bool thrown = false;
      try context();
      catch(T) thrown = true;
      ok(thrown, message(), file, line);
    }
  }

}

@("Should(v)")
unittest {
  //  it("returns an Assertion", {
  assert(is(typeof(10.should) == Assertion!int));
}

@("Should Assertion")
unittest {
  //  it("can be instantiated for ranges of structs without `opCmp`", {
  struct Test {
    int a;
    int b;
  }

  cast(void) [ Test( 2, 3)].should;
}

@("Should Assertion.message")
unittest {
  //  it("returns the correct message for binary operators",
  {
    auto a = new Assertion!int( 10);
    a.operator = "equal";
    assert(a.message( 20) == "expected 10 to equal 20");
  }

  //  it("returns the correct message for unary operators",
  {
    auto a = new Assertion!string( "function");
    a.operator = "throw";
    assert(a.message == "expected function to throw");
  }

  //  it("returns the correct message for negated operators",
  {
    auto a = new Assertion!int( 10);
    a.operator = "be";
    assert(a.not.message( false) == "expected 10 to not be false");
  }
}



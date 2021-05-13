/**
 * Tests/Examples of Pijamas
 *
 * Authors: Pedro Tacla Yamada, Luis Panadero Guardeño
 * License: Licensed under the MIT license. See LICENSE for more information.
 */
module pijamas_spec;

import std.exception;

import pijamas : should;
import pijamas.exception : AssertException;

version(Debug_Failing_Tests) {
  @("Failing test")
  unittest
  {
    10.should.be.equal(0);
  }

  @("Failing test with native assert")
  unittest
  {
    assert(10 == 0);
  }

  @("Error test")
  unittest
  {
    throw new Exception("Some exception");
  }
}

@("Should Assertion.exist")
@trusted unittest
{
  //  it("existence of string",
  {
    // String
    string str;
    str.should.not.exist;
    assertNotThrown!AssertException(str.should.not.exist);
    assertThrown!AssertException(str.should.exist);

    string str2 = null;
    str2.should.not.exist;
  }

  //  it("With not nullable, must do nothing
  {
    int i = 10;
    i.should.exist;
    i.should.not.exist;

    struct S
    {
      int x;
    }

    S s;
    assertNotThrown!AssertException(s.should.exist);
    assertNotThrown!AssertException(s.should.not.exist);
  }

  //  it("Pointer not being a null pointer"
  {
    // Ptr
    int* ptr = null;
    ptr.should.not.exist;
    assertThrown!AssertException(ptr.should.exist);

    int value;
    ptr = &value;
    ptr.should.exist;
  }

  //  it("Class reference"
  {
    // Class
    class C
    {
      int x;
      this()
      {
      }
    }

    C c;
    c.should.not.exist;
    assertThrown!AssertException(c.should.exist);

    c = new C();
    c.should.exist;
  }
}

@("Asserting a field of a no copiable Struct")
@safe unittest
{
  struct S {
    this(this) @disable;

    int x;
    size_t length;
  }

  auto s = S(123, 10);
  s.x.should.be.equal(123);
  // s.should.have.length(10); // Error is not copyable because it is annotated with @disable
}

@("Should Assertion.True")
@trusted unittest
{
  // it("returns and asserts for true",
  {
    true.should.be.True;
    (1 == 1).should.be.True;
  }

  // it("throws for false",
  {
    (1 != 1).should.not.be.True;
    assertThrown!AssertException(false.should.be.True);
  }
}

@("Should Assertion.False")
@trusted unittest
{
  // it("returns and asserts for false",
  {
    false.should.be.False;
    (1 != 1).should.be.False;
  }

  // it("throws for true",
  {
    true.should.not.be.False;
    assertThrown!AssertException((1 == 1).should.be.False);
  }
}

@("Should Assertion.equal")
@trusted unittest
{
  //  it("asserts whether two values are equal",
  {
    10.should.be.equal(10);
    10.should.not.be.equal(5);
    10.should.not;
    assertThrown!AssertException(10.should.be.equal(2));
  }

  //  it("works for arrays",
  {
    [1, 2, 3, 4].should.be.equal([1, 2, 3, 4]);

    byte[] a2 = [0, 2, 1];
    a2.should.not.be.equal([1, 2, 3, 5]);
    assertThrown!AssertException(a2.should.be.equal([100, 200, 4]));
  }

  //  it("works for ranges",
  /*
  // FIX Fix for ranges ... if "other" is an array, should convert the range to an array and compare.
  // also, must be careful with infinite ranges
  {
  import std.range : iota;
  auto r = iota(1, 4);
  r.should.be.equal([1, 2, 3, 4]);
  }
   */

  //  it("works for structs",
  {
    struct ExampleS
    {
      bool a = false;
      string f = "something";
    }

    auto e = ExampleS(true, "here");
    e.should.be.equal(ExampleS(true, "here"));
    e.should.be.not.equal(ExampleS(true, "asdf"));
    assertThrown!AssertException(e.should.be.equal(ExampleS(true, "asdf")));
  }

  //  it("works for classes",
  {
    class ExampleC
    {
      int x;
      this (int x)
      {
        this.x = x;
      }

      override bool opEquals(Object o) const// @trusted
      {
        if (ExampleC rhs = cast(ExampleC)o) {
          return this.x == rhs.x;
        }
        return false;
      }
    }

    class OtherClass
    {
      int x;
      this (int x)
      {
        this.x = x;
      }
    }

    auto e = new ExampleC(33);
    e.should.be.equal(new ExampleC(33));
    e.should.be.not.equal(new ExampleC(1));
    assertThrown!AssertException(e.should.be.equal(new ExampleC(1)));

    e.should.be.not.equal(new OtherClass(33));
    assertThrown!AssertException(e.should.be.equal(new OtherClass(33)));

  }
}

@("Should Assertion.approxEqual")
@trusted unittest
{
  // it("asserts that the identical value are identical")
  {
    float f = 0.01;
    f.should.be.approxEqual(f);
    f.should.be.close(f);

    double d = 0.01;
    d.should.be.approxEqual(d);

    real r = 0.01;
    r.should.be.approxEqual(r);
  }

  // it("handles comparing diferent float types")
  {
    float f = 0.01;
    double d = 0.01;
    real r = 0.01;
    f.should.be.approxEqual(d);
    f.should.be.approxEqual(r);

    d.should.be.approxEqual(f);
    d.should.be.approxEqual(r);

    r.should.be.approxEqual(f);
    r.should.be.approxEqual(d);
  }

  // it("asserts that two nearly identical float values are approximated equal")
  {
    float one = 1_000_000_000.0;
    one.should.be.close(999_999_999.0);

    double d = 0.1;
    double d2 = d + 1e-10;
    d.should.not.be.equal(d2);
    d.should.be.approxEqual(d2);

    // and("when increase the difference, it must not be approximated equals")
    d2 += 1e-5;
    d.should.not.be.equal(d2);
    d.should.not.be.approxEqual(d2);
    assertThrown!AssertException(d.should.be.approxEqual(d2));

    // and("Different default limits for different floating point types")
    float oneFloat = 1.0f;
    double oneDouble = 1.0;
    oneFloat.should.be.close(0.999_99f);
    oneDouble.should.not.be.close(0.999_99);
  }
}

@("Should Assertion.match")
@trusted unittest
{
  // it("returns whether a string type matches a Regex",
  {
    import std.regex : regex;

    string str = "Something weird";
    str.should.match(regex(`[a-z]+`));
    assertThrown!AssertException(str.should.match(regex(`[0-9]+`)));
  }

  // it("returns whether a string type matches a StaticRegex",
  {
    import std.regex : ctRegex;

    string str = "something 2 weird";
    str.should.match(ctRegex!`[a-z0-9]+`);
    assertThrown!AssertException(str.should.match(ctRegex!`^[a-z]+$`));
  }

  // it("returns whether a string type matches a string regex",
  {
    string str = "1234numbers";
    str.should.match(`[0-9]+[a-z]+`);
    str.should.not.match(`^[a-z]+`);
    assertThrown!AssertException(str.should.match(`^[a-z]+`));
  }
}

@("Should Assertion.include")
@trusted unittest
{
  // it("asserts for arrays containing elements",
  {
    int[] a = [1, 2, 3, 4, 5, 6];
    a.should.include(4);
    a.should.not.include(7);
    assertThrown!AssertException(a.should.include(7));
  }

  // it("asserts for associative arrays containing values",
  {
    int[string] aa = ["something" : 2, "else" : 3];
    aa.should.have.value(2);
    aa.should.not.have.value(4);
    assertThrown!AssertException(aa.should.have.value(42));
  }

  // it("asserts for strings containing characters",
  {
    string str = "asdf1";
    str.should.include('a');
    str.should.include("sd");
    str.should.not.include(2);
    str.should.not.include('u');
    assertThrown!AssertException(str.should.include('z'));
  }
}

@("Should Assertion.length")
@trusted unittest
{
  // it("asserts for length equality for strings",
  {
    auto str = "1234567";
    str.should.have.length(7);
    assertThrown!AssertException(str.should.have.length(17));
  }

  // it("asserts for length equality for arrays",
  {
    auto a = [1, 2, 3, 4, 5, 6];
    a.should.have.length(6);
    assertThrown!AssertException(a.should.have.length(16));
  }

  // it("asserts for length equality for associative arrays",
  {
    string[string] aa = [
      "something" : "here", "what" : "is", "this" : "stuff", "we're" : "doing"
    ];
    aa.should.have.length(4);
    assertThrown!AssertException(aa.should.have.length(24));
  }
}

@("Should Assertion.empty")
@trusted unittest
{
  // it("asserts that a string is empty"
  {
    auto str = "1234567";
    str.should.not.be.empty;
    assertThrown!AssertException(str.should.be.empty);
    "".should.be.empty;
  }

  // it("asserts that an array is empty"
  {
    auto a = [1, 2, 3, 4, 5, 6];
    a.should.not.be.empty;
    assertThrown!AssertException(a.should.be.empty);
    int[] emptyArr;
    emptyArr.should.be.empty;
  }

  // it("asserts that an associative array is empty",
  {
    string[string] aa = [
      "something" : "here", "what" : "is", "this" : "stuff", "we're" : "doing"
    ];
    aa.should.not.be.empty;
    assertThrown!AssertException(aa.should.be.empty);
    int[string] emptyAa;
    emptyAa.should.be.empty;
  }
}

@("Should Assertion.Throw")
@trusted unittest
{
  // it("asserts whether an expressions throws",
  {
    void throwing()
    {
      throw new Exception("I throw with 0!");
    }

    assertThrown!Exception(throwing());
    should(&throwing).Throw!Exception;

    void notThrowing()
    {
      return;
    }

    should(&notThrowing).not.Throw;
  }
}

@("Should Assertion.key")
@trusted unittest
{
  // it("asserts for `key` existence in types with `opIndex` defined",
  {
    auto aArr = ["something" : "here",];

    aArr.should.have.key("something");
    aArr.should.not.have.key("else");
    assertThrown!AssertException(aArr.should.have.key("another"));
  }
}

@("Should Assertion.sorted")
@trusted unittest
{
  // it("asserts whether a range is sorted",
  {
    auto unsorted = [4, 3, 2, 1];
    unsorted.should.not.be.sorted;
    assertThrown!AssertException(unsorted.should.be.sorted);
    auto sortedAr = [1, 2, 3, 4, 8];
    sortedAr.should.be.sorted;
    assertThrown!AssertException(sortedAr.should.not.be.sorted);
  }
}

@("Should Assertion.biggerThan")
@trusted unittest
{
  //it("asserts whether a value is bigger than other",
  {
    auto a1 = true;
    a1.should.be.biggerThan(0);
    a1.should.be.biggerThan(false);

    auto a2 = "aab";
    a2.should.be.biggerThan("aaa");
    a2.should.not.be.biggerThan("zz");
    assertThrown!AssertException(a2.should.be.biggerThan("zz"));

    10.should.be.biggerOrEqualThan(10);
    50.should.be.biggerOrEqualThan(10);
  }
}

@("Should Assertion.smallerThan")
@trusted unittest
{
  // it("asserts whether a value is smaller than other",
  {
    auto a1 = false;
    a1.should.be.smallerThan(1);
    a1.should.be.smallerThan(true);

    auto a2 = 1000;
    a2.should.be.smallerThan(2000);
    a2.should.be.not.smallerThan(99);
    assertThrown!AssertException(a2.should.be.smallerThan(99));

    10.should.be.smallerOrEqualThan(10);
    10.should.be.smallerOrEqualThan(50);
  }
}

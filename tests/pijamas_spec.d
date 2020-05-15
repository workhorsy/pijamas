/**
 * Tests/Examples of Pijamas
 *
 * Authors: Pedro Tacla Yamada, Luis Panadero Guardeño
 * License: Licensed under the MIT license. See LICENSE for more information.
 */
module pijamas_spec;

import std.exception;

import pijamas;

@("Should Assertion.exist")
unittest {
  //  it("existence of string",
  {
    // String
    string str;
    str.should.not.exist;
    assertNotThrown!Exception(str.should.not.exist);
    assertThrown!Exception(str.should.exist);

    string str2 = null;
    str2.should.not.exist;
  }

  //  it("With not nullable, must do nothing
  {
    int i = 10;
    i.should.exist;
    i.should.not.exist;

    struct S { int x;}
    S s;
    assertNotThrown!Exception(s.should.exist);
    assertNotThrown!Exception(s.should.not.exist);
  }

  //  it("Pointer not being a null pointer"
  {
    // Ptr
    int* ptr = null;
    ptr.should.not.exist;
    assertThrown!Exception(ptr.should.exist);

    int value;
    ptr = &value;
    ptr.should.exist;
  }

  //  it("Class reference"
  {
    // Class
    class C {
      int x;
      this() {}
    }
    C c;
    c.should.not.exist;
    assertThrown!Exception(c.should.exist);
  }
}

@("Should Assertion.True")
unittest {
  // it("returns and asserts for true",
  {
    true.should.be.True;
    (1 == 1).should.be.True;
  }

  // it("throws for false",
  {
    (1 != 1).should.not.be.True;
    assertThrown!Exception(false.should.be.True);
  }
}

@("Should Assertion.False")
unittest {
  // it("returns and asserts for false",
  {
    false.should.be.False;
    (1 != 1).should.be.False;
  }

  // it("throws for true",
  {
    true.should.not.be.False;
    assertThrown!Exception((1 == 1).should.be.False);
  }
}

@("Should Assertion.equal")
unittest {
  //  it("asserts whether two values are equal",
  {
    10.should.be.equal(10);
    10.should.not.be.equal(5);
    10.should.not;
    assertThrown!Exception(10.should.be.equal(2));
  }

  //  it("works for arrays",
  {
    [1, 2, 3, 4].should.be.equal([1, 2, 3, 4]);

    byte[] a2 = [0, 2, 1];
    a2.should.not.be.equal([1, 2, 3, 5]);
    assertThrown!Exception(a2.should.be.equal([100, 200, 4]));
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
    struct Example
    {
      bool a = false;
      string f = "something";
    }

    auto e = Example(true, "here");
    e.should.be.equal(Example(true, "here"));
    e.should.be.not.equal(Example(true, "asdf"));
    assertThrown!Exception(e.should.be.equal(Example(true, "asdf")));
  }
}

@("Should Assertion.match")
unittest {
  // it("returns whether a string type matches a Regex",
  {
    import std.regex : regex;
    string str = "Something weird";
    str.should.match( regex( `[a-z]+`));
    assertThrown!Exception(str.should.match( regex(`[0-9]+`)));
  }

  // it("returns whether a string type matches a StaticRegex",
  {
     import std.regex : ctRegex;
     string str = "something 2 weird";
     str.should.match(ctRegex!`[a-z0-9]+`);
     assertThrown!Exception(str.should.match(ctRegex!`^[a-z]+$`));
  }

  // it("returns whether a string type matches a string regex",
  {
    string str = "1234numbers";
    str.should.match( `[0-9]+[a-z]+`);
    str.should.not.match( `^[a-z]+`);
    assertThrown!Exception(str.should.match( `^[a-z]+`));
  }
}

@("Should Assertion.include")
unittest {
  // it("asserts for arrays containing elements",
  {
    int[] a = [1, 2, 3, 4, 5, 6];
    a.should.include(4);
    a.should.not.include(7);
    assertThrown!Exception(a.should.include(7));
  }

  // it("asserts for associative arrays containing values",
  {
    int[string] aa = ["something": 2, "else": 3];
    aa.should.have.value(2);
    aa.should.not.have.value(4);
    assertThrown!Exception(aa.should.have.value(42));
  }

  // it("asserts for strings containing characters",
  {
    string str = "asdf1";
    str.should.include('a');
    str.should.include("sd");
    str.should.not.include(2);
    str.should.not.include('u');
    assertThrown!Exception(str.should.include('z'));
  }
}

@("Should Assertion.length")
unittest {
  // it("asserts for length equality for strings",
  {
    auto str = "1234567";
    str.should.have.length(7);
    assertThrown!Exception(str.should.have.length(17));
  }

  // it("asserts for length equality for arrays",
  {
    auto a = [1, 2, 3, 4, 5, 6];
    a.should.have.length(6);
    assertThrown!Exception(a.should.have.length(16));
  }

  // it("asserts for length equality for associative arrays",
  {
    string[string] aa = [
      "something": "here",
      "what": "is",
      "this": "stuff",
      "we're": "doing"
    ];
    aa.should.have.length(4);
    assertThrown!Exception(aa.should.have.length(24));
  }
}

@("Should Assertion.Throw")
unittest {
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
unittest {
  // it("asserts for `key` existence in types with `opIndex` defined",
  {
    auto aArr = [
      "something": "here",
    ];

    aArr.should.have.key("something");
    aArr.should.not.have.key("else");
    assertThrown!Exception(aArr.should.have.key("another"));
  }
}

@("Should Assertion.sorted")
unittest {
  // it("asserts whether a range is sorted",
  {
    auto unsorted = [4, 3, 2, 1];
    unsorted.should.not.be.sorted;
    assertThrown!Exception(unsorted.should.be.sorted);
    auto sortedAr = [1, 2, 3, 4, 8];
    sortedAr.should.be.sorted;
    assertThrown!Exception(sortedAr.should.not.be.sorted);
  }
}

@("Should Assertion.biggerThan")
unittest {
  //it("asserts whether a value is bigger than other",
  {
    auto a1 = true;
    a1.should.be.biggerThan(0);
    a1.should.be.biggerThan(false);

    auto a2 = "aab";
    a2.should.be.biggerThan("aaa");
    a2.should.not.be.biggerThan("zz");
    assertThrown!Exception(a2.should.be.biggerThan("zz"));
  }
}

@("Should Assertion.smallerThan")
unittest {
  // it("asserts whether a value is smaller than other",
  {
    auto a1 = false;
    a1.should.be.smallerThan(1);
    a1.should.be.smallerThan(true);

    auto a2 = 1000;
    a2.should.be.smallerThan(2000);
    a2.should.be.not.smallerThan(99);
    assertThrown!Exception(a2.should.be.smallerThan(99));
  }
}

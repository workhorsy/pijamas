module dunittest;

import std.exception;

import dunit;
import pijamas : should, PiException = AssertException;

int main (string[] args)
{
  return dunit_main(args);
}
/*
class Test
{
    mixin UnitTest;

    @Test
    public void shouldAssertionTrue() @trusted
    {
      // it("returns and asserts for true",
      {
        true.should.be.True;
        (1 == 1).should.be.True;
      }

      // it("throws for false",
      {
        (1 != 1).should.not.be.True;
        assertThrown!PiException(false.should.be.True);
      }
    }
}

version(Debug_Failing_Tests) {
  class FailingTest
  {
      mixin UnitTest;

      @Test
      public void failingTest()
      {
        10.assertEquals(0);
        //10.should.be.equal(0);
      }

      @Test
      public void failingTestNativeAssert()
      {
        assert(10 == 0);
      }

      @Test
      public void errorTest()
      {
        throw new Exception("Some exception");
      }
  }
}
*/

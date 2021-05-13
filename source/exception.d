/**
 * Pijamas, a BDD assertion library for D.
 *
 * License: Licensed under the MIT license. See LICENSE for more information.
 */
module pijamas.exception;

//version(Have_unit_threaded)
static if (__traits(compiles, { import unit_threaded.should : UnitTestException; }))
{
  import unit_threaded.should : UnitTestException;

  public alias AssertException = UnitTestException;
} else {
  import core.exception : AssertError;

  public alias AssertException = AssertError;
}



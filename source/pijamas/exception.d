/**
 * Pijamas, a BDD assertion library for D.
 *
 * License: Licensed under the MIT license. See LICENSE for more information.
 */
module pijamas.exception;

//version(Have_unit_threaded)
static if (__traits(compiles, { import unit_threaded.should : UnitTestException; })) {
  import unit_threaded.should : UnitTestException;

  alias BaseException = UnitTestException;

} else static if (__traits(compiles, { import dunit.error : DUnitAssertError; })) {
  import dunit.error : DUnitAssertError;

  alias BaseException = DUnitAssertError;

} else {

  alias BaseException = Exception;
}

/**
 * An exception thrown when a test fails
 */
public class AssertException : BaseException {

  /**
   * Constructor
   *
   * Params:
   *  msg = The failure message
   *  file = The filename where the test failed
   *  line = The line where the test failed
   */
  this(string msg, string file = __FILE__, size_t line = __LINE__) @safe pure {
    super(msg, file, line);
  }
}

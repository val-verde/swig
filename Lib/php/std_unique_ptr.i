/* -----------------------------------------------------------------------------
 * std_unique_ptr.i
 *
 * SWIG library file for handling std::unique_ptr.
 * Memory ownership is passed from the std::unique_ptr C++ layer to the proxy
 * class when returning a std::unique_ptr from a function.
 * Memory ownership is passed from the proxy class to the std::unique_ptr in the
 * C++ layer when passed as a parameter to a wrapped function.
 * ----------------------------------------------------------------------------- */

%define %unique_ptr(TYPE)
%typemap(in, noblock=1) std::unique_ptr< TYPE > (void *argp = 0, int res = 0) {
  res = SWIG_ConvertPtr(&$input, &argp, $descriptor(TYPE *), SWIG_POINTER_RELEASE);
  if (!SWIG_IsOK(res)) {
    if (res == SWIG_ERROR_RELEASE_NOT_OWNED) {
      zend_type_error("Cannot release ownership as memory is not owned for argument $argnum of type 'TYPE *' of $symname");
      return;
    } else {
      zend_type_error("Expected TYPE * for argument $argnum of $symname");
      return;
    }
  }
  $1.reset((TYPE *)argp);
}

%typemap (out) std::unique_ptr< TYPE > %{
  SWIG_SetPointerZval($result, (void *)$1.release(), $descriptor(TYPE *), SWIG_POINTER_OWN);
%}

%template() std::unique_ptr< TYPE >;
%enddef

namespace std {
  template <class T> class unique_ptr {};
}

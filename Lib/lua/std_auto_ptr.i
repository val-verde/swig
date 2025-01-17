/* -----------------------------------------------------------------------------
 * std_auto_ptr.i
 *
 * SWIG library file for handling std::auto_ptr.
 * Memory ownership is passed from the std::auto_ptr C++ layer to the proxy
 * class when returning a std::auto_ptr from a function.
 * Memory ownership is passed from the proxy class to the std::auto_ptr in the
 * C++ layer when passed as a parameter to a wrapped function.
 * ----------------------------------------------------------------------------- */

%define %auto_ptr(TYPE)
%typemap(in, checkfn="lua_isuserdata", noblock=1) std::auto_ptr< TYPE > (void *argp = 0, int res = 0) {
  res = SWIG_ConvertPtr(L, $input, &argp, $descriptor(TYPE *), SWIG_POINTER_RELEASE);
  if (!SWIG_IsOK(res)) {
    if (res == SWIG_ERROR_RELEASE_NOT_OWNED) {
      lua_pushfstring(L, "Cannot release ownership as memory is not owned for argument $argnum of type 'TYPE *' in $symname"); SWIG_fail;
    } else {
      SWIG_fail_ptr("$symname", $argnum, $descriptor(TYPE *));
    }
  }
  $1.reset((TYPE *)argp);
}

%typemap (out) std::auto_ptr< TYPE > %{
  SWIG_NewPointerObj(L, $1.release(), $descriptor(TYPE *), SWIG_POINTER_OWN); SWIG_arg++;
%}

%template() std::auto_ptr< TYPE >;
%enddef

namespace std {
  template <class T> class auto_ptr {};
}

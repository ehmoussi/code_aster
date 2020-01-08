.. _devguide-debugging:

***********************
Debugging and profiling
***********************


Debugging
=========

This section gives some tips about debugging code_aster.

.. note::

    ``waf install_debug`` turns on ``_DEBUG_CXX`` flag that prints some
    informations about objects live-cycle.
    Please ask a guru before adding new blocks under this flag!

    Detailed informations about the command syntax checker can be printed using
    the debug level of the :py:class:`~code_aster.Utilities.logger`.
    Use ``--debug`` option or set ``DEBUG=1`` environment variable.


.. todo::

    It will give an example of debugging the C++/Fortran objects of a
    sequential or a parallel build.

    Another part will give some informations to debug the Python part.


Helper functions
~~~~~~~~~~~~~~~~

- :py:func:`~code_aster.Objects.DataStructure.debugPrint`:
  This method is available on all :py:class:`~code_aster.Objects.DataStructure`
  objects. It prints the content of all its *Jeveux* objects.

- :py:func:`~code_aster.Objects.DataStructure.use_count`:
  This method is a wrapping to ``boost::shared_ptr< T >`` ``use_count()``
  member. It is available for only some
  :py:class:`~code_aster.Objects.DataStructure`.



Profiling
=========

The well known tool ``gprof`` is a very good and simple choice to profile an
executable but it does not work to profile a shared library.
And code_aster is a Python module built as a shared library.

.. note::

    Profiling code_aster using `gperftools`_ has been tested but the analysis
    of the results was difficult.

    More tools have to be evaluated.


.. _gperftools: https://github.com/gperftools/gperftools

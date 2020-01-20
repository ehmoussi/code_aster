.. _devguide:

#################
Developer's Guide
#################

*****************
Development rules
*****************

.. note::
    Please read carefully the :ref:`devguide-recommendations`.

.. note::

    - Add a testcase for all new features.

    - Coding standards: http://llvm.org/docs/CodingStandards.html

      The source code may (*should*) be formatted using
      :file:`$HOME/dev/codeaster/devtools/bin/beautify` (it uses the LLVM style,
      and the parameters from :file:`.clang-format`).

    - Document all new objects and methods.

      Use :file:`./check_docs.sh` script to check that new objects have been
      included in the documentation.

    - Check that the documentation can be built without warnings/errors.

    - The ``submit`` command from ``devtools`` checks that the fastest testcases
      pass without error (``asterxx`` testlist).
      The continous integration procedure checks more testcases (``ci`` testlist).

    - To execute testcases manually:

      Check the sequential testcases:

      .. code-block:: sh

        run_testcases --root=.. --testlist=asterxx --resutest=../resutest

      and the parallel ones:

      .. code-block:: sh

        run_testcases --root=.. --builddir=build/mpi --testlist=asterxx --resutest=../resutest_mpi


****************
General concepts
****************

All C, C++ and fortran source files are compiled and embedded in :file:`libaster.so`.
This shared library also contains Python modules: ``aster``, ``aster_core``,
``aster_fonctions``, ``med_aster`` and ``libaster`` which defines Python bindings
to the C++ objects.

The import of the ``libaster`` module initializes all other Python modules.

The closure of the memory manager is automatically done when there is no more
reference to ``libaster``.

Some Python objects are created during the initialization and are callable
by C/C++ functions (see :py:mod:`code_aster.Supervis` for details).


******************
code_aster package
******************

.. automodule:: code_aster
   :show-inheritance:
   :members:
   :special-members: __init__


********
Contents
********

..  toctree::
    :maxdepth: 3

    devguide/commands
    devguide/datastructures
    devguide/boost
    devguide/supervis
    devguide/utilities
    devguide/debugging

    devguide/documentation

    devguide/recommendations

    devguide/todolist

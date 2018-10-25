.. _devguide:

###############
Developer Guide
###############

*****************
Development rules
*****************

.. note::
    Please read carefully the :ref:`devguide-recommendations`.

.. note::

    - Add a testcase for all new features.

    - Coding standards: http://llvm.org/docs/CodingStandards.html

      Le code peut (*doit*) être reformatté en utilisant
      :file:`$HOME/dev/codeaster/devtools/bin/beautify` (utilise le style LLVM,
      plus les paramètres indiqués dans le fichier :file:`.clang-format`).

    - Document all new objects and methods.

      .. todo:: Automatically call the :file:`doc/generate_rst.py` script to
        include new objects in the documentation.

    - Check that the documentation can be built without warnings/errors.

    - All the *asterxx* testcases must be run before every push.

      Check the sequential testcases:

      .. code-block:: sh

        run_testcases --root=.. --testlist=asterxx --resutest=../resutest

      and the parallel ones:

      .. code-block:: sh

        run_testcases --root=.. --builddir=build/mpi --testlist=asterxx --resutest=../resutest_mpi

    - Currently, these testcases have been partially truncated because of
      unsupported features:

      .. todo::

        - test003a: ``Model.enrichWithXfem()`` does not exist.

        - xxCyclicSymmetryMode01b: ``CALC_MATR_ELEM/CHARGE`` does not accept
          `char_cine` objects.

        - xxFourierCombination001a: ``type(resu)`` is `evol_elas` but only
          `fourier_elas` or `fourier_ther` is expected.

        - xxMultiSteps01a is currently skipped, cf. `issue27123 <http://aster-rex.der.edf.fr/roundup/REX/issue27123>`_.


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

    devguide/documentation

    devguide/recommendations

    devguide/todolist

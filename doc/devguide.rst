.. _devguide:

###############
Developer Guide
###############

*****************
Development rules
*****************

.. note::

    - Add a testcase for all new features.

    - Check the source code conformance using tools like ``aslint``, ``pylint``,
      etc.

      .. todo:: Add script to automatically run these tools.
        For example as ``hg submit`` does.

    - Document all new objects and methods.

      .. todo:: Automatically call the :file:`doc/generate_rst.py` script to
        include new objects in the documentation.

    - Check that the documentation can be built without warnings/errors.

    - All the *asterxx* testcases must be run before every push using:

      .. code-block:: sh

        run_testcases --root=..  --testlist=asterxx --resutest=../resutest

    - List of testcases currently in failure :

      .. todo::

        .. code-block:: none

            test004b     <S>_ERROR              ConstitutiveLawEnum
            test004c     <S>_ERROR              ConstitutiveLawEnum
            test004d     <S>_ERROR              ConstitutiveLawEnum
            xxMultiSteps01a <S>_ERROR

    - Currently, these testcases have been partially truncated because of
      unsupported features:

      .. todo::

        - test003a: ``Model.enrichWithXfem()`` does not exist.

        - xxCyclicSymmetryMode01b: ``CALC_MATR_ELEM/CHARGE`` does not accept
          `char_cine` objects.

        - xxFourierCombination001a: ``type(resu)`` is `evol_elas` but only
          `fourier_elas` or `fourier_ther` is expected.


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
    devguide/supervis
    devguide/utilities

    devguide/documentation

    devguide/todolist

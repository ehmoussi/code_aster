.. _devguide:

###############
Developer Guide
###############

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

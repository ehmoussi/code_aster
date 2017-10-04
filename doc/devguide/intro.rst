.. _devguide-intro:

================
General concepts
================

All C, C++ and fortran source files are compiled and embedded in :file:`libaster.so`.
This shared library also contains Python modules: ``aster``, ``aster_core``,
``aster_fonctions``, ``med_aster`` and ``libaster`` which defines Python bindings
to the C++ objects.

The import of ``libaster`` initializes of Python modules.

The initialization of the memory manager (*Jeveux*) is done by ``code_aster.init()``.
The *legacy* command ``DEBUT`` does the same things.

The closure of the memory manager is automatically done when there is no more
reference to ``libaster``.

Some Python objects are created during the initialization and are callable
by C/C++ functions (see ``code_aster.Supervis`` for details).

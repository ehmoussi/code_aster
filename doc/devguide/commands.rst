.. _devguide-commands:

********
Commands
********

Catalog description
===================

Each command must define its user syntax through its catalog.
The checking of the user keywords is performed by the Catalog objects
(see :py:mod:`code_aster.Cata.SyntaxChecker`).

In the command executors the factor keywords are accessed like a *dict* object.
Factor keywords are always returned as a *list* even if ``max=1`` in the catalog.

Simple keywords value is returned a simple element if ``max=1``. If ``max > 1``
or ``max='**'`` a *list* is always returned even if there is only one element.

If a keyword is not provided by the user and if it has no default value, the
keyword does not exist in the *dict* object at all. In the legacy version, it
was ``None``.


Generic objects
===============

.. automodule:: code_aster.Commands.__init__
   :show-inheritance:
   :members:
   :special-members: __init__


Commands executors
==================

.. automodule:: code_aster.Commands.debut
   :show-inheritance:
   :members:
   :special-members: __init__

.. automodule:: code_aster.Commands.fin
   :show-inheritance:
   :members:
   :special-members: __init__


Utility functions for executors
===============================

.. automodule:: code_aster.Commands.operator
   :show-inheritance:
   :members:
   :special-members: __init__

.. automodule:: code_aster.Commands.common_keywords
   :show-inheritance:
   :members:
   :special-members: __init__

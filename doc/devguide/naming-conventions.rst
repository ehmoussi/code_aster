.. _devguide-naming-conventions:

******************
Naming conventions
******************

.. note::
    This article is still a *work in progress* document.

=============
General rules
=============

A general rule is to follow the `CamelCase <https://en.wikipedia.org/wiki/Camel_case>`_
convention in C++ code *and* its Python Bindings.
By extension, the *high level* user API also follows *CamelCase* naming.
The rest of the Python code, *low level* functions, should follow the
`PEP8 Style Guide for Python code <https://www.python.org/dev/peps/pep-0008/>`_
that does not recommend *CamelCase* naming.

- The **classes** names start with an upper case (example: *MeshCoordinatesField*).

- The **methods**/**members** names start with a lower case and
  does not contain the object name (example: *getValues* and not *getFieldValues*).

- At least at the beginning, only pure Python objects are returned (example: *list[list]*
  and not *numpy* arrays).


Reuse existing names in newly created objects. Have a look to the :ref:`genindex` page
should give good ideas for new methods.

One can also search for names in the :ref:`devguide-objects_datastructure` page.

Another rule is to define elementary methods not to create objects with a huge size.
For example, the groups names can be extracted from a mesh and cells indexes can be
extracted for a named group. But no method returns a *dict* of cells indexes for all
groups for exammple.
Another example: do not create shortcuts as *mesh.getCoordinatesValues()*
but *mesh.getCoordinates().getValues()*.

A senior developer must validate any changes to the user API (C++/Python bindings and
pure Python API).


========
Glossary
========

Mesh object
-----------

- *mesh* for a mesh.
- *node* for a node.
- *cell* for an element of the mesh.
- *GroupOfNodes* for a group of nodes, named with at most 24 chars.
- *GroupOfCells* for a group of cells, named with at most 24 chars.
- *Connectivity* for the mesh connectivity.
- A boolean argument named *local* is added when methods may work on the local part
  of a *ParallelMesh* (that belongs to each MPI process, *local=True*)
  or on the global mesh (*local=False*).

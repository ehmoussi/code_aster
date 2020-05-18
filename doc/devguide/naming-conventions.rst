.. _devguide-naming-conventions:

*******************************
Naming conventions / Python API
*******************************

.. note::
    This section is still a *work in progress* document.


=============
General rules
=============

A general rule is to follow the `CamelCase <https://en.wikipedia.org/wiki/Camel_case>`_
convention in C++ code *and* its Python Bindings.
By extension, the *high level* user API (Python) also follows *CamelCase* naming.
The rest of the Python code, *low level* functions, should follow the
`PEP8 Style Guide for Python code <https://www.python.org/dev/peps/pep-0008/>`_
that does not recommend *CamelCase* naming.

- The names of **classes** start with an upper case (example: *MeshCoordinatesField*).

- The names of **methods**/**members** start with a lower case and
  does not contain the object name (example: *getValues* and not *getFieldValues*).

- Reuse existing names in newly created objects. Have a look to the :ref:`genindex` page
  should give good ideas for new methods.
  One can also search for names in the :ref:`devguide-objects_datastructure` page.

- Plural forms should be used when it is relevant.

- Use same method name to pass a single value or a vector.
  Example: Do not define :py:obj:`addMaterialOnMesh(mater)` and
  :py:obj:`addMaterialsOnMesh(vect_mater)`, but only
  :py:meth:`~code_aster.Objects.MaterialField.addMaterialsOnMesh` with the both
  interfaces.

- At least at the beginning, only pure Python objects are returned (example: *list* or
  *list[list]* and not *numpy* arrays).

- *std::vector* and *JeveuxVector* objects are automatically converted to Python *list*.
  *JeveuxCollection* objects are also converted as *list[list]*.
  See :file:`PythonBindings/ConvertersInterface` for supported converters.

- Strings values are returned without trailing spaces.

Another rule is to define elementary methods not to create objects with a huge size.
For example, the groups names can be extracted from a mesh and cells indexes can be
extracted for a named group. But no method returns a *dict* of cells indexes for all
groups for example.
Another example: do not create shortcuts as *mesh.getCoordinatesValues()*
but *mesh.getCoordinates().getValues()*.

A senior developer must validate any changes to the user API (C++/Python bindings and
pure Python API).


========
Glossary
========

Mesh object
-----------

Terms for the :py:class:`~code_aster.Objects.Mesh` object:

- *mesh* is an object composed of *nodes* and *cells*.
- *node* for a node.
- *cell* for an element of the mesh (*element* term is used for a *finite element*).
- *GroupOfNodes* for a group of nodes, named with at most 24 chars.
- *GroupOfCells* for a group of cells, named with at most 24 chars.
- *Connectivity* for the mesh connectivity.
- For a *ParallelMesh*, an additional boolean argument named *local* allows to work
  on the local part (that belongs to each MPI process, *local=True*) or on the
  global mesh (*local=False*).

Methods are applied on all the mesh: *OnMesh*, on a group of cells: *OnGroupOfCells*
or on a group of nodes *OnGroupOfNodes*.

.. todo::
    Add *same* methods to *ParallelMesh* with a *local* argument.


Model object
------------

- *element* for a finite element (not a *cell*).


Result objects
--------------

- *result* is an object that contains several fields and eventually some other properties.

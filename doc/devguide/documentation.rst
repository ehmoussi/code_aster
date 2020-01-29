.. _devguide-documentation:

#####################
Writing documentation
#####################

************
Introduction
************

The documentation is written in `reStructuredText`_ using the
`Sphinx Documentation Generator <http://www.sphinx-doc.org>`_.

The theme is based on `Read The Docs Sphinx Theme
<https://readthedocs.org/>`_ with a few modifications.

See the Sphinx Documentation for details.


***************
Getting started
***************

=======
Example
=======

Documentation of functions arguments is using the *Google Style* supported
by the `sphinx-napoleon`_ extension.

As an example, this description of :py:func:`~help_doc.my_function`:

.. automodule:: help_doc
   :members:

is automatically generated from this source file:

.. literalinclude:: ../help_doc.py


=============================
Automatically generated pages
=============================

Except the page :ref:`devguide-objects_ext`, all source pages under
:ref:`devguide-datastructures` are automatically generated.
These pages group objects from :py:mod:`code_aster.Objects` by
subclasses of :py:class:`~code_aster.Objects.DataStructure`, of
:py:class:`~code_aster.Objects.GeneralMaterialBehaviour` and objects of other
types.

The source tree contains a script that can generate these pages:
:file:`doc/generate_rst.py` (use ``./doc/generate_rst.py --help`` for details).

It can be used to generate the source file for these three groups with::

    # prefer use a different terminal not to change your environment
    source  ../install/std/share/aster/profile.sh
    ./doc/generate_rst.py --objects --dest doc/devguide

It can also be used to generate a draft to document a package. Blocks are
printed on the standard output, copy/paste into your *rst* file.
For example: ::

    ./doc/generate_rst.py code_aster/Supervis/*.py


=====================================================
Link to :py:class:`~code_aster.Objects.DataStructure`
=====================================================

The previous example shows how to add a hyperlink to a *DataStructure*
(here :py:class:`~code_aster.Objects.Mesh`).

Please use links by refering to the :py:mod:`code_aster.Objects` package
like this::

    :py:class:`code_aster.Objects.Mesh`

and not::

    :py:class:`libaster.Mesh`

The objects are the same but the documentation of
:py:class:`code_aster.Objects.Mesh` exists but not that of
:py:class:`libaster.Mesh`.

.. note::
    Please always use links to *DataStructures*, *Classes* or *Methods* in
    the docstrings to improve the navigation in the documentation.


=================
Link to functions
=================

Use the same pattern to add a link to a function.
Remember to use the full/native *path* to generate the hyperlink::

    :py:func:`~code_aster.Helpers.Serializer.saveObjects`

and not::

    :py:func:`code_aster.saveObjects`

even if :py:func:`~code_aster.Helpers.Serializer.saveObjects` is imported
at the toplevel of the package.


.. _devguide-documentation-link_to_paragraph:

================================
Link to documentation paragraphs
================================

When it is possible, prefer link to Python objects (see previous paragraph).
Please use `ref`_ Sphinx role to add an internal link to another
part of the documentation, and not the reStructuredText notation which is more
difficult to maintain.

Label names used for cross-referencing must be unique. The convention is the
code_aster documentation is: ``part-file[-section]``.
For example, if one needs to add a link to this paragraph, just add before this
paragraph::

    .. _devguide-documentation-link_to_paragraph:

and insert a link with::

    :ref:`devguide-documentation-link_to_paragraph`

that is rendered with :ref:`devguide-documentation-link_to_paragraph`.


.. _ref: http://www.sphinx-doc.org/en/stable/markup/inline.html?role-ref#role-ref


===============
Add an equation
===============

.. todo:: Add an example of equations.


===============
Insert an image
===============

.. todo:: Add an example with a figure.


===========
Conventions
===========

reStructuredText uses markers to define the section structure.
Even the symbols used may change from one source file to another.

Please respect this convention to keep consistency between documents:

.. code-block:: rst

    #######
    Section
    #######

    *******
    Title 1
    *******

    =======
    Title 2
    =======

    Title 3
    -------

    Title 4
    ~~~~~~~


****************************
Generating the documentation
****************************

=============
Configuration
=============

Sphinx installation and requirements are checked during ``./waf configure``.

You need at least: ``sphinx-build``, ``dot`` and ``convert``.


============================
Generation of html documents
============================

To automatically extract the documentation from the Python objects, Sphinx
imports the objects themself. That means that ``libaster`` is imported, and
so, it must have been compiled.
That's why you must build code_aster **before** generating its documentation.

First step ``./waf build``, and then ``./waf doc``.
Or ``./waf build_debug``, then ``./waf doc_debug`` with the debug configuration.

.. todo::
    The ``waf`` script does not copy the html files into the installation
    directory for the moment.

.. note::
    It is necessary to remove the ``build/{debug,release}/doc`` directory
    to reflect last changes to update the :ref:`devguide-todolist` page.


========================
Browse the documentation
========================

Just open the :file:`index.html` in ``debug`` or ``release`` directory::

    firefox build/release/doc/html/index.html
    # or
    firefox build/debug/doc/html/index.html


*********
Resources
*********


- `Sphinx Documentation Content
  <http://www.sphinx-doc.org/en/stable/contents.html>`_.

- `reStructuredText`_ - Official site.

- `reStructuredText Primer (Sphinx documentation)
  <http://www.sphinx-doc.org/en/stable/rest.html>`_.


.. _reStructuredText: http://docutils.sourceforge.net/rst.html
.. _sphinx-napoleon: https://sphinxcontrib-napoleon.readthedocs.io/en/latest/

.. _devguide-datastructures:

########################
Objects / DataStructures
########################

DataStructures are managed in C++ and wrapped using Boost-Python.
Pure-python methods may be injected into the DataStructure by adding a module
named :file:`xxx_ext.py` in :py:mod:`code_aster.Objects`.

For example the module :py:mod:`code_aster.Objects.function_ext` adds
pure-Python methods to the :py:class:`~code_aster.Objects.Function` object.
It is not necessary to add a module just to define the ``cata_sdj`` attribute.
This definition can be added directly in
:py:mod:`code_aster.Objects.datastructure_ext` in the ``DICT_SDJ`` dict.


********************
Detailed description
********************

..  toctree::

    objects_datastructure
    objects_ext
    objects_materialbehaviour
    objects_others

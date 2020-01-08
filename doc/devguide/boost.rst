.. _devguide-boost:

*********************************
Boost wrapping of *DataStructure*
*********************************


Files structures
================

The definition of exposed methods of the *DataStructure* objects is included
into the ``libaster.so``. The main file is
:file:`bibcxx/PythonBindings/LibAster.cxx` that exports all symbols.

By convention, one file is created per derivated *DataStructure* object named
:file:`<DataStructure object>Interface.{{h,cxx}}`.


Exported methods
================

Constructors
------------

*DataStructure* objects must be wrapped by a ``boost::shared_ptr``.

The definition of the wrapper must reflect the inheritance of the underlying
C++ DataStructures. In the following example, ``FunctionInstance`` is derivated
from ``BaseFunctionInstance``. It is necessary to pass a Python ``Function``
object where a generic ``BaseFunction`` is expected.

.. note:: The constructors of the underlying *Instance* should not be available
    to the final user. That's why the definition should use ``no_init``.

To allow the serialization of the *DataStructure* objects using the Python
pickling mechanism, we need a constructor that accepts the *Jeveux* name.
The final user must not call this constructor.

For the creation of the *DataStructure* from Python, we also need a *default*
constructor (with or without any argument).

.. note:: These constructors are defined using factory functions by
    templating ``initFactoryPtr``.


Examples
--------

In this simple example one defines a *default* constructor (without argument)
and the constructor used during unpickling that accepts the *Jeveux* name:

.. code-block:: c++

    void exportFunctionToPython()
    {
        using namespace boost::python;
        ...

        class_< FunctionInstance, FunctionInstance::FunctionPtr,
                bases< BaseFunctionInstance > > ( "Function", no_init )
            .def( "__init__", make_constructor(
                &initFactoryPtr< FunctionInstance >) )
            .def( "__init__", make_constructor(
                &initFactoryPtr< FunctionInstance,
                                 std::string >) )
            .def( "setValues", &FunctionInstance::setValues )
            ...
        ;
    }

A more complex example where the constructor needs another object. So the
*default* constructor needs a pointer on a :class:`~code_aster.Objects.Model`
and another that takes the *Jeveux* name and this pointer:

.. code-block:: c++

    void exportElementaryCharacteristicsToPython()
    {
        using namespace boost::python;

        class_< ElementaryCharacteristicsInstance, ElementaryCharacteristicsInstance::ElementaryCharacteristicsPtr,
                bases< DataStructure > > ( "ElementaryCharacteristics", no_init )
            .def( "__init__", make_constructor(
                &initFactoryPtr< ElementaryCharacteristicsInstance,
                                 ModelPtr >) )
            .def( "__init__", make_constructor(
                &initFactoryPtr< ElementaryCharacteristicsInstance,
                                 std::string,
                                 ModelPtr >) )
        ;
    };


Other methods
-------------

See :ref:`devguide-recommendations` for methods with default arguments.


Pickling support
================

See :py:mod:`code_aster.Helpers.Serializer` module for the serialization
management.

- Delegated to Python objects.

- Constructors arguments defined by :py:meth:`__getinitargs__` implemented in
  :py:mod:`code_aster.Objects.DataStructure` for most of the classes.

  Example: :py:class:`~code_aster.Objects.ElementaryCharacteristics` defines
  its own arguments.
  :py:meth:`~code_aster.Objects.ElementaryCharacteristics.__getinitargs__`
  returns a tuple with two elements: the *Jeveux* object name and the
  :py:class:`~code_aster.Objects.Model` that are passed to the constructor.

- To restore the internal state of the object, subclasses should defined their
  own :py:meth:`__getstate__` and :py:meth:`__setstate__` methods.

  Example: :py:class:`~code_aster.Objects.Model` does not take its support
  :py:class:`~code_aster.Objects.Mesh` as argument in its constructor. So it is
  saved by :py:meth:`__getstate__` and restored by :py:meth:`__setstate__`.

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

.. note:: The constructors of the underlying *Instance* should not be available
    to the final user. That's why the definition should use ``no_init``.

To allow the serialization of the *DataStructure* objects using the Python
pickling mechanism, we need a constructor that accepts the *Jeveux* name.
The final user must not call this constructor.

For the creation of the *DataStructure* from Python, we also need a *default*
constructor (with or without any argument).

.. note:: These constructors are defined using factory functions, named
    ``make<DataStructure>()`` and ``make<DataStructure>Jeveux()``.


Example
-------

.. code-block:: c++

    static FunctionPtr makeFunction()
    {
        return FunctionPtr( new FunctionInstance() );
    }

    static FunctionPtr makeFunctionJeveux( const std::string& jeveuxName )
    {
        return FunctionPtr( new FunctionInstance(jeveuxName) );
    }

    void exportFunctionToPython()
    {
        using namespace boost::python;
        ...

        class_< FunctionInstance, FunctionInstance::FunctionPtr,
                bases< BaseFunctionInstance > > ( "Function", no_init )
            .def( "__init__", make_constructor(makeFunction) )
            .def( "__init__", make_constructor(makeFunctionJeveux) )
            .def( "setValues", &FunctionInstance::setValues )
            ...
        ;
    }


Other methods
-------------

See :ref:`devguide-recommendations` for methods with default arguments.


Pickling support
================

See :py:mod:`code_aster.RunManager.Pickling` module for the serialization
management.

- Delegated to Python objects.

- Constructors arguments defined by :py:meth:`__getinitargs__` implemented in
  :py:mod:`code_aster.Objects.DataStructure` for most of the classes.

  Example: :py:class:`~code_aster.Objects.ElementaryMatrix` defines its own
  arguments.

- If needed, subclasses should defined their own :py:meth:`__getstate__`
  and :py:meth:`__setstate__` methods.

  Example: :py:class:`~code_aster.Objects.Model`.

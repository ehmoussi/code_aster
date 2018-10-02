.. _devguide-recommendations:

***********************
Recommendations / howto
***********************


Members naming conventions
==========================

.. todo::
    Start a glossary for members names.

Reuse existing names in newly created objects. Have a look to the :ref:`genindex` page
should give some ideas.

One can also search for names in the :ref:`devguide-objects_datastructure` page.


Default arguments in Boost Interface
====================================

When a C++ method has default arguments, the number of these arguments must be
explicitly described by the boost wrapper.

See as example :meth:`StaticNonLinearAnalysisInstance.addBehaviourOnElements`
and its interface in :file:`bibcxx/PythonBindings/StaticNonLinearAnalysisInterface.cxx`.
The macro generates a wrapper with between 1 and 2 arguments.

.. code-block:: c++

    BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS(addBehaviourOnElements_overloads,
        addBehaviourOnElements, 1, 2)

    void exportStaticNonLinearAnalysisToPython()
    {
        using namespace boost::python;

        class_< StaticNonLinearAnalysisInstance, StaticNonLinearAnalysisPtr >
            ( "StaticNonLinearAnalysis", no_init )
            .def( "addBehaviourOnElements",
                  &StaticNonLinearAnalysisInstance::addBehaviourOnElements,
                  addBehaviourOnElements_overloads())


Source: `Boost Python Overloads <http://www.boost.org/doc/libs/1_65_1/libs/python/doc/html/reference/function_invocation_and_creation/boost_python_overloads_hpp.html#function_invocation_and_creation.boost_python_overloads_hpp.macros>`_.


How to return different types from a single boost ``function::python``
======================================================================

The situation is as follows: we want to return different types from a single
``boost::python`` function.

On the C++ side, we have 2 member functions of the class ``MechanicalModeContainerInstance``
with different names and which return different types:

.. code-block:: c++

    AssemblyMatrixDisplacementDoublePtr getDisplacementStiffnessMatrix()
    AssemblyMatrixTemperatureDoublePtr getTemperatureStiffnessMatrix()


We want to interface these 2 functions by only one ``getStiffnessMatrix`` on the
python side but which returns the 2 different types according to the case.

To do this, we use the ``boost::variant`` type to store both types returned by the 2 functions.

.. code-block:: c++

    typedef boost::variant< AssemblyMatrixDisplacementDoublePtr,
                            AssemblyMatrixTemperatureDoublePtr > MatrixVariant;


Then, we have to write a ``getStiffnessMatrix`` function that returns one or the
other type depending on the case but storing it in a ``boost::variant``.
This function will become a member function of the python class :py:class:`code_aster.Objects.MechanicalModeContainer` so the C++ function
must take as argument a ``MechanicalModeContainerPtr``.

.. code-block:: c++

    MatrixVariant getStiffnessMatrix( const MechanicalModeContainerPtr self )
    {
        auto mat1 = self->getDisplacementStiffnessMatrix();
        if( mat1 != nullptr )
            return MatrixVariant( mat1 );
        auto mat2 = self->getTemperatureStiffnessMatrix();
        return MatrixVariant( mat2 );
    };


In the boost::python interface of the ``MechanicalModeContainer`` class, we must add the function:

.. code-block:: c++

    .def( "getStiffnessMatrix", &getStiffnessMatrix )

Finally, we add the following 3 lines that allow ``boost::python`` to perform type conversions between the variant and the underlying types:

.. code-block:: c++

    to_python_converter< MatrixVariant, VariantToObject< MatrixVariant > >();
    implicitly_convertible< AssemblyMatrixDisplacementDoublePtr, MatrixVariant >();
    implicitly_convertible< AssemblyMatrixTemperatureDoublePtr, MatrixVariant >();


Converting Macro-Commands
=========================

Legacy Macro-commands do not work as is.

#. There is no need to define an executor manually.
   Default :class:`~code_aster.Commands.ExecuteCommand.ExecuteMacro` is just
   adapted by :mod:`code_aster.Commands.operator` using the right catalog
   description.

#. The body of the macro-command, the ``ops()`` function, is automatically
   called by the :meth:`~code_aster.Commands.ExecuteCommand.ExecuteMacro.run`
   factory.

#. Results of macro-commands are created directly by the ``ops()`` function
   (called by ``exec_()``). ``create_result()`` method does nothing else
   registering the additional results (declared with ``CO()``).

#. The ``ops()`` function must now returns the result object it creates.


Required changes
----------------

- The ``ops()`` function returned an exit code as integer.

  Now, it must return the created result object, or *None* if there is not.

- In code_aster legacy the keywords arguments passed to ``ops()`` contained
  all existing keywords, eventually with *None* value.

  Now, only the user keywords + the default keywords are passed.
  So, only compulsory keywords and those having a default value can be arguments
  of the ``ops()`` function.
  If needed, these arguments may be wrapped by ``_F()`` that provides a ``[]``
  operator that returns *None* if a keyword does not exist.

  Example:

  .. code-block:: python

        def my_macro_ops(INFO, **kwargs):
            """..."""
            kwargs = _F(kwargs)
            para = kwargs['NOM_PARA']  # no failure even if the keyword does not exist

- Tests on DataStructures types must be changed.
  For example:

  Replace ``AsType(obj) is fonction_sdaster``, ``type(obj) is fonction_sdaster``
  or ``isinstance(obj, fonction_sdaster)``

  by ``obj.getType() == "FONCTION"``

- Object ``MCLIST`` does not exist anymore. List of factor keywords is just a
  *list* or a *tuple*.

  Just use :func:`~code_aster.Utilities.force_list` to ensure to have a list
  even if the user passed only one occurrence.

  Replace ``POUTRE.List_F()`` by ``force_list(POUTRE)``.

- Usage of logical units: See :mod:`code_aster.RunManager.LogicalUnit`.

- Additional results (**CO()** objects):

  They must be registered with
  :meth:`~code_aster.Commands.ExecuteCommand.ExecuteMacro.register_result`.
  It replaces *DeclareOut()* but must be called **after** the result creation.

  .. code-block:: diff

        -          self.DeclareOut('num', numeddl)
        +          # self.DeclareOut('num', numeddl)
                   num = NUME_DDL(MATR_RIGI=_a, INFO=info)
        +          self.register_result(num, numeddl)


Parallel specific DataStructures
================================

Q: How to pass a :py:class:`code_aster.Objects.ParallelMesh` to a command?

A: The solution is in "a :py:class:`code_aster.Objects.ParallelMesh` is a :py:class:`code_aster.Objects.Mesh`". It is just necessary to eclare a
DataStructure is the Python command description (*catalog*) that matches the
same type.
Example: :py:meth:`code_aster.Objects.ParallelMesh.getType()`
returns ``MAILLAGE_P``, so one defines:

.. code-block:: python

    class maillage_p(maillage_sdaster):
        pass



Commons errors
==============

- The compilation works but ``waf install_debug`` ends with
  ``stderr: Segmentation fault`` during the compilation of elements catalogs.

  **Explanation**: It may be an error in a Python function called from a C or
  Fortran function.
  Check it by manually importing the module in a Python interpreter:

  .. code-block:: sh

      $ cp ../src/build/debug/catalo/cata_ele.ojb fort.4
      $ python
      >>> import code_aster
      >>> code_aster.init(CATALOGUE={"FICHIER": "CATAELEM", "UNITE": 4})
      >>> from code_aster.Commands import MAJ_CATA
      >>> MAJ_CATA(ELEMENT={})
      >>> exit()

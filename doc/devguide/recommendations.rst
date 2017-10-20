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

# coding: utf-8

from libcpp.string cimport string

cdef extern from "DataFields/FieldOnNodes.h":

    cdef cppclass FieldOnNodesInstance[ValueType]:

        FieldOnNodesInstance( string name )
        ValueType& operator[]( int i )
        bint printMEDFormat( string pathFichier )
        bint updateValuePointers()

    cdef cppclass FieldOnNodes[ValueType]:

        FieldOnNodes()
        FieldOnNodes( string name )
        FieldOnNodesInstance[ValueType]* getInstance()
        void copy( FieldOnNodes[ValueType]& other )
        bint isEmpty()

ctypedef FieldOnNodes[double] cFieldOnNodesDouble

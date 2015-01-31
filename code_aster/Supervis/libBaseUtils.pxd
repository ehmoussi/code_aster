# common utilities

from libc.stdio cimport printf, fflush, stdout
from libc.stdlib cimport malloc
from libc.string cimport memcpy
from cpython.string cimport PyString_AsString


cdef void copyToFStr( char* dest, pystring, unsigned int str_size )

cdef char** to_cstring_array( list_str )

cdef double* to_cdouble_array( list_dble )

cdef long* to_clong_array( list_long )

cdef void to_fstring_array( list_str, int str_size, char*** ret )

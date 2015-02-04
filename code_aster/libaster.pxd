"""
Definition of the symbols of libaster that will be wrapped from Cython
"""

from libc.stdlib cimport free

ctypedef unsigned int   STRING_SIZE
ctypedef long           INTEGER

# used to pass pointers in cdef
ctypedef long           Addr


cdef extern from "aster_init.h":
    void initAsterModules()

cdef extern from "shared_vars.h":
    void register_sh_jeveux_status( int )

cdef extern from "aster_utils.h":
    char* MakeCStrFromFStr( char *, STRING_SIZE )

    void CopyCStrToFStr( char* dest, char* src, STRING_SIZE size )

# certainly better than calling aster_utils.FreeStr
cdef inline void FreeStr( void* pointer ):
    free( pointer )


cdef extern from "aster_fort.h":
    void ibmain_()

    void debut_()

    void execop_( INTEGER* numOp )

    void opsexe_( INTEGER* numOp )

    void jedetr_( char* name, STRING_SIZE lname )

    void jeexin_( char* name, INTEGER* iret, STRING_SIZE lname )

    void jeveuoc_( char* name, char* mode, void* pointer,
                   STRING_SIZE lname, STRING_SIZE lmode )

    void wkvectc_( char *name, char *param, INTEGER* size, void* pointer,
                   STRING_SIZE lname, STRING_SIZE lparam )

    void jelira_( char* name, char* param, INTEGER* ival, char* cval,
                   STRING_SIZE lname, STRING_SIZE lparam, STRING_SIZE lcval )

    void jenuno_( char* cval, char* name,
                  STRING_SIZE lcval, STRING_SIZE lname )

    void jenonu_( char* cval, INTEGER* num, STRING_SIZE lcval )

    void utimsd_( INTEGER* unit, INTEGER* niv, INTEGER* lattr, INTEGER* lcont,
                  char* string, INTEGER* pos, char* base, char* perm,
                  STRING_SIZE lstr, STRING_SIZE lbase, STRING_SIZE lperm )

    # char functions: the first two arguments is the result
    void jexnum_( char* cret, STRING_SIZE lcret, char* coll, INTEGER* i,
                  STRING_SIZE lcoll )
    void jexnom_( char* cret, STRING_SIZE lcret, char* coll, char* obj,
                  STRING_SIZE lcoll, STRING_SIZE lobj )


# wrappers for string arguments
cdef inline void jedetr( char* name ):
    jedetr_( name, len( name ) )

cdef inline void jeexin( char* name, INTEGER* iret ):
    jeexin_( name, iret, len( name ) )

cdef inline void jeveuoc( char* name, char* mode, void* pointer ):
    jeveuoc_( name, mode, pointer, len( name ), len( mode ) )

cdef inline void wkvectc( char *name, char *param, INTEGER* size, void* pointer ):
    wkvectc_( name, param, size, pointer, len( name ), len( param ) )

cdef inline void jelira( char* name, char* param, INTEGER* ival, char* cval ):
    jelira_( name, param, ival, cval, len( name ), len( param ), len( cval ) )

cdef inline void jenuno( char* cval, char* name ):
    jenuno_( cval, name, len( cval ), len( name ) )

cdef inline void jenonu( char* cval, INTEGER* num ):
    jenonu_( cval, num, len( cval ), )

# function: the first argument is the result
cdef inline void jexnum( char* cret, char* coll, INTEGER* i ):
    jexnum_( cret, len( cret ), coll, i, len( coll ) )

cdef inline void jexnom( char* cret, char* coll, char* obj ):
    jexnom_( cret, len( cret ), coll, obj, len( coll ), len( obj ) )

cdef inline utimsd( INTEGER* unit, INTEGER* niv, INTEGER* lattr, INTEGER* lcont,
                    char* string, INTEGER* pos, char* base, char* perm ):
    utimsd_( unit, niv, lattr, lcont, string, pos, base, perm,
             len( string ), len( base ), len( perm ) )

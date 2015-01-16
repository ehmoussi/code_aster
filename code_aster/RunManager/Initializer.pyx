# coding: utf-8

cimport cInitializer


def init( int mode ):
    """Initialize Code_Aster & its memory manager"""
    cInitializer.asterInitialization( mode )

def finalize():
    """Finalize Code_Aster execution"""
    cInitializer.asterFinalization()

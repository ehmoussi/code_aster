# coding: utf-8

cimport cInitializer


def init( int mode ):
    cInitializer.asterInitialization( mode )

def finalize():
    cInitializer.asterFinalization()

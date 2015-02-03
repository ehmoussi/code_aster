/**
 * @file Exceptions.cxx
 * @brief Implementation of Exceptions
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <iostream>
#include <stdexcept>
#include <typeinfo>
#include <string>

#include "Exceptions.h"

void AsterCythonCustomException()
{
    try
    {
        if ( PyErr_Occurred() )
        ;
        else
        throw;
    }
    catch ( const std::bad_alloc& exn )
    {
        PyErr_SetString( PyExc_MemoryError, exn.what() );
    }
    catch ( const std::bad_cast& exn )
    {
        PyErr_SetString( PyExc_TypeError, exn.what() );
    }
    catch ( const std::domain_error& exn )
    {
        PyErr_SetString( PyExc_ValueError, exn.what() );
    }
    catch ( const std::invalid_argument& exn )
    {
        PyErr_SetString( PyExc_ValueError, exn.what() );
    }
    catch ( const std::ios_base::failure& exn )
    {
        PyErr_SetString( PyExc_IOError, exn.what() );
    }
    catch ( const std::out_of_range& exn )
    {
        PyErr_SetString( PyExc_IndexError, exn.what() );
    }
    catch ( const std::overflow_error& exn )
    {
        PyErr_SetString( PyExc_OverflowError, exn.what() );
    }
    catch ( const std::range_error& exn )
    {
        PyErr_SetString( PyExc_ArithmeticError, exn.what() );
    }
    catch ( const std::underflow_error& exn )
    {
        PyErr_SetString( PyExc_ArithmeticError, exn.what() );
    }
    catch ( const std::exception& exn )
    {
        PyErr_SetString( PyExc_RuntimeError, exn.what() );
    }
    catch ( std::string error )
    {
        PyErr_SetString( PyExc_RuntimeError, error.c_str() );
    }
    catch (...)
    {
        PyErr_SetString( PyExc_RuntimeError, "Unknown exception" );
    }
};

void _raiseException()
{
    throw std::runtime_error( "Code_Aster exception raised" );
    return;
};

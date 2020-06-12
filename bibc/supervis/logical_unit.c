/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

/* person_in_charge: mathieu.courtois@edf.fr */

/*
 * C interface to LogicalUnitFile.
 */

 #include <stdlib.h>

#include "Python.h"
#include "aster.h"
#include "aster_core_module.h"
#include "aster_module.h"
#include "shared_vars.h"


/*
 * Functions based on JDC object.
 */
int openLogicalUnitFile(const char* name, const int type, const int access)
{
    /*
     * Open and reserve a logical unit.
     */
    PyObject *pylu, *res, *unit;
    int number;

    pylu = GetJdcAttr("logical_unit");
    res = PyObject_CallMethod(pylu, "open", "sll", name, type, access);
    if (res == NULL) {
        MYABORT("Error calling `LogicalUnitFile.open`.");
    }
    unit = PyObject_GetAttrString(res, "unit");
    if (PyLong_Check(unit)) {
        number = (int)PyLong_AsLong(unit);
    } else {
        number = -1;
    }

    Py_XDECREF(res);
    Py_XDECREF(pylu);
    return number;
}

void releaseLogicalUnitFile(const int logicalUnit)
{
    /*
     * Release a logical unit.
     */
    PyObject *pylu, *res;

    pylu = GetJdcAttr("logical_unit");
    res = PyObject_CallMethod(pylu, "release_from_number", "l", logicalUnit);
    if (res == NULL) {
        MYABORT("Error calling `LogicalUnitFile.release_from_number`.");
    }

    Py_XDECREF(res);
    Py_XDECREF(pylu);
    return;
}

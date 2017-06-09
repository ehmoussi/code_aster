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
/* Minimal main program -- everything is loaded from the library */

/*! \mainpage Code_Aster Index Page
 *
 * \section intro_sec Introduction
 *
 * This is the introduction.
 *
 * \section install_sec Installation
 *
 * \subsection step1 Step 1: Opening the box
 *
 * etc...
 */

/* NOTE: 
 *  Since Python may define some pre-processor definitions which affect the
 *  standard headers on some systems, you must include "Python.h" before any
 *  standard headers are included.
 *  The warning on _POSIX_C_SOURCE redefinition must not occur.
 * 
 *  source: http://docs.python.org/c-api/intro.html
 */
#include "Python.h"
#include "aster.h"
#include "aster_module.h"
#include "aster_core_module.h"
#include "aster_fonctions_module.h"
#include "med_aster_module.h"

extern DL_EXPORT(int) Py_Main();

#ifndef _MAIN_
#define _MAIN_ main
#endif

int
_MAIN_(argc, argv)
    int argc;
    char **argv;
{
    int ierr;

    PyImport_AppendInittab("_aster_core", init_aster_core);
    PyImport_AppendInittab("aster", initaster);

    /* Module définissant des opérations sur les objets fonction_sdaster */
    PyImport_AppendInittab("aster_fonctions", initaster_fonctions);
#ifndef _DISABLE_MED
    PyImport_AppendInittab("med_aster", initmed_aster);
#endif
    ierr = Py_Main(argc, argv);
    return ierr;
}

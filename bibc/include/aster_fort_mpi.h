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

#ifndef ASTER_FORT_MPI_H
#define ASTER_FORT_MPI_H

#include "aster.h"
#include "aster_mpi.h"

/* ******************************************************
 *
 * Interfaces of fortran subroutines called from C/C++.
 *
 * ******************************************************/

#ifdef __cplusplus
extern "C" {
#endif

#define CALL_ASMPI_CHECK(a) CALLP(ASMPI_CHECK,asmpi_check,a)
extern void DEFP(ASMPI_CHECK,asmpi_check,ASTERINTEGER *);

#define CALL_ASMPI_WARN(a) CALLP(ASMPI_WARN,asmpi_warn,a)
extern void DEFP(ASMPI_WARN,asmpi_warn,ASTERINTEGER *);


#ifdef __cplusplus
}
#endif

/* FIN ASTER_FORT_MPI_H */
#endif

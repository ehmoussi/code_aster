! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine haslib(libraz, iret)
! person_in_charge: mathieu.courtois at edf.fr
!
!
    implicit none
#include "asterf.h"
#include "asterfort/assert.h"
    character(len=*) :: libraz
    integer :: iret
!--------------------------------------------------------------
! BUT : CONNAITRE LA DISPONIBILITE D'UNE LIBRAIRIE EXTERNE
!
! IN : LIBRAI :
!     /'MUMPS'  : POUR DEMANDER LA FACTORISATION DU PRECONDITIONNEUR
!     /'PETSC'  : POUR DEMANDER LA RESOLUTION ITERATIVE
!     /'HDF5'   : PRESENCE DE LIBHDF5
!     /'MED'    : PRESENCE DE MED
!
! OUT : IRET    : CODE_RETOUR :
!            1  : INSTALLE
!            0  : PAS INSTALLE
!---------------------------------------------------------------
    character(len=5) :: librai
!---------------------------------------------------------------
    librai = libraz
    iret=0
    if (librai .eq. 'MUMPS') then
#ifdef _HAVE_MUMPS
        iret=1
#endif
    else if (librai.eq.'PETSC') then
#ifdef _HAVE_PETSC
        iret=1
#endif
    else if (librai.eq.'HDF5') then
#ifndef _DISABLE_HDF5
        iret=1
#endif
    else if (librai.eq.'MED') then
#ifndef _DISABLE_MED
        iret=1
#endif
    else
        ASSERT(.false.)
    endif
end subroutine

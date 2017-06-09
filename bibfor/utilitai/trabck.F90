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

subroutine trabck(cmess, iexit)
! ----------------------------------------------------------------------
! IMPRIME LA REMONTEE DES APPELS
!
! IN  CMESS  : MESSAGE D'INFORMATION
! IN  IEXIT  : CONDITION DE SORTIE DE LA ROUTINE DE TRACEBACK
!              AVEC LE COMPILO INTEL <0 ON REDONNE LA MAIN
! ----------------------------------------------------------------------
!
!
! aslint: disable=W1304
#include "asterf.h"
!
#if _USE_INTEL_IFORT && HAVE_TRACEBACKQQ == 1 && !defined(IGNORE_DURING_ASLINT)
    use ifcore
    implicit none
    character(len=*) :: cmess
    integer(kind=4) :: iexit
!
    call tracebackqq(string=cmess, user_exit_code=iexit)
!
#elif HAVE_BACKTRACE == 1 && !defined(IGNORE_DURING_ASLINT)
    implicit none
#include "asterc/print_trace.h"
    character(len=*) :: cmess
    integer(kind=4) :: iexit
!   Dummy argument if HAVE_TRACEBACKQQ is not defined
    integer :: dummy
    dummy = len(cmess) + iexit
!
    call print_trace()
!
#else
    implicit none
    character(len=*) :: cmess
    integer(kind=4) :: iexit
!   Dummy argument if HAVE_TRACEBACKQQ is not defined
    integer :: dummy
    dummy = len(cmess) + iexit
!   do not call utmess (recursivity)
    write(6,*) 'Traceback is not provided by the compiler'
!
#endif
!
end subroutine

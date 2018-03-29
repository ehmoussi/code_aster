! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine lcPrepareStrain(option, typmod,&
                             neps , epsth , depsth,&
                             epsm , deps)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
!
character(len=16), intent(in) :: option
character(len=8), intent(in) :: typmod(*)
integer, intent(in) :: neps
real(kind=8), intent(in) :: epsth(neps), depsth(neps)
real(kind=8), intent(inout) :: epsm(neps), deps(neps)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Prepare strains (substracting "thermic" strains to total strains to
! get mechanical part)
!
! --------------------------------------------------------------------------------------------------
!
! In  option            : required option : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
! In  typmod(2)         : type of modelisation ex: 1:3D, 2:INCO
! In  neps             : number of components of strains
! In  epsth            : thermic strains at beginning of current step time
! In  depsth           : increment of thermic strains during current step time
! Inout  epsm          : In : total strains at beginning of current step time
!                        Out : mechanical strains at beginning of current step time
! Inout  deps          : In : increment of total strains during current step time
!                        Out : increment of mechanical strains during current step time

!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: stran(9), dstran(9)
    character(len=16) :: defo_comp
    aster_logical :: l_pred, l_czm
!
! --------------------------------------------------------------------------------------------------
!
    call r8inir(neps, 0.d0, dstran, 1)
    call r8inir(neps, 0.d0, stran, 1)
!
    l_pred = option(1:9).eq. 'RIGI_MECA'
    l_czm = typmod(2).eq.'ELEMJOIN'
!
    if ((neps .eq. 6) .or. (neps .eq. 4)) then
        if (l_pred) then
            call r8inir(6, 0.d0, dstran, 1)
        else
            call dcopy(neps, deps, 1, dstran, 1)
            call daxpy(neps, -1.d0, depsth, 1, dstran,1)
        endif
        call dcopy(neps, epsm, 1, stran, 1)
        call daxpy(neps, -1.d0, epsth, 1, stran, 1)
    else if ( (neps .eq. 3) .and. l_czm) then
! No thermic strains for cohesive elements
        if (l_pred) then
            call r8inir(neps, 0.d0, dstran, 1)
        else
            call dcopy(neps, deps, 1, dstran, 1)
        endif
        call dcopy(neps, epsm, 1, stran, 1)
    else
        ASSERT(.false.)
    endif
!
! epsm and deps become mechanical strains
    call dcopy(neps, stran, 1, epsm, 1)
    call dcopy(neps, dstran, 1, deps, 1)
!
end subroutine

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

subroutine dmatmc(fami, mater, time, poum, ipg,&
                  ispg, repere, xyzgau, nbsig, d,&
                  l_modi_cp)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dmat3d.h"
#include "asterfort/dmatcp.h"
#include "asterfort/dmatdp.h"
#include "asterfort/lteatt.h"
!
!
    character(len=*), intent(in) :: fami
    integer, intent(in) :: mater
    real(kind=8), intent(in) :: time
    character(len=*), intent(in) :: poum
    integer, intent(in) :: ipg
    integer, intent(in) :: ispg
    real(kind=8), intent(in) :: repere(7)
    real(kind=8), intent(in) :: xyzgau(3)
    integer, intent(in) :: nbsig
    real(kind=8), intent(out) :: d(nbsig, nbsig)
    aster_logical, optional, intent(in) :: l_modi_cp
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Hooke matrix for iso-parametric elements
!
! --------------------------------------------------------------------------------------------------
!
! In  fami      : Gauss family for integration point rule
! In  mater     : material parameters
! In  time      : current time
! In  poum      : '-' or '+' for parameters evaluation (previous or current temperature)
! In  ipg       : current point gauss
! In  ispg      : current "sous-point" gauss
! In  repere    : definition of basis for orthotropic elasticity
! In  xyzgau    : coordinates for current Gauss point
! In  nbsig     : number of components for stress
! Out d         : Hooke matrix
! In  l_modi_cp : using plane strain Hooke matrix for plane stress case
!
! --------------------------------------------------------------------------------------------------
!
    if (lteatt('DIM_TOPO_MAILLE','3')) then
        ASSERT(nbsig.eq.6)
        call dmat3d(fami, mater, time, poum, ipg,&
                    ispg, repere, xyzgau, d)
    else if (lteatt('FOURIER','OUI')) then
        ASSERT(nbsig.eq.6)
        call dmat3d(fami, mater, time, poum, ipg,&
                    ispg, repere, xyzgau, d)
    else if (lteatt('C_PLAN','OUI')) then
        ASSERT(nbsig.eq.4)
        call dmatcp(fami, mater, time, poum, ipg,&
                    ispg, repere, d)
        if (present(l_modi_cp)) then
            ASSERT(l_modi_cp)
            call dmatdp(fami, mater, time, poum, ipg,&
                        ispg, repere, d)
        else
            call dmatcp(fami, mater, time, poum, ipg,&
                        ispg, repere, d)
        endif
    else if (lteatt('D_PLAN','OUI').or. lteatt('AXIS','OUI')) then
        ASSERT(nbsig.eq.4)
        call dmatdp(fami, mater, time, poum, ipg,&
                    ispg, repere, d)
    else
        ASSERT(.false.)
    endif
!
end subroutine

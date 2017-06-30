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

!
!
#include "asterf_types.h"
!
! aslint: disable=W1504
!
interface 
    subroutine kitdec(kpi   , j_mater, ndim  ,&
                      yachai, yamec  , yate  , yap1  , yap2,&
                      defgem, defgep ,&
                      addeme, addep1 , addep2, addete,&
                      depsv , epsv   , deps  ,&
                      t     , dt     , grat  ,&
                      p1    , dp1    , grap1 ,&
                      p2    , dp2    , grap2 ,&
                      retcom)
        integer, intent(in) :: kpi
        integer, intent(in) :: j_mater
        integer, intent(in) :: ndim
        aster_logical, intent(out) :: yachai
        integer, intent(in) :: yamec
        integer, intent(in) :: yate
        integer, intent(in) :: yap1
        integer, intent(in) :: yap2
        real(kind=8), intent(in) :: defgem(*)
        real(kind=8), intent(in) :: defgep(*)
        integer, intent(in) :: addeme
        integer, intent(in) :: addep1
        integer, intent(in) :: addep2
        integer, intent(in) :: addete
        real(kind=8), intent(out) :: depsv
        real(kind=8), intent(out) :: epsv
        real(kind=8), intent(out) :: deps(6)
        real(kind=8), intent(out) :: t
        real(kind=8), intent(out) :: dt
        real(kind=8), intent(out) :: grat(ndim)
        real(kind=8), intent(out) :: p1
        real(kind=8), intent(out) :: dp1
        real(kind=8), intent(out) :: grap1(ndim)
        real(kind=8), intent(out) :: p2
        real(kind=8), intent(out) :: dp2
        real(kind=8), intent(out) :: grap2(ndim)
        integer, intent(out) :: retcom
    end subroutine kitdec
end interface 

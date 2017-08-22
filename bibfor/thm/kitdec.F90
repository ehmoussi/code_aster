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
! aslint: disable=W1504
! person_in_charge: sylvie.granet at edf.fr
!
subroutine kitdec(kpi   , ndim  , &
                  yachai, yamec  , yate  , yap1  , yap2,&
                  defgem, defgep ,&
                  addeme, addep1 , addep2, addete,&
                  depsv , epsv   , deps  ,&
                  t     , dt     , grat  ,&
                  p1    , dp1    , grap1 ,&
                  p2    , dp2    , grap2 ,&
                  retcom)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcva.h"
!
integer, intent(in) :: kpi
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
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Update unknowns
!
! --------------------------------------------------------------------------------------------------
!
! In  kpi          : current Gauss point
! In  ndim         : dimension of space (2 or 3)
! Out yachai       : .true. if weak coupled (mechanic/hydraulic)
! In  yamec        : 1 if mechanic dof
! In  yate         : 1 if thermic dof
! In  yap1         : 1 if first pressure dof
! In  yap2         : 1 if second pressure dof
! In  defgem       : generalized strains - At begin of current step
! In  defgep       : generalized strains - At end of current step
! In  addeme       : index of mechanic quantities in generalized tensors
! In  addep1       : index of first hydraulic quantities in generalized tensors
! In  addep2       : index of second hydraulic quantities in generalized tensors
! In  addete       : index of thermic quantities in generalized tensors
! Out depsv        : increment of mechanic strains (deviatoric part)
! Out epsv         : increment of mechanic strains (deviatoric part) at end of current step
! Out deps         : increment of mechanic strains (deviatoric part)
! Out t            : temperature at end of current step
! Out dt           : increment of temperature
! Out grat         : gradient of temperature
! Out p1           : first pressure at end of current step
! Out dp1          : increment of first pressure
! Out grap1        : gradient of first pressure
! Out p2           : second pressure at end of current step
! Out dp2          : increment of second pressure
! Out grap2        : gradient of second pressure
! Out retcom       : 1 if error, 0 otherwise
!
! --------------------------------------------------------------------------------------------------
!
    call calcva(kpi   , ndim  , &
                yachai, yamec , yate   , yap1  , yap2,&
                defgem, defgep,&
                addeme, addep1, addep2, addete,&
                depsv , epsv  , deps  ,&
                t     , dt    , grat  ,&
                p1    , dp1   , grap1 ,&
                p2    , dp2   , grap2 ,&
                retcom)
!
end subroutine

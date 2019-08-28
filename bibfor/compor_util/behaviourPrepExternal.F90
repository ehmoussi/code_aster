! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine behaviourPrepExternal(carcri  , typmod ,&
                                 nno     , npg    , ndim    ,&
                                 jv_poids, jv_func, jv_dfunc,&
                                 geom    , deplm  , ddepl   ,&
                                 coorga)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/lcegeo.h"
#include "asterfort/Behaviour_type.h"
!
real(kind=8), intent(in) :: carcri(*)
character(len=8), intent(in) :: typmod(2)
integer, intent(in) :: nno, npg, ndim
integer, intent(in) :: jv_poids, jv_func, jv_dfunc
real(kind=8), intent(in) :: deplm(ndim, nno), ddepl(ndim, nno)
real(kind=8), intent(in) :: geom(ndim, nno)
real(kind=8), intent(out) :: coorga(27,3)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Prepare external state variables
!
! --------------------------------------------------------------------------------------------------
!
! In  carcri           : parameters for comportment
! In  typmod           : type of modelisation
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  geom             : initial coordinates of nodes
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
! Out coorga           : coordinates of all integration points
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jvariext1, jvariext2
!
! --------------------------------------------------------------------------------------------------
!
    coorga               = r8nnem()
!
! - Get coded integers for external state variables
!
    jvariext1 = nint(carcri(IVARIEXT1))
    jvariext2 = nint(carcri(IVARIEXT2))
!
! - Compute intrinsic external state variables
!
    call lcegeo(nno     , npg      , ndim     ,&
                jv_poids, jv_func  , jv_dfunc ,&
                typmod  , jvariext1, jvariext2,&
                geom    , coorga   ,&
                deplm   , ddepl)
!
end subroutine

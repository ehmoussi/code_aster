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
subroutine lcegeo(nno     , npg      , ndim     ,&
                  jv_poids, jv_func  , jv_dfunc ,&
                  typmod  , jvariext1, jvariext2,&
                  geom    , coorga   ,&
                  deplm_  , ddepl_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/isdeco.h"
#include "asterfort/calcExternalStateVariable1.h"
#include "asterfort/calcExternalStateVariable2.h"
#include "asterfort/calcExternalStateVariable3.h"
#include "asterfort/calcExternalStateVariable4.h"
!
integer, intent(in) :: nno, npg, ndim
integer, intent(in) :: jv_poids, jv_func, jv_dfunc
character(len=8), intent(in) :: typmod(2)
integer, intent(in) :: jvariext1, jvariext2
real(kind=8), intent(in) :: geom(ndim, nno)
real(kind=8), intent(out) :: coorga(27,3)
real(kind=8), optional, intent(in) :: deplm_(ndim, nno), ddepl_(ndim, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Compute intrinsic external state variables
!
! --------------------------------------------------------------------------------------------------
!
! In  nno              : number of nodes 
! In  npg              : number of Gauss points 
! In  ndim             : dimension of problem (2 or 3)
! In  jv_poids         : JEVEUX adress for weight of Gauss points
! In  jv_func          : JEVEUX adress for shape functions
! In  jv_dfunc         : JEVEUX adress for derivative of shape functions
! In  typmod           : type of modelization (TYPMOD2)
! In  jvariext1        : first coded integer for external state variable
! In  jvariext2        : second coded integer for external state variable
! In  geom             : initial coordinates of nodes
! In  deplm            : displacements of nodes at beginning of time step
! In  ddepl            : displacements of nodes since beginning of time step
! Out coorga           : coordinates of all integration points
!
! --------------------------------------------------------------------------------------------------
!
    integer :: tabcod(60), variextecode(2)
!
! --------------------------------------------------------------------------------------------------
!
    tabcod(:) = 0
    variextecode(1) = jvariext1
    variextecode(2) = jvariext2
    call isdeco(variextecode, tabcod, 60)
!
! - Element size 1
!
    if (tabcod(ELTSIZE1) .eq. 1) then
        call calcExternalStateVariable1(nno     , npg    , ndim    ,&
                                        jv_poids, jv_func, jv_dfunc,&
                                        geom    , typmod )
    endif
!
! - Coordinates of Gauss points
!
    call calcExternalStateVariable2(nno    , npg   , ndim  ,&
                                    jv_func, &
                                    geom   , coorga)
!
! - Gradient of velocity
!
    if (tabcod(GRADVELO) .eq. 1) then
        call calcExternalStateVariable3(nno     , npg    , ndim    ,&
                                        jv_poids, jv_func, jv_dfunc,&
                                        geom    , deplm_ , ddepl_ )
    endif
!
! - Element size 2
!
    if (tabcod(ELTSIZE2) .eq. 1) then
        call calcExternalStateVariable4(nno     , npg   , ndim,&
                                        jv_dfunc,&
                                        geom    , typmod)
    endif
!
end subroutine

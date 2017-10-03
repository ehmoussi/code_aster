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
subroutine thmGetElemDime(l_vf     ,&
                          ndim     , nnos   , nnom  , nface,&
                          mecani   , press1 , press2 , tempe ,&
                          nddls    , nddlm  , nddlk  , nddlfa,&
                          nddl_meca, nddl_p1, nddl_p2,&
                          dimdep   , dimdef , dimcon , dimuel)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/thmGetGeneDime.h"
!
aster_logical, intent(in) :: l_vf
integer, intent(in) :: ndim, nnos, nnom, nface
integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
integer, intent(out) :: nddls, nddlm, nddlk, nddlfa
integer, intent(out) :: nddl_meca, nddl_p1, nddl_p2
integer, intent(out) :: dimdep, dimdef, dimcon, dimuel
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get dimensions about element
!
! --------------------------------------------------------------------------------------------------
!
! In  l_vf             : flag for finite volume
! In  mecani           : parameters for mechanic
! In  press1           : parameters for hydraulic (capillary pressure)
! In  press2           : parameters for hydraulic (gaz pressure)
! In  tempe            : parameters for thermic
! In  ndim             : dimension of element (2 ou 3)
! In  nnos             : number of nodes (not middle ones)
! In  nnom             : number of nodes (middle ones)
! In  nface            : number of faces (for finite volume)
! Out nddls            : number of dof at nodes (not middle ones)
! Out nddlm            : number of dof at nodes (middle ones)
! Out nddlk            : number of dof for element (bubble or finite volume)
! Out nddlfa           : number of dof on faces (for finite volume)
! Out nddl_meca        : number of dof for mechanical quantity
! Out nddl_p1          : number of dof for first hydraulic quantity
! Out nddl_p2          : number of dof for second hydraulic quantity
! Out dimdep           : dimension of generalized displacement vector
! Out dimdef           : dimension of generalized strains vector
! Out dimcon           : dimension of generalized stresses vector
! Out dimuel           : total number of dof for element
!
! --------------------------------------------------------------------------------------------------
!
    dimdep    = 0
    dimdef    = 0
    dimcon    = 0
    nddl_meca = 0
    nddl_p1   = 0
    nddl_p2   = 0
    if (mecani(1) .eq. 1) then
        nddl_meca      = ndim
    endif
    if (.not.l_vf) then
        if (press1(1) .eq. 1) then
            nddl_p1 = 1
        endif
        if (press2(1) .eq. 1) then
            nddl_p2 = 1
        endif
    endif
!
! - Get dimensions of generalized vectors
!
    call thmGetGeneDime(ndim     ,&
                        mecani   , press1 , press2 , tempe ,&
                        dimdep   , dimdef , dimcon )
!
! - Count dof
!
    if (l_vf) then
        nddls  = 0
        nddlfa = press1(1) + press2(1) + tempe(1)
        nddlm  = 0
        nddlk  = press1(1) + press2(1) + tempe(1)
        dimuel = nnos*nddls + nface*nddlfa + nddlk
    else     
        nddls  = mecani(1)*ndim + press1(1) + press2(1) + tempe(1)
        nddlfa = 0
        nddlm  = mecani(1)*ndim
        nddlk  = 0
        dimuel = nnos*nddls + nnom*nddlm + nddlk
    endif
!
end subroutine

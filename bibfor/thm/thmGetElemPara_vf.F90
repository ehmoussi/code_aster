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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine thmGetElemPara_vf(l_axi    , l_steady , l_vf     ,&
                             type_elem, ndim     ,&
                             mecani   , press1   , press2   , tempe  ,&
                             dimdef   , dimcon   , dimuel ,&
                             nno      , nnos     , nface    )
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/thmGetElemIntegration.h"
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetGeneDime.h"
#include "asterfort/thmGetElemRefe.h"
#include "asterfort/elrefe_info.h"
!
aster_logical, intent(out) :: l_axi, l_steady, l_vf
character(len=8), intent(out) :: type_elem(2)
integer, intent(out) :: ndim
integer, intent(out) :: mecani(5), press1(7), press2(7), tempe(5)
integer, intent(out) :: dimdef, dimcon, dimuel
integer, intent(out) :: nno, nnos, nface
!
! --------------------------------------------------------------------------------------------------
!
! THM - Initializations
!
! Get all parameters for current element - Finite volume version
!
! --------------------------------------------------------------------------------------------------
!
! Out l_axi            : flag is axisymmetric model
! Out l_vf             : flag for finite volume
! Out l_steady         : .true. for steady state
! Out type_elem        : type of element
! Out ndim             : dimension of element (2 ou 3)
! Out mecani           : parameters for mechanic
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Adress of first component in generalized strain vector
!                    (3) - Adress of first component in generalized stress vector
!                    (4) - Number of components for strains
!                    (5) - Number of components for stresses
! Out press1           : parameters for hydraulic (capillary pressure)
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Number of phases
!                    (3) - Adress of first component in generalized strain vector
!                    (4) - Adress of first component in vector of gen. stress for first phase 
!                    (5) - Adress of first component in vector of gen. stress for second phase
!                    (6) - Number of components for strains
!                    (7) - Number of components for stresses (for each phase)
! Out press2           : parameters for hydraulic (gaz pressure)
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Number of phases
!                    (3) - Adress of first component in generalized strain vector
!                    (4) - Adress of first component in vector of gen. stress for first phase 
!                    (5) - Adress of first component in vector of gen. stress for second phase
!                    (6) - Number of components for strains
!                    (7) - Number of components for stresses (for each phase)
! Out tempe            : parameters for thermic
!                    (1) - Flag if physic exists (1 if exists)
!                    (2) - Adress of first component in generalized strain vector
!                    (3) - Adress of first component in generalized stress vector
!                    (4) - Number of components for strains
!                    (5) - Number of components for stresses
! Out dimdef           : dimension of generalized strains vector
! Out dimcon           : dimension of generalized stresses vector
! Out dimuel           : total number of dof for element
! Out nno              : number of nodes (all)
! Out nnos             : number of nodes (not middle ones)
! Out nface            : number of faces (finite volume)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe, elref2
    integer :: dimdep, nddlfa, nddlk
!
! --------------------------------------------------------------------------------------------------
!

!
! - Get model of finite element
!
    call thmGetElemModel(l_axi, l_vf, l_steady, ndim, type_elem)
    ASSERT(l_vf)    
!
! - Get generalized coordinates
!
    call thmGetGene(l_steady, l_vf, ndim,&
                    mecani  , press1, press2, tempe)
!
! - Get dimensions of generalized vectors
!
    call thmGetGeneDime(ndim  ,&
                        mecani, press1, press2, tempe,&
                        dimdep, dimdef, dimcon)
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call elrefe_info(elrefe=elrefe, fami='RIGI', nno=nno, nnos=nnos)
    if (ndim .eq. 2) then
        nface = nnos
    elseif (ndim .eq. 3) then
        if (elrefe .eq. 'H27') then
            nface = 6
        else if (elrefe .eq. 'T9') then
            nface = 4
        else
            ASSERT(ASTER_FALSE)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Count dof
!
    nddlk  = press1(1) + press2(1) + tempe(1)
    nddlfa = press1(1) + press2(1) + tempe(1)
    dimuel = nface*nddlfa + nddlk
!
end subroutine

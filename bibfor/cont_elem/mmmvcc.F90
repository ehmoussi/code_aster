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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmmvcc(phase , l_pena_cont, &
                  nnl   , wpg        , ffl   , jacobi,&
                  jeu   , coefac     , dlagrc,&
                  vectcc)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
character(len=4), intent(in) :: phase
aster_logical, intent(in) :: l_pena_cont
integer, intent(in) :: nnl
real(kind=8), intent(in) :: wpg, ffl(9), jacobi
real(kind=8), intent(in) :: jeu, dlagrc, coefac
real(kind=8), intent(out) :: vectcc(9)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute vector for DOF [contact]
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase to compute
!                        'SANS' - No contact
!                        'ADHE' - Stick
!                        'GLIS' - Slip
! In  l_pena_cont      : flag for penalized contact
! In  nnl              : number of nodes with Lagrange multiplicators (contact and friction)
! In  wpg              : weight for current Gauss point
! In  ffl              : shape function for Lagrange dof
! In  jacobi           : jacobian at integration point
! In  jeu              : normal gap
! In  dlagrc           : increment of contact Lagrange from beginning of time step
! In  coefac           : coefficient for updated Lagrangian method (contact)
! Out vectcc           : vector for DOF [contact]
!
! --------------------------------------------------------------------------------------------------
!
    integer :: inoc
!
! --------------------------------------------------------------------------------------------------
!
    if (phase .eq. 'SANS') then
        do inoc = 1, nnl
            vectcc(inoc) = vectcc(inoc)-&
                           wpg*ffl(inoc)*dlagrc*jacobi/ coefac
        end do
    else
        if (l_pena_cont) then
            do inoc = 1, nnl
                vectcc(inoc) = vectcc(inoc)-&
                               wpg*ffl(inoc)*dlagrc*jacobi/coefac-&
                               wpg*ffl(inoc)*jeu*jacobi
            end do
        else
            do inoc = 1, nnl
                vectcc(inoc) = vectcc(inoc)-&
                               wpg*ffl(inoc)*jeu*jacobi
            end do
        endif
    endif
!
end subroutine

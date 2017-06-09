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

subroutine mmmvex(nnl, nbcps, ndexfr, vectff)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/isdeco.h"
    integer :: ndexfr
    integer :: nnl, nbcps
    real(kind=8) :: vectff(18)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! CALCUL DES VECTEURS - MODIFICATIONS EXCLUSION
!
! ----------------------------------------------------------------------
!
!
! IN  NNL    : NOMBRE DE NOEUDS PORTANT UN LAGRANGE DE CONTACT/FROTT
! IN  NBCPS  : NOMBRE DE COMPOSANTES/NOEUD DES LAGR_C+LAGR_F
! IN  NDEXFR : ENTIER CODE POUR EXCLUSION DIRECTION DE FROTTEMENT
! OUT VECTFF : VECTEUR ELEMENTAIRE LAGR_F
!
! ----------------------------------------------------------------------
!
    integer :: i, l, ii, nbcpf
    integer :: ndexcl(10)
!
! ----------------------------------------------------------------------
!
    nbcpf = nbcps - 1
!
! --- MODIFICATION DES TERMES SI EXCLUSION DIRECTION FROTT. SANS_NO_FR
!
    if (ndexfr .ne. 0) then
        call isdeco([ndexfr], ndexcl, 10)
        do i = 1, nnl
            if (ndexcl(i) .eq. 1) then
                do l = 1, nbcpf
                    if ((l.eq.2) .and. (ndexcl(10).eq.0)) then
                        goto 40
                    endif
                    ii = (i-1)*nbcpf+l
                    vectff(ii) = 0.d0
 40                 continue
                end do
            endif
        end do
    endif
!
end subroutine

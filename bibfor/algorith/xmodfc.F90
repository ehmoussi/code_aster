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

subroutine xmodfc(lact, nlact, nno, dfdic, dffc, ndim)
    implicit none
    
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"

! person_in_charge: daniele.colombo at ifpen.fr

    integer :: i, j, k
    integer :: lact(16), nlact(2), nno, ndim
    real(kind=8) :: dfdic(nno,3), dffc(16,3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT AVEC XFEM
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
!
! POUR LA FORMULATION AUX NOEUDS SOMMET,  SI UN NOEUD N'EST PAS ACTIF,
! ON REPARTI SES DFF EQUITABLEMENT SUR LES NOEUDS ACTIF
!
! ----------------------------------------------------------------------
!
! IN  NNO    : NOMBRE DE NOEUD DE L'ELEMENT PARENT
! IN LACT    : LITE DES LAGRANGES ACTIFS
! IN NLACT   : NOMBRE TOTAL DE LAGRANGES ACTIFS
! IN DFDIC   : GRADIENT DES FONCTION DE FORMES DE L'ELEMENT PARENT
! OUT DFFC   : GRADIENT DES FONCTION DE FORMES DU POINT DE CONTACT
!
! ----------------------------------------------------------------------

    call jemarq()
!
    do i = 1, nno
       do k = 1, ndim
          dffc(i,k)=dfdic(i,k)
       end do
    end do
    if (nlact(1) .lt. nno) then
       do i = 1, nno
          if (lact(i) .eq. 0) then
             do j = 1, nno
                if (i .ne. j .and. lact(j) .ne. 0) then
                   do k = 1, ndim
                      dffc(j,k)=dffc(j,k)+dffc(i,k)/nlact(1)
                   end do
                endif
             end do
             do k = 1, ndim
                dffc(i,k)= 0.d0
             end do
          endif
       end do
    endif
!
    if (nno .gt. 8) then
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine

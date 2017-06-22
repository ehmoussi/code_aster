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

subroutine avcdmx(nbvec, domtot, cudomx, vnormx, nbplan)
! person_in_charge: van-xuan.tran at edf.fr
    implicit   none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbvec, vnormx(2)
    real(kind=8) :: domtot(nbvec), cudomx
! ----------------------------------------------------------------------
! BUT: CALCULER LE MAX DES CUMULS DE DOMMAGE ET DETERMINER LE VECTEUR
!      NORMAL ASSOCIE.
! ----------------------------------------------------------------------
! ARGUMENTS :
!  NBVEC    IN   I  : NOMBRE DE VECTEURS NORMAUX.
!  DOMTOT   IN   R  : VECTEUR CONTENANT LES DOMMAGES TOTAUX (CUMUL)
!                     DE CHAQUE VECTEUR NORMAL.
!  VNORMX   OUT  I  : NUMERO DU VECTEUR NORMAL ASSOCIE AU MAX DES CUMULS
!                     DE DOMMAGE.
!  CUDOMX   OUT  R  : VALEUR DU MAX DES CUMULS DE DOMMAGE.
! ----------------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: ivect, nbplan
    real(kind=8) :: prec
!     ------------------------------------------------------------------
!234567                                                              012
!     ------------------------------------------------------------------
!
    call jemarq()
    prec=100.d0*r8prem()
!
    cudomx = 0.0d0
    vnormx(1) = 1
!
    nbplan = 1
!
!
    do ivect = 1, nbvec
        if (domtot(ivect) .gt. cudomx) then
            cudomx = domtot(ivect)
            vnormx(1) = ivect
        endif
    end do
!
! ON CHERCHE SI EXISTE DIFFERENT PLAN
    vnormx(2) = vnormx(1)
!
    do ivect = 1, nbvec
        if ((abs(domtot(ivect)-cudomx) .lt. prec ) .and. (ivect .ne. vnormx(1))) then
            nbplan = nbplan + 1
            vnormx(2) = ivect
        endif
!
    end do
!
    call jedema()
!
end subroutine

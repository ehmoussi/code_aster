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

subroutine xmoajo(jj, nfiss, itypx, ntypx)
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: jj, nfiss, itypx(*), ntypx(*)
!
! person_in_charge: samuel.geniaut at edf.fr
!
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM APPELEE PAR MODI_MODELE_XFEM (OP0113)
!
!    BUT : AJOUT DANS LE LIGREL D'UN ELEMENT X-FEM
!
! ----------------------------------------------------------------------
!
!
! IN/OUT  JJ     : ADRESSE DU TABLEAU DE TRAVAIL
! IN      NFISS : NOMBRE DE FISSURES "VUES" PAR L'ÉLÉMENT
! IN      ITYPX  : NUMERO DU TYPE D'ELEMENT X-FEM A AJOUTER
! IN      ITYPCX  : NUMERO DU TYPE D'ELEMENT X-FEM CONTACT A AJOUTER
! IN      ITYPEL : NUMERO DU TYPE D'ELEMENT CLASSIQUE
! IN/OUT  NTYPX  : NOMBRE DE NOUVEAUX ELEMENTS DE TYPE ITYPX
!
!
!
!
!
    call jemarq()
!
    ntypx(7) = ntypx(7) + 1
    if (nfiss .eq. 1) then
        if (zi(jj+1) .eq. -1) then
            zi(jj+5) = itypx(1)
            ntypx(1) = ntypx(1) + 1
        else if (zi(jj+2).eq.-1) then
            zi(jj+5) = itypx(2)
            ntypx(2) = ntypx(2) + 1
        else if (zi(jj+3).eq.-1) then
            zi(jj+5) = itypx(3)
            ntypx(3) = ntypx(3) + 1
        else if (zi(jj+1).eq.1) then
            zi(jj+5) = itypx(4)
            ntypx(4) = ntypx(4) + 1
        else if (zi(jj+1).eq.2) then
            zi(jj+5) = itypx(14)
            ntypx(15) = ntypx(15) + 1
        else if (zi(jj+2).eq.1) then
            zi(jj+5) = itypx(5)
            ntypx(5) = ntypx(5) + 1
        else if (zi(jj+3).eq.1) then
            zi(jj+5) = itypx(6)
            ntypx(6) = ntypx(6) + 1
        else
            ASSERT(.false.)
        endif
    else if (nfiss.gt.1) then
        if (zi(jj+1) .lt. 0) then
            zi(jj+5)= itypx(6-zi(jj+1))
            ntypx(7-zi(jj+1)) = ntypx(7-zi(jj+1)) + 1
        else if (zi(jj+1).ge.5) then
            zi(jj+5) = itypx(13+nfiss)
            ntypx(14+zi(jj+1)-4) = ntypx(14+nfiss) + 1
        else
            zi(jj+5)= itypx(9+zi(jj+1))
            ntypx(10+zi(jj+1)) = ntypx(10+zi(jj+1)) + 1
        endif
    endif
!
    call jedema()
end subroutine

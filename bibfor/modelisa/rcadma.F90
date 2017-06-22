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

subroutine rcadma(jmat, phenom, nomres, valres, icodre, iarret)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/rcvals.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    character(len=*) :: phenom, nomres
    integer :: iarret
    integer :: icodre
    integer :: jmat, valres
!
!     obtention des adresses des composantes d'un materiau metallurgique
!               de l'adresse d'une texture
!
!     arguments d'entree:
!        imate  : adresse du materiau code
!        phenom : nom du phenomene
!        nomres : nom des resultats (ex: trc, texture, ... )
!                 tels qu'il figurent dans la commande materiau
!
!     arguments de sortie:
!       valres  : adresse du .vale du listr8
!       icodre  : 0 si on a trouve, 1 sinon
! ----------------------------------------------------------------------
!
    integer :: lmat, icomp, ipi, ipif, iadzi, iazk24, nbk, ivalk, ik, nbr, nbc
    integer :: lfct, imate, nbmat
    parameter  ( lmat = 9 , lfct = 10)
    character(len=24) :: valk
    character(len=8) :: nomail
    character(len=32) :: nomphe
! DEB ------------------------------------------------------------------
!
    icodre = 1
    nomphe = phenom
!
    nbmat=zi(jmat)
    ASSERT(nbmat.eq.1)
    imate = jmat+zi(jmat+nbmat+1)
!
    do 10 icomp = 1, zi(imate+1)
        if (nomphe .eq. zk32(zi(imate)+icomp-1)) then
            ipi = zi(imate+2+icomp-1)
            goto 11
        endif
10  end do
!
!     -- SELON LA VALEUR DE IARRET ON ARRETE OU NON :
    if (iarret .ge. 1) then
        valk = nomphe
        call utmess('F+', 'CALCUL_46', sk=valk)
        if (iarret .eq. 1) then
            call tecael(iadzi, iazk24)
            nomail = zk24(iazk24-1+3)(1:8)
            valk = nomail
            call utmess('F+', 'CALCUL_47', sk=valk)
        endif
        call utmess('F', 'VIDE_1')
    endif
    goto 9999
!
11  continue
!
    nbr = zi(ipi)
    nbc = zi(ipi+1)
    nbk = zi(ipi+2)
    ivalk = zi(ipi+3)
    do 150 ik = 1, nbk
        if (nomres .eq. zk16(ivalk+nbr+nbc+ik-1)) then
            icodre = 0
            ipif = ipi + lmat + (ik-1)*lfct -1
            ASSERT(zi(ipif+9).eq.2)
            valres = zi(ipif )
            goto 9999
        endif
150  end do
!
    call rcvals(iarret, [icodre], 1, nomres)
!
9999  continue
!
end subroutine

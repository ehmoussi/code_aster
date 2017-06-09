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

subroutine fovern(vecnom, nbfonc, vecpro, ier)
    implicit none
#include "jeveux.h"
#include "asterfort/fonbpa.h"
#include "asterfort/fopro1.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: nbfonc, ier
    character(len=*) :: vecnom(nbfonc), vecpro(*)
!     VERIFICATION DE L'HOMOGENEITE DES PARAMETRES DES FONCTIONS
!     COMPOSANT UNE NAPPE
!     STOCKAGE DE CE PARAMETRE UNIQUE ET DES TYPES DE PROLONGEMENTS
!     ET D'INTERPOLATION DE CHAQUE FONCTION
!     ------------------------------------------------------------------
! IN  VECNOM: VECTEUR DES NOMS DES FONCTIONS
! IN  NBFONC: NOMBRE DE FONCTIONS
! OUT    VECPRO: VECTEUR DESCRIPTEUR DE LA NAPPE
!     ------------------------------------------------------------------
!     OBJETS SIMPLES LUS
!        CHNOM=VECNOM(I)//'.PROL'
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
    integer :: i, jprof, nbpf
    integer :: vali
    character(len=24) :: chnom
    character(len=24) :: valk(3)
    character(len=16) :: prolgd, interp, typfon, nompf(10)
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    chnom(20:24) = '.PROL'
    do 1 i = 1, nbfonc
        chnom(1:19) = vecnom(i)
        call jeveuo(chnom, 'L', jprof)
        call fopro1(zk24(jprof), 0, prolgd, interp)
        call fonbpa(chnom(1:19), zk24(jprof), typfon, 10, nbpf,&
                    nompf)
        call jelibe(chnom)
        if (nompf(1) .ne. 'TOUTPARA') then
            vecpro(7)=nompf(1)
            goto 2
        endif
 1  end do
    vali = nbfonc
    call utmess('E', 'UTILITAI8_1', si=vali)
    ier=ier+1
 2  continue
    do 3 i = 1, nbfonc
        chnom(1:19) = vecnom(i)
        call jeveuo(chnom, 'L', jprof)
        call fopro1(zk24(jprof), 0, prolgd, interp)
        call fonbpa(chnom(1:19), zk24(jprof), typfon, 10, nbpf,&
                    nompf)
        call jelibe(chnom)
        if (nompf(1) .ne. vecpro(7) .and. nompf(1) .ne. 'TOUTPARA') then
            valk (1) = vecnom(i)
            valk (2) = nompf(1)
            valk (3) = vecpro(7)
            call utmess('E', 'UTILITAI8_2', nk=3, valk=valk)
            ier=ier+1
        endif
        vecpro(7+2*i-1) = interp
        vecpro(7+2*i ) = prolgd
 3  end do
    call jedema()
end subroutine

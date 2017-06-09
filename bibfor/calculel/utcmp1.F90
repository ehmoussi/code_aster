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

subroutine utcmp1(nomgd, mcfac, iocc, nomcmp, ivari, nom_vari)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/lxliis.h"
#include "asterfort/utmess.h"
    integer :: iocc
    character(len=8) :: nomgd, nomcmp
    character(len=*) :: mcfac
    character(len=16) :: nom_vari
!
!  but : Scruter le mot cle NOM_CMP et rendre le nom de la cmp
!        Si la grandeur est VARI_R, rendre egalement le numero (n) de vn
!  attention : il ne faut utiliser cette routine que si le mot cle
!              NOM_CMP n'attend qu'une seule valeur.
!
!  arguments :
!  -----------
!  nomgd  in  k8 : nom de la grandeur concernee
!  mcfac  in  k* : nom du mot cle facteur a scruter
!  iocc   in  i  : numero de l'occurrence de mcfac
!  nomcmp out k8 : nom de la composante trouvee derriere mcfac/nom_cmp
!  ivari  out i  : numero de la variable interne si nomgd='VARI_R'
!                   0 Si nomgd /= 'VARI_R'
!                  -1 si nomgd='VARI_R' + motcle NOM_VARI.
!
! ----------------------------------------------------------------------
    integer :: ibid, n2, iret, ivari
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
!
!
    nom_vari = ' '
!
    if (nomgd .eq. 'VARI_R') then
!     ------------------------------
        call getvtx(mcfac, 'NOM_CMP', iocc=iocc, scal=nomcmp, nbret=n2)
        ASSERT(n2.eq.1 .or. n2.eq.0)
        if (n2.eq.0) then
            call getvtx(mcfac, 'NOM_VARI', iocc=iocc, scal=nom_vari, nbret=n2)
            ASSERT(n2.eq.1)
            ivari=-1
        else
            call lxliis(nomcmp(2:8), ibid, iret)
            ivari=ibid
            if ((nomcmp(1:1).ne.'V') .or. (iret.ne.0)) then
                valk (1) = nomcmp
                valk (2) = 'VARI_R'
                call utmess('F', 'CALCULEL6_49', nk=2, valk=valk)
            endif
        endif
!
!     -- SI GRANDEUR /= VARI_R :
!     --------------------------
    else
        call getvtx(mcfac, 'NOM_CMP', iocc=iocc, scal=nomcmp, nbret=n2)
        ASSERT(n2.eq.1)
        ivari=0
    endif
!
end subroutine

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

subroutine rsutc4(resu, motfac, iocc, dimlis, lisch,&
                  nbch, acceno)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/getvtx.h"
#include "asterfort/indk16.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: iocc, dimlis, nbch
    aster_logical :: acceno
    character(len=*) :: resu, lisch(*), motfac
!
!
!     TRAITER LES MOTS CLE :
!        /  TOUT_CHAM (='OUI' PAR DEFAUT)
!        /  NOM_CHAM = (NOCH1,NOCH2,...)
!     ET ETABLIR LA LISTE DES NOMS SYMBOLIQUES A TRAITER.
!
! IN  : RESU    : K19  : SD_RESULTAT
! IN  : MOTFAC  : K16  : NOM DU MOT CLE FACTEUR (OU ' ')
! IN  : IOCC    : I    : NUMERO D'OCCURRENCE DE MOTFAC (OU 1)
! IN  : DIMLIS  : I    : LONGUEUR DE LISCH
! OUT : LISCH   : L_K16: LISTE DES NOMS TROUVES
! OUT : NBCH    : I    : NOMBRE DE CHAMPS TROUVES (OU -NBCH SI
!                        SI LISCH EST TROP COURTE)
! OUT : ACCENO  : L : .TRUE. : L'UTILISATEUR A UTILISE NOM_CHAM
!                     .FALSE. : L'UTILISATEUR N'A PAS UTILISE NOM_CHAM
!                               (=> TOUT_CHAM PAR DEFAUT)
!
!----------------------------------------------------------------------
!
!
    character(len=19) :: resu2
    integer :: nbnosy, isy, n2, ibid, k, kk
    character(len=16), pointer :: lich(:) => null()
    character(len=16), pointer :: litou(:) => null()
!
    resu2 = resu
!
!     --- ON REGARDE LA LISTE DES CHAMPS POSSIBLES POUR RESU:
    call jelira(resu2//'.DESC', 'NOMUTI', nbnosy)
    AS_ALLOCATE(vk16=litou, size=nbnosy)
    do 10 isy = 1, nbnosy
        call jenuno(jexnum(resu2//'.DESC', isy), litou(isy))
 10 end do
!
    acceno = .false.
!
    call getvtx(motfac, 'NOM_CHAM', iocc=iocc, nbval=0, nbret=n2)
    n2 = -n2
    if (n2 .gt. 0) then
        AS_ALLOCATE(vk16=lich, size=n2)
        call getvtx(motfac, 'NOM_CHAM', iocc=iocc, nbval=n2, vect=lich,&
                    nbret=ibid)
        do 20 k = 1, n2
            kk = indk16(litou,lich(k),1,nbnosy)
            if (kk .eq. 0) then
                call utmess('F', 'PREPOST4_77', sk=lich(k))
            endif
 20     continue
        nbch = n2
        do 30 k = 1, min(nbch, dimlis)
            lisch(k) = lich(k)
 30     continue
        acceno = .true.
!
    else
        nbch = nbnosy
        do 40 k = 1, min(nbch, dimlis)
            lisch(k) = litou(k)
 40     continue
    endif
!
    if (nbch .gt. dimlis) nbch = -nbch
!
    AS_DEALLOCATE(vk16=litou)
    AS_DEALLOCATE(vk16=lich)
!
end subroutine

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

subroutine chpver(arret, nocham, locham, gdcham, ier)
!
!     VERIFICATIONS DE LA GRANDEUR ET DE LA LOCALISATION DES CHAMPS.
!
!  IN  ARRET  : 'F' : ERREUR FATALE SI IER /=0
!               'C' : ON CONTINUE MEME SI IER /=0
!  IN  NOCHAM : NOM DU CHAMP
!  IN  LOCHAM : LOCALISATION DU CHAMP (*/CART/NOEU/ELGA/ELNO/ELEM/ELXX)
!               SI LOCHAM='*' : ON LEVE CETTE VERIFICATION
!  IN  GDCHAM : GRANDEUR DU CHAMP (*/DEPL_R/TEMP_R/...)
!               SI GDCHAM='*' : ON LEVE CETTE VERIFICATION
!  OUT   IER  : CODE RETOUR  (0--> OK, 1--> PB )
! ======================================================================
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: ier, ie1, ie2
    character(len=1) :: arret
    character(len=*) :: nocham, locham, gdcham
!
    character(len=19) :: noch
    character(len=4) :: loch, tych
    character(len=8) :: gdch, nomgd
    character(len=24) :: valk(3)
!
    call jemarq()
!
    noch=nocham
    ASSERT(arret.eq.'F'.or.arret.eq.'C')
    ie1=0
    ie2=0
    ier=1
!
!     VERIFICATION DU TYPE
    if (locham(1:1) .ne. '*') then
        loch=locham
        call dismoi('TYPE_CHAMP', noch, 'CHAMP', repk=tych, arret=arret,&
                    ier=ie1)
        if ((loch(3:4).ne.'XX' .and. loch.ne.tych ) .or.&
            (loch(3:4) .eq.'XX' .and. loch(1:2).ne.tych(1:2))) then
            ie1=1
            if (arret .eq. 'F') then
                valk (1) = noch
                valk (2) = loch
                valk (3) = tych
                call utmess('F', 'ELEMENTS_10', nk=3, valk=valk)
            endif
        endif
    endif
!
!     VERIFICATION DE LA GRANDEUR
    if (gdcham(1:1) .ne. '*') then
        gdch=gdcham
        call dismoi('NOM_GD', noch, 'CHAMP', repk=nomgd, arret=arret,&
                    ier=ie2)
        if (gdch .ne. nomgd) then
            ie2=1
            if (arret .eq. 'F') then
                valk (1) = noch
                valk (2) = gdch
                valk (3) = nomgd
                call utmess('F', 'ELEMENTS_37', nk=3, valk=valk)
            endif
        endif
    endif
!
!    VERIFICATION CROISE POUR SORTIR UN 'ET' DES 2 CONDITIONS
    if ((ie1.eq.0) .and. (ie2.eq.0)) then
        ier = 0
    endif
    call jedema()
!
end subroutine

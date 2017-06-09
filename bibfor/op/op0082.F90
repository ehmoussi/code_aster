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

subroutine op0082()
!
    implicit none
!
! person_in_charge: patrick.massin at edf.fr
!
!
! ----------------------------------------------------------------------
!
! OPERATEUR DEFI_GRILLE
!
! ----------------------------------------------------------------------
!
!
!
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/cncinv.h"
#include "asterfort/copisd.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/xprcnu.h"
    integer :: ifm, niv, ibid
    character(len=8) :: grille, mail
    character(len=16) :: k16bid
    character(len=19) :: cnxinv
    character(len=24) :: vcn, grlr
    real(kind=8) :: lcmin
!
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
!     GRILLE A CREER
    call getres(grille, k16bid, k16bid)
!
!     MAILLAGE EN ENTREE
    call getvid(' ', 'MAILLAGE', scal=mail, nbret=ibid)
!
!     DUPLIQUE LA SD_MAILLAGE
    call copisd('MAILLAGE', 'G', mail, grille)
!
!     MET A JOUR LE NOM DU MAILLAGE DANS LA SD_MAILLAGE DUPLIQUEE
    call jeveuo(grille//'.COORDO    .REFE', 'E', ibid)
    zk24(ibid) = grille
!
!     CALCUL DES GRANDEURS DE LA GRILLE ET VERIFICATION QUE LE MAILLAGE
!     EN ENTREE PEUT BIEN ETRE UTILISE POUR LA DEFINITION DE LA GRILLE
    cnxinv = '&&OP0082.CNCINV'
    call cncinv(mail, [ibid], 0, 'V', cnxinv)
    vcn=grille//'.GRLI'
    grlr=grille//'.GRLR'
    call xprcnu(mail, cnxinv, 'G', vcn, grlr,&
                lcmin)
!
!     STOCKE LA VALEUR DE LA PLUS PETITE ARETE DE LA GRILLE
    call jeveuo(grlr, 'E', ibid)
    zr(ibid) = lcmin
!
!     NETTOYAGE
    call jedetr(cnxinv)
!
!     INFO
    if (niv .gt. 0) then
        write(ifm,*)'  LONGUEUR DE LA PLUS PETITE ARETE DE LA GRILLE: '&
     &                ,lcmin
        write(ifm,*)' '
        write(ifm,*)'  BASE LOCALE DE LA GRILLE:'
        call jeveuo(grlr, 'E', ibid)
        ibid = ibid+1
        write(ifm,900)zr(ibid-1+1),zr(ibid-1+2),zr(ibid-1+3)
        write(ifm,901)zr(ibid-1+4),zr(ibid-1+5),zr(ibid-1+6)
        write(ifm,902)zr(ibid-1+7),zr(ibid-1+8),zr(ibid-1+9)
    endif
!
    900 format(6x,' ','X=(',e11.4,',',e11.4,',',e11.4,')')
    901 format(6x,' ','Y=(',e11.4,',',e11.4,',',e11.4,')')
    902 format(6x,' ','Z=(',e11.4,',',e11.4,',',e11.4,')')
!
    call jedema()
end subroutine

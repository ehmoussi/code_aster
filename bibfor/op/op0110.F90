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

subroutine op0110()
    implicit none
!
!  BUT:  OPERATEUR DE CREATION D'UN MAILLAGE SQUELETTE
!-----------------------------------------------------------------------
!
!
!
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/cargeo.h"
#include "asterfort/cla110.h"
#include "asterfort/cyc110.h"
#include "asterfort/detrsd.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rec110.h"
#include "asterfort/titre.h"
!
    integer :: ioc1, ioc2, ioc3, ioc11,   nbsect, ioc12, ibid
    character(len=8) :: modelg, rescyc, nomres, noma, nomsqu
    character(len=16) :: nomope, nomcmd
    integer, pointer :: cycl_nbsc(:) => null()
    character(len=24), pointer :: cycl_refe(:) => null()
!-----------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
!
    call getres(nomres, nomcmd, nomope)
    call getfac('CYCLIQUE', ioc1)
    call getvid(' ', 'MODELE_GENE', scal=modelg, nbret=ioc2)
    call getvid(' ', 'SQUELETTE', scal=nomsqu, nbret=ioc3)
!
!
!------------------------CAS CYCLIQUE-----------------------------------
!
    if (ioc1 .gt. 0) then
        call getvid('CYCLIQUE', 'MODE_CYCL', iocc=1, scal=rescyc, nbret=ioc11)
        if (ioc11 .gt. 0) then
            call jeveuo(rescyc//'.CYCL_REFE', 'L', vk24=cycl_refe)
            noma = cycl_refe(1)
            call jeveuo(rescyc//'.CYCL_NBSC', 'L', vi=cycl_nbsc)
            nbsect = cycl_nbsc(1)
        else
            call getvid('CYCLIQUE', 'MAILLAGE', iocc=1, scal=noma, nbret=ioc12)
            call getvis('CYCLIQUE', 'NB_SECTEUR', iocc=1, scal=nbsect, nbret=ibid)
        endif
        call cyc110(nomres, noma, nbsect)
!
!--------------------------CAS CLASSIQUE--------------------------------
!
    else if (ioc2 .ne. 0) then
        if (ioc3 .eq. 0) then
            call cla110(nomres, modelg)
        else
!           --- FUSION DES NOEUDS D'INTERFACE D'UN SQUELETTE EXISTANT --
            call rec110(nomres, nomsqu, modelg)
!           -- L'OBJET .INV.SKELETON EST FAUX : ON LE DETRUIT
            call jedetr(nomres//'.INV.SKELETON')
        endif
    endif
!
!
! --- CARACTERISTIQUES GEOMETRIQUES :
!     -----------------------------
    call detrsd('L_TABLE', nomres)
    call cargeo(nomres)
!
    call titre()
!
    call jedema()
end subroutine

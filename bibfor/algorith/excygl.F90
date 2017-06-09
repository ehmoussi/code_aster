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

subroutine excygl(nmresz, typsdz, mdcycz, maillz, profno)
    implicit none
!-----------------------------------------------------------------------
!  BUT:           < RESTITUTION CYCLIQUE GLOBALE >
!
!   RESTITUTION EN BASE PHYSIQUE DES RESULTATS CYCLIQUE
!    SUR UN MAILLAGE SQUELETTE DE LA STRUCTURE GLOBALE
!
! LE MAILLAGE REQUIS EST UN MAILLAGE AU SENS ASTER PLUS
! UN OBJET MAILLA//'.INV.SKELETON'
!
!-----------------------------------------------------------------------
!
! NMRESZ   /I/: NOM UT DU RESULTAT (TYPSD)
! MDCYCZ   /I/: NOM UT DU MODE_CYCL AMONT
! MAILLA   /I/: NOM UT DU MAILLAGE SQUELETTE SUPPORT
! PROFNO   /I/: NOM K19 DU PROFNO  DU SQUELETTE
! TYPSDZ   /I/: TYPE STRUCTURE DONNE RESULTAT (MODE_MECA,BASE_MODALE)
!
!
!
!
#include "jeveux.h"
#include "asterfort/cynupl.h"
#include "asterfort/exphgl.h"
#include "asterfort/getvis.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsutnu.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
    character(len=6) :: pgc
    character(len=*) :: nmresz, mdcycz, typsdz, maillz
    character(len=8) :: nomres, mailla, modcyc
    character(len=16) :: typsd
    character(len=19) :: profno
    character(len=24) :: indirf
    integer :: numdia, nbsec
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ibid, iret, nbmcal
!-----------------------------------------------------------------------
    data pgc /'EXCYGL'/
!-----------------------------------------------------------------------
!
    call jemarq()
    nomres = nmresz
    modcyc = mdcycz
    typsd = typsdz
    mailla = maillz
!
    indirf='&&'//pgc//'.INDIR.SECT'
!
!-----------------ECRITURE DU TITRE-------------------------------------
!
    call titre()
!
!--------------VERIFICATION SUR MAILLAGE SQUELETTE----------------------
!
    call jeexin(mailla//'.INV.SKELETON', iret)
    if (iret .eq. 0) then
        call utmess('F', 'ALGORITH13_8')
    endif
!
!-----RECUPERATION DU NOMBRE DE SECTEURS--------------------------------
    call getvis('CYCLIQUE', 'NB_SECTEUR', iocc=1, scal=nbsec, nbret=ibid)
!
    call getvis('CYCLIQUE', 'NUME_DIAMETRE', iocc=1, scal=numdia, nbret=ibid)
!
!-----RECUPERATION NOMBRE NUMERO D'ORDRE UTILISES POUR CALCUL CYCLIQUE--
    call rsutnu(modcyc, ' ', 0, '&&EXCYGL.NUME', nbmcal,&
                0.d0, 'ABSO', iret)
!
!--------------ALLOCATION DU CONCEPT MODE_MECA RESULTAT-----------------
!
    call rscrsd('G', nomres, typsd, nbmcal)
!
!-------------------CREATION PROF_CHAMNO ET TABLES INDIRECTION----------
!
    call cynupl(profno, indirf, modcyc, mailla, nbsec)
!
!------------------------------RESTITUTION -----------------------------
!
    call exphgl(nomres, typsd, modcyc, profno, indirf,&
                mailla, nbsec, numdia, nbmcal)
!
    call jedetr('&&'//pgc//'.INDIR.SECT')
    call jedema()
end subroutine

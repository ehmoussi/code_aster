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

subroutine crasse()
    implicit none
!
!     COMMANDE:  CREA_RESU
!     CREE UNE STRUCTURE DE DONNEE DE TYPE "EVOL_THER"
!     PAR ASSEMBLAGES D'EVOL_THER EXISTANTS
!
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsmena.h"
#include "asterfort/rsnoch.h"
#include "asterfort/utmess.h"
!
!
!
    integer :: iret, nbfac, iocc, nbord1, iord2, iord1
    integer :: kord1, iad,  jord2, n1, nordmx
    real(kind=8) :: inst1, inst2, trans, tprev, valr(2)
    character(len=8) :: k8b, resu2, resu1
    character(len=16) :: type, oper, chter
    character(len=19) :: nomch, cham1, resu19
    integer :: nbcham, kch
    integer, pointer :: ord1(:) => null()
!
! ----------------------------------------------------------------------
    call jemarq()
!
!
!     -- ALLOCATION DE RESU2
!     -- CALCUL DE JORD2
!     --------------------------------
    call getres(resu2, type, oper)
    call getfac('ASSE', nbfac)
!
!     -- LA RE-ENTRANCE EST INTERDITE:
    call jeexin(resu2//'           .DESC', iret)
    ASSERT(iret.eq.0)
!
!     -- ON COMPTE LE NOMBRE MAX. DE NUMEROS D'ORDRE DE LA
!        SD_RESULTAT :
    nordmx=0
    do 101 iocc = 1, nbfac
        call getvid('ASSE', 'RESULTAT', iocc=iocc, scal=resu1, nbret=n1)
        resu19=resu1
        call jelira(resu19//'.ORDR', 'LONUTI', nbord1)
        nordmx=nordmx+nbord1
101  end do
!
!
!     -- ALLOCATION DE LA SD_RESULTAT :
    call rscrsd('G', resu2, type, nordmx)
    resu19=resu2
    call jeveuo(resu19//'.ORDR', 'L', jord2)
!
!
!     BOUCLE SUR LES OCCURRENCES DE ASSE :
!     ------------------------------------
    iord2=0
    tprev=-1.d300
    do 100 iocc = 1, nbfac
        call getvr8('ASSE', 'TRANSLATION', iocc=iocc, scal=trans, nbret=n1)
        call getvid('ASSE', 'RESULTAT', iocc=iocc, scal=resu1, nbret=n1)
        resu19=resu1
        call jelira(resu19//'.ORDR', 'LONUTI', nbord1)
        call jeveuo(resu19//'.ORDR', 'L', vi=ord1)
        call jelira(resu19//'.DESC', 'NOMUTI', nbcham)
!
!       BOUCLE SUR LES CHAMPS 'TEMP' DE RESU1 ET RECOPIE DANS RESU2:
!       -----------------------------------------------------------
        do 110, kord1=1,nbord1
        iord1 = ord1(kord1)
        iord2 = iord2 + 1
!
!         -- STOCKAGE DE L'INSTANT :
        call rsadpa(resu1, 'L', 1, 'INST', iord1,&
                    0, sjv=iad, styp=k8b)
        inst1=zr(iad)
!         -- ON VERIFIE QUE LES INSTANTS SONT CROISSANTS :
        inst2=inst1+trans
        if (inst2 .lt. tprev) then
            valr(1)=tprev
            valr(2)=inst2
            call utmess('F', 'CALCULEL4_21', nr=2, valr=valr)
        else if (inst2.eq.tprev) then
!           -- SI UN INSTANT EST TROUVE PLUSIEURS FOIS, ON ECRASE :
            call utmess('I', 'CALCULEL4_22', sr=inst2)
            iord2=iord2-1
        endif
        tprev=inst2
!
        call rsadpa(resu2, 'E', 1, 'INST', iord2,&
                    0, sjv=iad, styp=k8b)
        zr(iad)=inst2
!
        do 115 kch = 1, nbcham
            call jenuno(jexnum(resu19//'.DESC', kch), chter)
!
!           1- RECUPERATION DU CHAMP : CHAM1
            call rsexch(' ', resu1, chter, iord1, cham1,&
                        iret)
            if (iret .ne. 0) goto 115
!
!           2- STOCKAGE DE CHAM1 :
            call rsexch(' ', resu2, chter, iord2, nomch,&
                        iret)
            ASSERT(iret.eq.0.or.iret.eq.100)
            call copisd('CHAMP_GD', 'G', cham1, nomch)
            call rsnoch(resu2, chter, iord2)
!
115      continue
110      continue
100  end do
!
!
!     -- EVENTUELLEMENT, IL FAUT DETRUIRE LES PROF_CHNO INUTILES
!        (A CAUSE DES INSTANTS MULTIPLES) :
    call rsmena(resu2)
!
!
    call jedema()
end subroutine

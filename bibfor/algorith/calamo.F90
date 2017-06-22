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

subroutine calamo(nomres, classe, basmod)
! aslint: disable=
    implicit none
!    T. KERBER     DATE 02/06/93
!-----------------------------------------------------------------------
!    BUT : CALCUL DE LA MATRICE D'AMORTISSEMENT MODAL
!
!          CONSISTE A DETERMINER LA MATRICE D'AMORTISSEMENT POUR UN
!          MACRO-ELEMENT, EN FONCTION DES AMORTISSEMENTS REDUITS.
!          LA MATRICE RESULTAT EST DIAGONALE MAIS STOCKEE TRIANGLE SUP,
!          POUR RESTER COHERENTE AVEC LES AUTRES MATRICES.
!-----------------------------------------------------------------------
!
! NOMRES /I/ : NOM K19 DE LA MATRICE CARRE RESULTAT
! CLASSE /I/ : CLASSE DE LA BASE JEVEUX DE L'OBJET RESULTAT
! BASMOD /I/ : NOM UT DE LA BASE MODALE DE PROJECTION
!
!
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvr8.h"
#include "asterfort/jeecra.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: vali(3)
!
!
    real(kind=8) :: pi
    character(len=1) :: classe
    character(len=8) :: basmod, blanc, k8bid
    character(len=24) :: nomres
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iad, iam, idiff, ioc, lamo2
    integer :: lamor, lddes, ldref, ldres, lfreq, lmgen, nbamor
    integer :: nbdef, nbmod, ntail
    real(kind=8) :: coeff
!-----------------------------------------------------------------------
    data blanc /'        '/
!-----------------------------------------------------------------------
!
    call jemarq()
    pi=4.d0*atan(1.d0)
!
! --- CREATION DU .REFE
!
    call wkvect(nomres(1:18)//'_REFE', 'G V K24', 2, ldref)
    zk24(ldref) = basmod
!
! --- RECUPERATION DES DIMENSIONS DE LA BASE MODALE
!
!   NOMBRE DE MODES PROPRES
!
    call dismoi('NB_MODES_DYN', basmod, 'RESULTAT', repi=nbmod)
!
!   NOMBRE TOTAL DE MODES ET DEFORMEES
!
    call dismoi('NB_MODES_TOT', basmod, 'RESULTAT', repi=nbdef)
!
! --- CREATION DU .DESC
!
    call wkvect(nomres(1:18)//'_DESC', 'G V I', 3, lddes)
    zi(lddes) = 2
    zi(lddes+1) = nbdef
    zi(lddes+2) = 2
!
! --- ALLOCATION DE LA MATRICE RESULTAT
!
    ntail = nbdef* (nbdef+1)/2
    call jecrec(nomres(1:18)//'_VALE', classe//' V R', 'NU', 'DISPERSE', & 
                   'CONSTANT',1)   
    call jeecra(nomres(1:18)//'_VALE', 'LONMAX', ntail)
    call jecroc(jexnum(nomres(1:18)//'_VALE', 1))
    call jeveuo(jexnum(nomres(1:18)//'_VALE', 1), 'E', ldres)
!   call wkvect(nomres(1:18)//'_VALE', classe//' V R', ntail, ldres)
!
! --- REMPLISSAGE DES VALEURS DIAGONALES
!
    call getvr8(blanc, 'AMOR_REDUIT', iocc=1, nbval=0, nbret=ioc)
    nbamor = -ioc
    if (nbamor .gt. nbmod) then
        vali (1) = nbmod
        vali (2) = nbamor
        vali (3) = nbmod
        call utmess('A', 'ALGORITH15_90', ni=3, vali=vali)
        call wkvect('&&CALAMO.COEFF', 'V V R', nbmod, lamor)
        call getvr8(blanc, 'AMOR_REDUIT', iocc=1, nbval=nbmod, vect=zr(lamor),&
                    nbret=ioc)
!
    else if (nbamor.lt.nbmod) then
        call wkvect('&&CALAMO.COEFF', 'V V R', nbamor, lamor)
        call getvr8(blanc, 'AMOR_REDUIT', iocc=1, nbval=nbamor, vect=zr(lamor),&
                    nbret=ioc)
        idiff = nbmod - nbamor
        vali (1) = idiff
        vali (2) = nbmod
        vali (3) = idiff
        call utmess('A', 'ALGORITH15_91', ni=3, vali=vali)
        call wkvect('&&CALAMO.COEFF2', 'V V R', nbmod, lamo2)
        do iam = 1, nbamor
            zr(lamo2+iam-1) = zr(lamor+iam-1)
        end do
        do iam = nbamor, nbmod
            zr(lamo2+iam-1) = zr(lamor+nbamor-1)
        end do
        lamor = lamo2
!
    else if (nbamor.eq.nbmod) then
        call wkvect('&&CALAMO.COEFF', 'V V R', nbmod, lamor)
        call getvr8(blanc, 'AMOR_REDUIT', iocc=1, nbval=nbmod, vect=zr(lamor),&
                    nbret=ioc)
    endif
!
    do i = 1, nbmod
        iad = i* (i+1)/2
        call rsadpa(basmod, 'L', 1, 'FREQ', i,&
                    0, sjv=lfreq, styp=k8bid)
        call rsadpa(basmod, 'L', 1, 'MASS_GENE', i,&
                    0, sjv=lmgen, styp=k8bid)
        coeff = 4.d0*pi*zr(lfreq)*zr(lamor+i-1)*zr(lmgen)
        zr(ldres+iad-1) = coeff
    end do
!
!
! --- MENAGE
!
    call jedetr('&&CALAMO.COEFF')
    call jedetr('&&CALAMO.COEFF2')
!
    goto 999
!
999 continue
    call jedema()
end subroutine

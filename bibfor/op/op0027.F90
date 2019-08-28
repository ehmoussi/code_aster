! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine op0027()

!      OPERATEUR :     CALC_H
!
!      BUT:CALCUL DU TAUX DE RESTITUTION D'ENERGIE PAR LA METHODE THETA
!          CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES
! ======================================================================
! person_in_charge: tanguy.mathieu at edf.fr
!
    implicit none
!
!
#include "asterc/getres.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/infmaj.h"
#include "asterfort/cgcrtb.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/titre.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajvi.h"
#include "asterfort/tbajvk.h"
#include "asterfort/tbajvr.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
#include "asterfort/deprecated_algom.h"
#include "asterfort/utimsd.h"
!
    integer :: nxpara
    parameter (nxpara = 15)
    character(len=8) :: table, resu, modele, nomfis, litypa(nxpara), typfis, k8bid

    integer :: nbmxpa
    parameter (nbmxpa = 20)
!
    integer :: livi(nbmxpa), iord, iadfis
    real(kind=8) :: livr(nbmxpa), time, g(1)
    complex(kind=8) :: livc(nbmxpa)
    character(len=24) :: livk(nbmxpa)
!
    character(len=16) :: option, k16bid, linopa(nxpara)
    integer :: ier, ifond, ifiss, nbpara, ndim, numfon, ibid, lfond
    aster_logical :: lmoda = .false.
! 
    character(len=24) :: chfond='&&0100.FONDFISS'
!
    call jemarq()
    call infmaj()
    call deprecated_algom('CALC_H')
!
!     RECUPERATION DU CONCEPT DE SORTIE : TABLE
    call getres(table, k16bid, k16bid)

!     RECUPERATION DE LA SD RESULTAT : RESU ET DES INFORMATIONS ASSOCIEES
!
    call getvid(' ', 'RESULTAT', scal=resu, nbret=ier)
    call dismoi('MODELE', resu, 'RESULTAT', repk=modele)
    call dismoi('DIM_GEOM', modele, 'MODELE', repi=ndim)

!     RECUPERATION DE L'OPTION
!
    call getvtx(' ', 'OPTION', scal=option, nbret=ier)

!
!     DETERMINATION DU TYPFIS = 'FONDFISS' OU 'FISSURE' OU 'THETA'
!     ET RECUPERATION DE LA SD POUR DECRIRE LE FOND DE FISSURE : NOMFIS
!
!    call cgtyfi(typfis, nomfis, typdis)
    call getvid('THETA', 'FOND_FISS', iocc=1, scal=nomfis, nbret=ifond)
    call getvid('THETA', 'FISSURE', iocc=1, scal=nomfis, nbret=ifiss)
!
    if (ifond.eq.1) then
        typfis='FONDFISS'
    else if (ifiss.eq.1) then
        typfis='FISSURE'
    endif
!
!     CREATION DE LA TABLE
!
    call cgcrtb(table, option, ndim, typfis, nxpara, lmoda, nbpara, linopa, litypa)
!
    call getvis('THETA', 'NUME_FOND', iocc=1, scal=numfon, nbret=ibid)

    call tbajvi(table, nbpara, 'NUME_FOND', numfon, livi)
    lfond=10
    if (typfis.ne.'THETA') then
        call wkvect(chfond, 'V V R', lfond, iadfis)
    else
        iadfis=0
    endif
    k8bid = 'K8_BIDON'
    call tbajvk(table, nbpara, 'NOEUD', k8bid, livk)
!
    iord = 1 
    call tbajvi(table, nbpara, 'NUME_ORDRE', iord, livi)
    time = 2.0
    call tbajvr(table, nbpara, 'INST', time, livr)
!
    call tbajvr(table, nbpara, 'COOR_X', zr(iadfis),   livr)
    call tbajvr(table, nbpara, 'COOR_Y', zr(iadfis+1), livr)

    g(1)= 123456789.0
    call tbajvr(table, nbpara, 'G', g(1), livr)
    call tbajli(table, nbpara, linopa, livi, livr, livc, livk, 0)
!
    call utimsd(6, 2, .true._1, .true._1,table, 1, ' ')

!
    call titre()
!
    call jedema()
!
end subroutine

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

subroutine cfcpes(resoco, jsecmb)
!
!
    implicit     none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/calatm.h"
#include "asterfort/cfdisd.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resoco
    integer :: jsecmb
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - PENALISATION)
!
! CALCUL DU SECOND MEMBRE POUR LE CONTACT -E_N.[Ac]T.{JEU}
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  JSECMB : ADRESSE VERS LE SECOND MEMBRE
!
!
!
!
    real(kind=8) :: jeuini, coefpn, lambdc
    integer :: iliai, iliac
    character(len=19) :: mu
    integer :: jmu
    character(len=24) :: apcoef, apddl, appoin
    integer :: japcoe, japddl, japptr
    character(len=24) :: tacfin
    integer :: jtacf
    character(len=24) :: jeux
    integer :: jjeux
    integer :: ztacf
    integer :: nbliai, neq
    integer :: nbddl, jdecal
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATION DES VARIABLES
!
    nbliai = cfdisd(resoco,'NBLIAI')
    neq = cfdisd(resoco,'NEQ' )
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    appoin = resoco(1:14)//'.APPOIN'
    apddl = resoco(1:14)//'.APDDL'
    apcoef = resoco(1:14)//'.APCOEF'
    jeux = resoco(1:14)//'.JEUX'
    tacfin = resoco(1:14)//'.TACFIN'
    mu = resoco(1:14)//'.MU'
    call jeveuo(appoin, 'L', japptr)
    call jeveuo(apddl, 'L', japddl)
    call jeveuo(apcoef, 'L', japcoe)
    call jeveuo(jeux, 'L', jjeux)
    call jeveuo(tacfin, 'L', jtacf)
    call jeveuo(mu, 'E', jmu)
    ztacf = cfmmvd('ZTACF')
!
! --- INITIALISATION DES MU
!
    do 10 iliai = 1, nbliai
        zr(jmu +iliai-1) = 0.d0
        zr(jmu+3*nbliai+iliai-1) = 0.d0
10  end do
!
! --- CALCUL DES FORCES DE CONTACT
!
    iliac = 1
    do 50 iliai = 1, nbliai
        jeuini = zr(jjeux+3*(iliai-1)+1-1)
        coefpn = zr(jtacf+ztacf*(iliai-1)+1)
        if (jeuini .lt. r8prem()) then
            jdecal = zi(japptr+iliai-1)
            nbddl = zi(japptr+iliai) - zi(japptr+iliai-1)
            lambdc = -jeuini*coefpn
            zr(jmu+iliac-1) = lambdc
            call calatm(neq, nbddl, lambdc, zr(japcoe+jdecal), zi(japddl+ jdecal),&
                        zr(jsecmb))
            iliac = iliac + 1
        endif
50  end do
!
    call jedema()
!
end subroutine

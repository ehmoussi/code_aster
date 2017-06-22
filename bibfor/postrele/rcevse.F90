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

subroutine rcevse(csigm, cinst, csno, csne)
    implicit      none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rctres.h"
#include "asterfort/wkvect.h"
    character(len=24) :: csigm, cinst, csno, csne
!     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
!     CALCUL DU SN*
!
!     ------------------------------------------------------------------
!
    integer :: ncmp, jsigm, jinst, nbinst, nbordr, jsno, jsne, ind, i1, i2, icmp
    integer :: l1, l2, l3
    parameter  ( ncmp = 6 )
    real(kind=8) :: sn1o(ncmp), sn1e(ncmp), sn2o(ncmp), sn2e(ncmp), sn12o(ncmp)
    real(kind=8) :: sn12e(ncmp), tresca
! DEB ------------------------------------------------------------------
    call jemarq()
!
    call jeveuo(csigm, 'L', jsigm)
    call jeveuo(cinst, 'L', jinst)
    call jelira(cinst, 'LONMAX', nbinst)
!
    nbordr = (nbinst*(nbinst+1)) / 2
    call wkvect(csno, 'V V R', nbordr, jsno)
    call wkvect(csne, 'V V R', nbordr, jsne)
    ind = 0
!
    do 100 i1 = 1, nbinst
!
        do 102 icmp = 1, ncmp
            l1 = ncmp*(i1-1) + icmp
            l2 = ncmp*nbinst + ncmp*(i1-1) + icmp
            l3 = 3*ncmp*nbinst + ncmp*(i1-1) + icmp
            sn1o(icmp) = zr(jsigm-1+l1)-zr(jsigm-1+l2)+zr(jsigm-1+l3)
            sn1e(icmp) = zr(jsigm-1+l1)+zr(jsigm-1+l2)-zr(jsigm-1+l3)
102      continue
        ind = ind + 1
        zr(jsno+ind-1) = 0.d0
        zr(jsne+ind-1) = 0.d0
!
        do 110 i2 = i1+1, nbinst
!
            do 112 icmp = 1, ncmp
                l1 = ncmp*(i2-1) + icmp
                l2 = ncmp*nbinst + ncmp*(i2-1) + icmp
                l3 = 3*ncmp*nbinst + ncmp*(i2-1) + icmp
                sn2o(icmp) = zr(jsigm-1+l1)-zr(jsigm-1+l2)+zr(jsigm-1+ l3)
                sn2e(icmp) = zr(jsigm-1+l1)+zr(jsigm-1+l2)-zr(jsigm-1+ l3)
112          continue
            ind = ind + 1
! ======================================================================
! ---       COMBINAISON DES CONTRAINTES AUX 2 INSTANTS TEMP1 ET TEMP2 :
! ======================================================================
            do 114 icmp = 1, ncmp
                sn12o(icmp) = sn1o(icmp) - sn2o(icmp)
                sn12e(icmp) = sn1e(icmp) - sn2e(icmp)
!CC           ENDIF
114          continue
! ======================================================================
! ---       CALCUL DES VALEURS PROPRES DE LA DIFFERENCE DES TENSEURS
! ---       DE CONTRAINTES LINEARISEES
! ---       SN12O = SNO(TEMP1)-SNO(TEMP2) A L'ORIGINE DU CHEMIN :
! ---  CALCUL DE LA DIFFERENCE SUP SNO DES VALEURS PROPRES ( LE TRESCA)
! ======================================================================
            call rctres(sn12o, tresca)
            zr(jsno+ind-1) = tresca
! ======================================================================
! ---      CALCUL DES VALEURS PROPRES DE LA DIFFERENCE DES TENSEURS
! ---      DE CONTRAINTES LINEARISEES
! ---      SN12E = SNE(TEMP1)-SNE(TEMP2) A L'AUTRE EXTREMITE DU CHEMIN :
! ---   CALCUL DE LA DIFFERENCE SUP SNE DES VALEURS PROPRES (LE TRESCA)
! ======================================================================
            call rctres(sn12e, tresca)
            zr(jsne+ind-1) = tresca
!
110      continue
!
100  end do
!
    call jedema()
end subroutine

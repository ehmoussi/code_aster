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

subroutine rcevsp(csiex, kemixt, cstex, csmex, cinst,&
                  cspo, cspe, cspto, cspte, cspmo,&
                  cspme)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rctres.h"
#include "asterfort/wkvect.h"
    character(len=24) :: csiex, cinst, cspo, cspe, cstex, csmex, cspto, cspte
    character(len=24) :: cspmo, cspme
    aster_logical :: kemixt
!     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
!     CALCUL DU SP
!
!     ------------------------------------------------------------------
!
    integer :: ncmp, jsioe, jinst, nbinst, nbordr, jspo, jspe, ind, i1, i2, icmp
    integer :: l1, l2, jstoe, jsmoe, jspto, jspte, jspmo, jspme
    parameter  ( ncmp = 6 )
    real(kind=8) :: sp1o(ncmp), sp1e(ncmp), sp2o(ncmp), sp2e(ncmp), sp12o(ncmp)
    real(kind=8) :: sp12e(ncmp), tresca, spt1o(ncmp), spt1e(ncmp), spt2o(ncmp)
    real(kind=8) :: spt2e(ncmp), spt12o(ncmp), spt12e(ncmp), spm1o(ncmp)
    real(kind=8) :: spm1e(ncmp), spm2o(ncmp), spm2e(ncmp), spm12o(ncmp)
    real(kind=8) :: spm12e(ncmp)
! DEB ------------------------------------------------------------------
    call jemarq()
!
    call jeveuo(csiex, 'L', jsioe)
    if (kemixt) then
        call jeveuo(cstex, 'L', jstoe)
        call jeveuo(csmex, 'L', jsmoe)
    endif
    call jeveuo(cinst, 'L', jinst)
    call jelira(cinst, 'LONMAX', nbinst)
!
    nbordr = (nbinst*(nbinst+1)) / 2
    call wkvect(cspo, 'V V R', nbordr, jspo)
    call wkvect(cspe, 'V V R', nbordr, jspe)
    if (kemixt) then
        call wkvect(cspto, 'V V R', nbordr, jspto)
        call wkvect(cspte, 'V V R', nbordr, jspte)
        call wkvect(cspmo, 'V V R', nbordr, jspmo)
        call wkvect(cspme, 'V V R', nbordr, jspme)
    endif
    ind = 0
!
    do 100 i1 = 1, nbinst
!
        do 102 icmp = 1, ncmp
            l1 = ncmp*(i1-1) + icmp
            l2 = ncmp*nbinst + ncmp*(i1-1) + icmp
            sp1o(icmp) = zr(jsioe-1+l1)
            sp1e(icmp) = zr(jsioe-1+l2)
            if (kemixt) then
                spt1o(icmp) = zr(jstoe-1+l1)
                spt1e(icmp) = zr(jstoe-1+l2)
                spm1o(icmp) = zr(jsmoe-1+l1)
                spm1e(icmp) = zr(jsmoe-1+l2)
            endif
102     continue
        ind = ind + 1
!
        zr(jspo+ind-1) = 0.d0
        zr(jspe+ind-1) = 0.d0
        if (kemixt) then
            zr(jspto+ind-1) = 0.d0
            zr(jspte+ind-1) = 0.d0
            zr(jspmo+ind-1) = 0.d0
            zr(jspme+ind-1) = 0.d0
        endif
!
        do 110 i2 = i1+1, nbinst
!
            do 112 icmp = 1, ncmp
                l1 = ncmp*(i2-1) + icmp
                l2 = ncmp*nbinst + ncmp*(i2-1) + icmp
                sp2o(icmp) = zr(jsioe-1+l1)
                sp2e(icmp) = zr(jsioe-1+l2)
                if (kemixt) then
                    spt2o(icmp) = zr(jstoe-1+l1)
                    spt2e(icmp) = zr(jstoe-1+l2)
                    spm2o(icmp) = zr(jsmoe-1+l1)
                    spm2e(icmp) = zr(jsmoe-1+l2)
                endif
112         continue
            ind = ind + 1
! ======================================================================
! ---       COMBINAISON DES CONTRAINTES AUX 2 INSTANTS TEMP1 ET TEMP2 :
! ======================================================================
            do 114 icmp = 1, ncmp
                sp12o(icmp) = sp1o(icmp) - sp2o(icmp)
                sp12e(icmp) = sp1e(icmp) - sp2e(icmp)
                if (kemixt) then
                    spt12o(icmp) = spt1o(icmp) - spt2o(icmp)
                    spt12e(icmp) = spt1e(icmp) - spt2e(icmp)
                    spm12o(icmp) = spm1o(icmp) - spm2o(icmp)
                    spm12e(icmp) = spm1e(icmp) - spm2e(icmp)
                endif
114         continue
! ======================================================================
! ---       CALCUL DE LA NORME DE TRESCA DE LA DIFFERENCE DES TENSEURS
! ---       DE CONTRAINTES TOTALES
! ---       SP12O = SPO(TEMP1)-SPO(TEMP2) A L'ORIGINE DU CHEMIN :
! ======================================================================
            call rctres(sp12o, tresca)
            zr(jspo+ind-1) = tresca
! ======================================================================
! ---       CALCUL DE LA NORME DE TRESCA DE LA DIFFERENCE DES TENSEURS
! ---       DE CONTRAINTES TOTALES A L'EXTREMITE DU CHEMIN :
! ======================================================================
            call rctres(sp12e, tresca)
            zr(jspe+ind-1) = tresca
!
            if (kemixt) then
! ======================================================================
! ---       CAS KE_MIXTE : SEPARATION DES CONTRAINTES THERMIQUES
! ---       ET DES CONTRAINTES MECANIQUES
! ======================================================================
                call rctres(spt12o, tresca)
                zr(jspto+ind-1) = tresca
!
                call rctres(spt12e, tresca)
                zr(jspte+ind-1) = tresca
!
                call rctres(spm12o, tresca)
                zr(jspmo+ind-1) = tresca
!
                call rctres(spm12e, tresca)
                zr(jspme+ind-1) = tresca
!
            endif
!
110     continue
!
100 end do
!
    call jedema()
end subroutine

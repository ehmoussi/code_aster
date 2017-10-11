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

subroutine rc32sa(typz, sn, sp, spmeca,&
                  kemeca, kether, salt, fu)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/getvid.h"
#include "asterfort/jeveuo.h"
#include "asterfort/getvtx.h"
#include "asterfort/prccm3.h"
#include "asterfort/limend.h"
#include "asterc/r8maem.h"
#include "asterc/r8vide.h"
#include "asterfort/rcvale.h"
#include "asterfort/utmess.h"

    real(kind=8) :: sn, sp(2), salt(2), kether
    real(kind=8) :: spmeca(2), fu(2), kemeca
    character(len=*) :: typz
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!     CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE  SALT
!     CALCUL DU FACTEUR D'USAGE ET DE SON CUMUL
!
! IN  : SN     : AMPLITUDE DE VARIATION DES CONTRAINTES LINEARISEES
! IN  : SP     : AMPLITUDE DE VARIATION DES CONTRAINTES TOTALES
! IN  : SPMECA : AMPLITUDE DE VARIATION DES CONTRAINTES MECANIQUES
! OUT : KEMECA
! OUT : KETHER
! OUT : SALT   : AMPLITUDE DE CONTRAINTE ALTERNEE
! OUT : FU     : FACTEUR D USAGE UNITAIRE
!
!     ------------------------------------------------------------------
!
    character(len=8) :: mater, typeke, kbid
    integer :: n1, jvale, icodre(1)
    real(kind=8) :: e, ec, sm, m, n, para(3), nadm(1), kethe1, spther(2)
    real(kind=8) :: salth, saltm, valr(2)
    aster_logical :: endur
!
! DEB ------------------------------------------------------------------
!
! --- LE MATERIAU
!
    call getvid(' ', 'MATER', scal=mater, nbret=n1)
    call jeveuo('&&RC3200.MATERIAU', 'L', jvale)
    e = zr(jvale)
    ec = zr(jvale+3)
    sm = zr(jvale+4)
    m = zr(jvale+5)
    n = zr(jvale+6)
!
    para(1) = m
    para(2) = n
    para(3) = ec / e
!
    salt(1) = 0.d0
    salt(2) = 0.d0
    fu(1) = 0.d0
    fu(2) = 0.d0
!
! --- CALCUL DU COEFFICIENT DE CONCENTRATION ELASTO-PLASTIQUE KE
! --- CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE SALT
! --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE nadm(1)
!
!
! --- CAS KE_MECA
!
    call getvtx(' ', 'TYPE_KE', scal=typeke, nbret=n1)
    if (typeke .eq. 'KE_MECA') then
        call prccm3(mater, para, sm, sn, sp(1),&
                    kemeca, salt(1), nadm(1))
        fu(1) = 1.d0 / nadm(1)
        if (typz .eq. 'COMB') then
            call prccm3(mater, para, sm, sn, sp(2),&
                        kemeca, salt(2), nadm(1))
            fu(2) = 1.d0 / nadm(1)
        endif
        kether = r8vide()
    else
!
! --- CAS KE_MIXTE
!
        kethe1 = 1.86d0*(1.d0-(1.d0/(1.66d0+sn/sm)))
        kether = max(1.d0,kethe1)
        call prccm3(mater, para, sm, sn, spmeca(1),&
                    kemeca, saltm, nadm(1))
        spther(1)=max(0.d0,sp(1)-spmeca(1))
        salth = 0.5d0 * para(3) * kether * spther(1)
        salt(1) = saltm + salth
!
! --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE nadm(1) : TR. 1
!
        call limend(mater, salt(1), 'WOHLER', kbid, endur)
        if (endur) then
            nadm(1)=r8maem()
        else
            call rcvale(mater, 'FATIGUE', 1, 'SIGM    ', salt(1),&
                        1, 'WOHLER  ', nadm(1), icodre(1), 2)
            if (nadm(1) .lt. 0) then
                valr (1) = salt(1)
                valr (2) = nadm(1)
                call utmess('A', 'POSTRELE_61', nr=2, valr=valr)
            endif
        endif
        fu(1) = 1.d0 / nadm(1)
!
        if (typz .eq. 'COMB') then
            call prccm3(mater, para, sm, sn, spmeca(2),&
                        kemeca, saltm, nadm(1))
            spther(2)=max(0.d0,sp(2)-spmeca(2))
            salth = 0.5d0 * para(3) * kether * spther(2)
            salt(2) = saltm + salth
! --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE nadm(1) : TR. 2
!
            call limend(mater, salt(2), 'WOHLER', kbid, endur)
            if (endur) then
                nadm(1)=r8maem()
            else
                call rcvale(mater, 'FATIGUE', 1, 'SIGM    ', salt(2),&
                            1, 'WOHLER  ', nadm(1), icodre(1), 2)
                if (nadm(1) .lt. 0) then
                    valr (1) = salt(1)
                    valr (2) = nadm(1)
                    call utmess('A', 'POSTRELE_61', nr=2, valr=valr)
                endif
            endif
            fu(2) = 1.d0 / nadm(1)
        endif
!
    endif
!
end subroutine

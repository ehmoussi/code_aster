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

subroutine rcsp01(nbm, adrm, ipt, sp3, sp4,&
                  sp5, alphaa, alphab, nbth, iocs,&
                  sp6)
    implicit none
#include "jeveux.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: nbm, adrm(*), ipt, nbth, iocs
    real(kind=8) :: sp3, sp4, sp5, alphaa, alphab, sp6
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!     CALCUL DU SP
!
!     ------------------------------------------------------------------
!
    integer ::  iad, icmp, nbcmp, decal,   jcesl, nbinst, i
    integer :: jmoye, jmoy2, jther, vali(2)
    real(kind=8) :: tint, text, ta, tb, tab, dt1, dt2, term1, term2, dt1max
    real(kind=8) :: dt2max, tabmax
    character(len=24) :: chtemp
    character(len=24), pointer :: cham_ther(:) => null()
    integer, pointer :: cesd(:) => null()
    character(len=24), pointer :: cesv(:) => null()
!
! DEB ------------------------------------------------------------------
!
    sp6 = 0.d0
    if (nbth .eq. 0) goto 9999
!
    call jeveuo('&&RC3600.CHAM_THER', 'L', vk24=cham_ther)
!
    chtemp = cham_ther(iocs)
!
    call jeveuo(chtemp(1:19)//'.CESD', 'L', vi=cesd)
    call jeveuo(chtemp(1:19)//'.CESV', 'L', vk24=cesv)
    call jeveuo(chtemp(1:19)//'.CESL', 'L', jcesl)
!
    nbcmp = cesd(2)
    decal = cesd(5+4*(adrm(1)-1)+4)
!
    icmp = 1
    iad = decal + (ipt-1)*nbcmp + icmp
    if (.not.zl(jcesl-1+iad)) then
        vali(1) = iocs
        vali(2) = adrm(1)
        call utmess('F', 'POSTRCCM_15', sk='RESU_THER', ni=2, vali=vali)
    endif
    call jeveuo(cesv(iad), 'L', jther)
    call jelira(cesv(iad), 'LONMAX', nbinst)
    nbinst = nbinst / 2
!
    icmp = 2
    iad = decal + (ipt-1)*nbcmp + icmp
    if (.not.zl(jcesl-1+iad)) then
        vali(1) = iocs
        vali(2) = adrm(1)
        call utmess('F', 'POSTRCCM_15', sk='RESU_THER_MOYE', ni=2, vali=vali)
    endif
    call jeveuo(cesv(iad), 'L', jmoye)
!
    if (nbm .gt. 1) then
        decal = cesd(5+4*(adrm(2)-1)+4)
        icmp = 2
        iad = decal + (ipt-1)*nbcmp + icmp
        if (.not.zl(jcesl-1+iad)) then
            vali(1) = iocs
            vali(2) = adrm(2)
            call utmess('F', 'POSTRCCM_15', sk='RESU_THER_MOYE', ni=2, vali=vali)
        endif
        call jeveuo(cesv(iad), 'L', jmoy2)
    endif
!
! --- ON BOUCLE SUR LES INSTANTS :
!
    dt1max = 0.d0
    dt2max = 0.d0
    tabmax = 0.d0
!
    do 10 i = 1, nbinst
!
! ------ TEMP_INT, TEMP_EXT
!
        tint = zr(jther-1+2*(i-1)+1)
        text = zr(jther-1+2*(i-1)+2)
!
! ------ DT1: AMPLITUDE DE LA VARIATION ENTRE LES 2 ETATS STABILISES
!             DE LA DIFFERENCE DE TEMPERATURE ENTRE LES PAROIS
!             INTERNE ET EXTERNE
!
        dt1 = zr(jmoye-1+2*(i-1)+2)
!
! ------ TA : AMPLITUDE DE VARIATION ENTRE LES 2 ETATS STABILISES
!             DES TEMPERATURES MOYENNES A GAUCHE D'UNE DISCONTINUITE
!
        ta = zr(jmoye-1+2*(i-1)+1)
!
! ------ DT2: PARTIE NON LINEAIRE DE LA DISTRIBUTION DANS L'EPAISSEUR
!             DE PAROI DE L'AMPLITUDE DE VARIATION DE LA TEMPERATURE
!             ENTRE LES 2 ETATS STABILISES
!
        term1 = abs(text-ta) - abs(0.5d0*dt1)
        term2 = abs(tint-ta) - abs(0.5d0*dt1)
        dt2 = max( term1, term2, 0.d0 )
!
        dt1max = max ( dt1max, abs( dt1 ) )
!
        dt2max = max ( dt2max, abs( dt2 ) )
!
        if (nbm .gt. 1) then
            tb = zr(jmoy2-1+2*(i-1)+1)
            tab = ( alphaa * ta ) - ( alphab * tb )
            tabmax = max ( tabmax, abs( tab ) )
        endif
!
10  end do
!
    sp6 = sp6 + ( sp3 * dt1max )
    sp6 = sp6 + ( sp5 * dt2max )
    if (nbm .gt. 1) sp6 = sp6 + ( sp4 * tabmax )
!
9999  continue
!
end subroutine

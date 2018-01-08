! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine smcarc(nbhist, ftrc, trc, coef, fmod,&
                  ctes, ckm, nbtrc, tempe, tpoint,&
                  dt, zin, zout)
    implicit   none
#include "asterfort/smcaba.h"
#include "asterfort/smcavo.h"
#include "asterfort/smcomo.h"
#include "asterfort/metaSteelTRCPolynom.h"
    integer :: nbhist, nbtrc
    real(kind=8) :: ftrc((3*nbhist), 3), trc((3*nbhist), 5), fmod(*)
    real(kind=8) :: ctes(11), ckm(6*nbtrc), coef(*), tempe, tpoint
    real(kind=8) :: zin(7), zout(7)
!......................................................................C
!
!   - FONCTION :                                                       C
!       CALCUL DE Z(N+1) CONNAISSANT T(N), TP(N), Z(N) ET T(N+1)       C
!   - ENTREES :                                                        C
!       NBHIST           : NBRE D HISTOIRES EXPERIMENTALE DE DEFI_TRC  C
!       FTRC(3*NBHIST,3) : VECTEUR DZ/DT EXPERIMENTAUX (VIDE EN ENTREE)C
!       TRC (3*NBHIST,5) : VECTEUR Z,T EXPERIMENTAUX (VIDE EN ENTREE)  C
!       FMOD(*)          : ENSEMBLE DES HISTOIRES EXPERIMENTALES       C
!       CTES(3)          : AR3, ALPHA, MS0                             C
!       CKM(6*NBTRC)     : VECTEUR DES LOIS MS(Z) SEUIL,AKM,BKM,TPLM   C
!                        : VECTEUR DES LOIS GRAIN P , A
!       NBTRC            : NBRE DE LOIS MS(Z)                          C
!       TEMPE            : TEMPERATURE AU POINT DE GAUSS SUR LE PAS    C
!       TPOINT           : DERIVEE A GAUCHE DE TEMPE                   C
!       ZIN(7)           : PHASMETA(N) ZF,ZP,ZB,ZM, P ,T,MS           C
!   - SORTIES :                                                        C
!       ZOUT(7)          : PHASMETA(N+1) ZF,ZP,ZB,ZM,P,T,MS            C
!......................................................................C
!
    integer :: j, ind(6)
    real(kind=8) :: sdz, sdz0, tmf, zm, dz(4), x(5), rz
    real(kind=8) :: tpli
    real(kind=8) :: ooun, quinze, un, zero, tlim, epsi, tpoin2
    real(kind=8) :: lambda, dlim, dmoins, dt, unsurl, zaust
    real(kind=8) :: a2, b2, c2, delta
!     ------------------------------------------------------------------
!
    zero = 0.d0
    ooun = 0.01d0
    un = 1.d0
    quinze = 15.d0
    epsi = 1.d-10
    tlim = ckm(4)
!
    if (tempe .gt. ctes(1)) then
        do 5 j = 1, 4
            zout(j) = zin(j)
 5      continue
        zout(7)=ctes(3)
    else
        sdz0 = zin(1) + zin(2) + zin(3) + zin(4)
!
        tmf = zin(7) - ( log(ooun))/ctes(2 ) - quinze
        if ((sdz0.ge.un-0.001d0) .or. (tempe.lt.tmf)) then
            do 10 j = 1, 4
                zout(j) = zin(j)
10          continue
            zout(7)=zin(7)
!
        else
            if (tempe .lt. zin(7)) then
                do 15 j = 1, 3
                    dz(j) = zero
15              continue
            else
! ------------- Compute functions from TRC diagram
                call smcomo(coef, fmod, tempe, nbhist, ftrc,&
                            trc)
!
! --- TPOIN2 POUR EFFET TAILLE DE GRAIN AUSTENITIQUE
                if (ckm(6) .eq. 0.d0) then
                    tpoin2 = tpoint
                else
                    tpoin2 = tpoint * exp(ckm(6)*(zin(5)-ckm(5)))
                endif
! --- COMPARAISON DE L ETAT COURANT / HISTOIRES ENVELOPPES
!
                if (tpoin2 .gt. (trc(1,4)*(un+epsi))) then
                    do 20 j = 1, 3
                        dz(j) = ftrc(1,j)*(zout(6)-tempe)
20                  continue
                else
                    if (tpoin2 .lt. (trc(nbhist,4)*(un-epsi))) then
                        do 30 j = 1, 3
                            dz(j) = ftrc(nbhist,j)*(zout(6)-tempe)
30                      continue
                    else
! --------------------- Find the six nearest TRC curves
                        x(1) = zin(1)
                        x(2) = zin(2)
                        x(3) = zin(3)
                        x(4) = tpoin2
                        x(5) = tempe
                        call smcavo(x, nbhist, trc, ind)
! --------------------- Compute barycenter and update increments of phases
                        call smcaba(x , nbhist, trc, ftrc, ind,&
                                    dz)
                        if ((zout(6)-tempe) .gt. zero) then
                            do 35 j = 1, 3
                                dz(j) = zero
35                          continue
                        else
                            do 36 j = 1, 3
                                dz(j) = dz(j)*(zout(6)-tempe)
!
!
!
36                          continue
                        endif
                    endif
                endif
            endif
! --- CALCUL DE MS-
!
            sdz = sdz0 - zin(4)
            if ((sdz.ge.ckm(1)) .and. (zin(4).eq.zero)) then
                zout(7) = ctes(3) + ckm(2)*sdz + ckm(3)
            else
                zout(7) = zin(7)
            endif
!
!
            zm = un - sdz
            if ((zout(6).gt.zout(7)) .or. (zm.lt.ooun)) then
                zout(4) = zin(4)
            else
                call metaSteelTRCPolynom(coef(3:8), tlim, tempe,&
                              tpli)
                if ((tpoint.gt.tpli) .and. (zin(4).eq.zero)) then
                    zout(4) = zin(4)
                else
                    zout(4) = zm*(un-exp(ctes(2)*(zout(7)-zout(6))))
                endif
            endif
            dz(4) = zout(4)-zin(4)
            sdz = zero
            do 40 j = 1, 4
                sdz = sdz+zin(j)+dz(j)
40          continue
            if (sdz .gt. un-0.001d0) then
                rz = sdz - sdz0
                do 50 j = 1, 4
                    dz(j) = dz(j) / ( rz/(un-sdz0) )
                    zout(j) = zin(j) + dz(j)
50              continue
            else
                do 51 j = 1, 4
                    zout(j) = zin(j) + dz(j)
51              continue
            endif
        endif
    endif
    zaust = zout(1)+zout(2)+zout(3)+zout(4)
    zaust = 1-zaust
! --- CALCUL TAILLE DE GRAIN
    if (ctes(8) .eq. 0.d0) then
        unsurl = 0.d0
        zout(5) = ckm(5)
    else
        if (zaust .lt. 1.d-3) then
            zout(5)=0.d0
        else
            dmoins = zin(5)
            lambda = ctes(8)*exp(ctes(9)/(tempe+273.d0))
            unsurl = 1.d0/lambda
            dlim = ctes(10)*exp(-ctes(11)/(tempe+273.d0))
            a2 = 1.d0
            b2 = dmoins-(dt*unsurl/dlim)
            c2 = dt*unsurl
            delta = (b2**2)+(4.d0*a2*c2)
            zout(5) = (b2+delta**0.5d0)/(2.d0*a2)
        endif
    endif
end subroutine

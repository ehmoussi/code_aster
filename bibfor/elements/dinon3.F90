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

subroutine dinon3(neq, ul, dul, utl, nno,&
                  nbcomp, varimo, raide, nbpar, param,&
                  okdire, varipl)
! ----------------------------------------------------------------------
    implicit none
#include "asterf_types.h"
#include "asterc/r8miem.h"
    integer :: neq, nbcomp, nno, nbpar
    real(kind=8) :: ul(neq), dul(neq), utl(neq)
    real(kind=8) :: varimo(nbcomp*3), varipl(nbcomp*3)
    real(kind=8) :: raide(nbcomp), param(6, nbpar)
    aster_logical :: okdire(6)
!
! ======================================================================
!
!     RELATION DE COMPORTEMENT "CINEMATIQUE" (DISCRET NON LINEAIRE).
!
!     f = |F - X| - Me
!     .       .      .
!     F = Ke.(Utot - Uan)
!
!     X = Kr.a/(1+(Kr.a/FU)^n)^(1/n)
!
!        Ke   : raideur elastique
!        Fu   : limite en effort
!        n    : coefficient de non-linearite (dans catalogue > 1)
!        Kr   : raideur de la loi cinematique
!        Me   : seuil elastique
!
!======================================================================
!
! IN  :
!       NEQ    : NOMBRE DE DDL DE L'ELEMENT
!       UL     : DEPLACEMENT PRECEDENT REPERE LOCAL (DIM NEQ)
!       DUL    : INCREMENT DE DEPLACEMENT REPERE LOCAL (DIM NEQ)
!       UTL    : DEPLACEMENT COURANT REPERE LOCAL (DIM NEQ)
!       NNO    : NOMBRE DE NOEUDS
!       NBCOMP : NOMBRE DE COMPOSANTES
!       VARIMO : VARIABLES INTERNES A T- (3 PAR COMPOSANTES)
!       RAIDE  : RAIDEUR ELASTIQUE DES DISCRETS
!       NBPAR  : NOMBRE MAXIMAL DE PARAMETRE DE LA LOI
!       PARAM  : PARAMETRES DE LA LOI
!       OKDIRE : VRAI SI LE COMPORTEMENT AFFECTE CETTE DIRECTION
!
! OUT :
!       RAIDE  : RAIDEUR QUASI-TANGENTE AU COMPORTEMENT DES DISCRETS
!       VARIPL : VARIABLES INTERNES INTERNES A T+ (3 PAR COMPOSANTES)
!
!***************** DECLARATION DES VARIABLES LOCALES *******************
!
    integer :: ii
    real(kind=8) :: ulel, dulel, utlel, zero, un, r8min
!
    real(kind=8) :: puis, xxx, mu, kr, ke, mel, deno, drotx, drotxc
    real(kind=8) :: momp, momm, mxplus, mxmoin
    integer :: iplas, icumu, iener
!
!************ FIN DES DECLARATIONS DES VARIABLES LOCALES ***************
!
! ----------------------------------------------------------------------
    r8min = r8miem()
    zero = 0.0d0
    un = 1.0d0
!
    do 20 ii = 1, nbcomp
!        INDEX DES VARIABLES INTERNES
        iplas = 3*(ii-1)+1
        icumu = 3*(ii-1)+2
        iener = 3*(ii-1)+3
!        PAR DEFAUT LES VARIABLES N'EVOLUENT PAS
        varipl(iplas) = varimo(iplas)
        varipl(icumu) = varimo(icumu)
        varipl(iener) = varimo(iener)
!        SI LE COMPORTEMENT EST CINEMATIQUE
        if (okdire(ii)) then
            mel = param(ii,4)
            if (nno .eq. 1) then
                dulel = dul(ii)
                ulel = ul(ii)
                utlel = utl(ii)
            else
                dulel = dul(ii+nbcomp) - dul(ii)
                ulel = ul(ii+nbcomp) - ul(ii)
                utlel = utl(ii+nbcomp) - utl(ii)
            endif
            if (abs(dulel) .gt. r8min) then
                ke = raide(ii)
                mu = param(ii,1)
                puis = param(ii,2)
                kr = param(ii,3)
!              CALCUL DE DEPASSEMENT DU SEUIL
                momm = ke*( ulel - varimo(iplas))
                momp = ke*(utlel - varimo(iplas))
!              CALCUL DE MX(-)
                if (puis .le. zero) then
                    mxmoin = varimo(icumu)*kr
                else
                    xxx = abs(varimo(icumu))*kr/mu
                    deno = (un+xxx**puis)**(un/puis)
                    mxmoin = varimo(icumu)*kr/deno
                endif
                if (abs(momp - mxmoin) .gt. mel) then
                    if (dulel .ge. zero) then
!                    ACTUALISATION DE LA ROTATION CINEMATIQUE CUMULEE
                        drotxc = dulel - (mel - (momm - mxmoin))/ke
                        varipl(icumu) = varimo(icumu) + drotxc
!                    CALCUL DE MX(+)
                        if (puis .lt. zero) then
                            mxplus = varipl(icumu)*kr
                        else
                            xxx = abs(varipl(icumu))*kr/mu
                            deno = (un+xxx**puis)**(un/puis)
                            mxplus = varipl(icumu)*kr/deno
                        endif
!                    ACTUALISATION DE LA ROTATION CINEMATIQUE
                        drotx = drotxc - abs(mxplus - mxmoin)/ke
                        varipl(iplas) = varimo(iplas) + drotx
                    else
!                    ACTUALISATION DE LA ROTATION CINEMATIQUE CUMULEE
                        drotxc = dulel + (mel + (momm - mxmoin))/ke
                        varipl(icumu) = varimo(icumu) + drotxc
!                    CALCUL DE MX(+)
                        if (puis .lt. zero) then
                            mxplus = varipl(icumu)*kr
                        else
                            xxx = abs(varipl(icumu))*kr/mu
                            deno = (un+xxx**puis)**(un/puis)
                            mxplus = varipl(icumu)*kr/deno
                        endif
!                    ACTUALISATION DE LA ROTATION CINEMATIQUE
                        drotx = drotxc + abs(mxplus - mxmoin)/ke
                        varipl(iplas) = varimo(iplas) + drotx
                    endif
!                 CALCUL DU MOMENT +
                    momp = ke*(utlel - varipl(iplas))
!                 TANGENTE AU COMPORTEMENT
                    raide(ii) = abs((momp - momm) / dulel)
!                 CALCUL DE L'ENERGIE DISSIPEE
!                 Si petits pas : ABS(MEL*DROTX)+MXPLUS*DROTX
!                 Pour minimiser l'erreur, on utilise une intégration
!                 de degré 1. Pour un écrouissage cinématique linéaire
!                 cela donne la solution exacte.
                    varipl(iener) = varimo(iener) + abs(mel*drotx) + (mxplus+mxmoin)*drotx*0.5d0
                endif
            endif
        endif
 20 end do
!
end subroutine

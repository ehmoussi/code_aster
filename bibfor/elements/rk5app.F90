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

subroutine rk5app(nbeq, vparam_real, vparam_int, vparam_car, dtemps, yinit, dyinit,&
                  rk5fct, solu, decoup)
    implicit none
#include "asterf_types.h"
    integer :: nbeq
    real(kind=8)     :: vparam_real(*), dtemps, yinit(nbeq), dyinit(nbeq), solu(3*nbeq)
    integer          :: vparam_int(*)
    character(len=*) :: vparam_car(*)
    aster_logical    :: decoup
!
    interface
        subroutine rk5fct(ppr, ppi, ppc, yy0, dy0, dyy, decoup)
            real(kind=8)     :: ppr(*)
            integer          :: ppi(*)
            character(len=*) :: ppc(*)
            real(kind=8)     :: yy0(*)
            real(kind=8)     :: dy0(*)
            real(kind=8)     :: dyy(*)
            aster_logical    :: decoup
        end subroutine rk5fct
    end interface
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!          INTÉGRATION PAR MÉTHODE DE RUNGE KUTTA D'ORDRE 5
!
!  intégration des équations
!  dérivée au temps t + dt
!  calcul de l'erreur pour chaque équation
!
! --------------------------------------------------------------------------------------------------
!
! IN
!  nbeq        : nombre d'équations
!  vparam_real : paramètres réels
!  vparam_int  : paramètres entiers
!  dtemps      : incrément de temps
!  yinit       : valeurs à t
!  dyinit      : vitesse à t
!  rkfct       : subroutine du système à intégrer
!
! OUT
!  solu        : résultat de l'intégration
!        solu(1:nbeq)            : variables intégrées
!        solu(nbeq+1:2*nbeq)     : dérivées a t+dt
!        solu(2*nbeq+1:3*nbeq)   : erreur
!  decoup      : force le découpage
!
! --------------------------------------------------------------------------------------------------
!
!   niveau du runge-kutta
    integer :: nivrk, nn, niv, ii
    parameter  (nivrk=6)
    real(kind=8) :: yy(nbeq), rr(nbeq, nivrk)
!   tables de cash-karp
    real(kind=8) :: tabc(nivrk), tabe(nivrk), tabb(nivrk, nivrk)
!
!   initialisation des tables de cash-karp
!   taba : ( 0.0 , 0.2 , 0.3, 0.6, 1.0 , 7/8 ). remarque  taba(i)= somme( tabb(i,:) )
    data tabc/9.78835978835978781642524d-02, 0.0d0, 4.02576489533011283583619d-01, &
          2.10437710437710451261140d-01, 0.0d0, 2.89102202145680386990989d-01/
    data tabe/1.02177372685185188783130d-01, 0.0d0, 3.83907903439153430635855d-01, &
          2.44592737268518517490534d-01, 1.93219866071428561515866d-02, 0.25d0/
!
    tabb(:,:) = 0.0d0
    tabb(2, 1) = 0.20d0
    tabb(3, 1:2) = (/ 3.0d0/40.0d0, 9.0d0/40.0d0 /)
    tabb(4, 1:3) = (/ 3.0d0/10.0d0, -9.0d0/10.0d0, 6.0d0/5.0d0 /)
    tabb(5, 1:4) = (/ -11.0d0/54.0d0, 2.50d0, -70.0d0/27.0d0, 35.0d0/27.0d0 /)
    tabb(6, 1:5) = (/ 1631.0d0/55296.0d0, 175.0d0/512.0d0, 575.0d0/13824.0d0,44275.0d0&
                    /110592.0d0, 253.0d0/4096.0d0 /)
!
!   niveaux de RK
    do niv = 1, nivrk
        do ii = 1, nbeq
            yy(ii) = yinit(ii)
            do nn = 1, niv - 1
                yy(ii) = yy(ii) + tabb(niv,nn)*dtemps*rr(ii,nn)
            enddo
        enddo
        call rk5fct(vparam_real, vparam_int, vparam_car, yy, dyinit, rr(1,niv), decoup)
        if (decoup) goto 999
    enddo
!
    do ii = 1, nbeq
!       intégration
        solu(ii) = yinit(ii)
!       dérivée à t+dt
        solu(nbeq+ii) = rr(ii,5)
!       erreur
        solu(2*nbeq+ii) = 0.0d0
        do niv = 1, nivrk
            solu(ii) = solu(ii) + tabc(niv) * rr(ii,niv)*dtemps
            solu(2*nbeq+ii) = solu(2*nbeq+ii) + (tabc(niv)- tabe(niv))*rr(ii,niv)*dtemps
        enddo
    enddo
!
999 continue
end subroutine

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

subroutine lcmmdd(taus, coeft, ifa, nmat, nbcomm,&
                  is, nbsys, nfs, nsg, hsr,&
                  vind, dy, dt, rp, nuecou,&
                  dalpha, dgamma, dp, iret)
    implicit none
#include "asterc/r8maem.h"
#include "asterc/r8miem.h"
#include "asterfort/lcmmdh.h"
    integer :: ifa, nmat, nbcomm(nmat, 3), iret
    integer :: ifl, is, ir, nbsys, nfs, nsg, nuecou
    real(kind=8) :: taus, coeft(nmat), dgamma, dp, vind(*), dalpha
    real(kind=8) :: rp, sgns, hsr(nsg, nsg), dy(12), dt
    real(kind=8) :: n, gamma0, rmin, alphar(12)
    real(kind=8) :: tauf, alpham(12), terme, rmax, hs, soms1, soms2, soms3
! person_in_charge: jean-michel.proix at edf.fr
! ======================================================================
!  COMPORTEMENT MONOCRISTALLIN : ECOULEMENT (VISCO)PLASTIQUE
!  INTEGRATION DE LA LOI MONOCRISTALLINE DD-CFC. CALCUL DE DALPHA DGAMMA
!       IN  TAUS    :  SCISSION REDUITE
!           COEFT   :  PARAMETRES MATERIAU
!           IFA     :  NUMERO DE FAMILLE
!           CISA2   :  COEF DE CISAILLEMENT MU
!           NMAT    :  NOMBRE MAXI DE MATERIAUX
!           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
!           NBSYS   :  NOMBRE DE SYSTEMES DE GLISSEMENT
!           HSR     :  Hsr
!           VIND    :  tous les variables internes instant precedent
!           DT      :  INTERVALLE DE TEMPS EVENTULLEMENT REDECOUPE
!           YD      :
!           DY      :
!     OUT:
!           DALPHA  :  VARIABLE densite de dislocation
!           DGAMMA  :  DEF PLAS
!           IRET    :  CODE RETOUR
! ======================================================================
!
    ifl=nbcomm(ifa,1)
    rmin=r8miem()
    rmax=log(r8maem())
    tauf  =coeft(ifl+1)
    gamma0=coeft(ifl+2)
    n     =coeft(ifl+5)
!
! initialisation des arguments en sortie
    dgamma=0.d0
    dalpha=0.d0
    dp=0.d0
    iret=0
!     on resout en alpha=rho*b**2
!     ECOULEMENT CALCUL DE DGAMMA,DP
    if (abs(taus) .gt. rmin) then
        sgns=taus/abs(taus)
        terme=abs(taus)/(tauf+rp)
!        ECOULEMENT AVEC SEUIL
        if (terme .ge. 1.d0) then
            if (n*log(terme) .lt. rmax) then
                dp=gamma0*dt*( abs(taus)/(tauf+rp) )**n
                dp=dp-gamma0*dt
                dgamma=dp*sgns
            else
                iret=1
                goto 9999
            endif
        else
            goto 9999
        endif
    endif
!
! CALCUL DE RHO_POINT=DALPHA
!
    do 55 ir = 1, nbsys
        alpham(ir)=vind(3*(ir-1)+1)
        alphar(ir)=alpham(ir)+dy(ir)
55  end do
!
    call lcmmdh(coeft, ifa, nmat, nbcomm, alphar,&
                nfs, nsg, hsr, nbsys, is,&
                nuecou, hs, soms1, soms2, soms3)
!
    dalpha=hs*dp
9999  continue
end subroutine

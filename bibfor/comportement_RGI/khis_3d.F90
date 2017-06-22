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

subroutine khis_3d(tau1, khi, xid, alpha, ar,&
                   asr, dth0, coth, xidtot)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     calcul de l'évolution de khi au cours du temps
!=====================================================================
    implicit none
    real(kind=8) :: tau1
    real(kind=8) :: khi
    real(kind=8) :: xid
    real(kind=8) :: alpha
    real(kind=8) :: ar
    real(kind=8) :: asr
    real(kind=8) :: dth0
    real(kind=8) :: coth
!     declaration variables locales
    real(kind=8) :: tau0, tau2, c1, c2, id1, id2, idref, beta, nom, tau, xm, xidtot
!
!     modif micro diffusion sellier nov 2012
!     on definit les points caracteristique de la courbe
!     temps caracteristique de micro def / indice de desstructuration
!     **** temps caracteristique pour le beton non hydrate *************
!     modifiable si necessaire
    tau0=tau1*1.d-2
!     ******************************************************************
!     tau2 est le temps caracteristique pour le beton totalement hydrate
!     et pas destructure (id2=0)
    tau2=tau1*1.d2
    c2=tau2/tau0
    id2=0.d0
!     ***** temps carateristique pour le beton destructure à id1********
!     on peut deplacer ce point si necessaire      
    id1=3.d0 
!     ******************************************************************      
    c1=tau1/tau0
!     calcul des coeffs idref et beta en fonction des points de passage
    idref = -(log( c1) * id1 - log( c2) * id2) / (log( c1) - log( c2))
    beta = -log( c2) * log( c1) * (id1 - id2) / (log( c1) - log( c2))
!     *****  modifiable si necessaire **********************************
!     exposant de non linearite de la dependance de tau à alpha
    xm=3.d0  
!     ******************************************************************
    nom=beta      
!      nom=(alpha**xm)*beta
!     pour prendre en compte l endo thermique on le rajoute à xid
!     coth:coeff de couplage vitesse de reaction endo thermique
    xidtot=xid+(coth*dth0/(1.d0-dth0))     
    tau=tau0*dexp(nom/(xidtot+idref))/(ar*asr)
    tau=tau1
    khi=(1.d0/tau1)*dexp(coth*dth0/(1.d0-dth0))*ar*asr
!      print*,tau,khi,xid,alpha,ar,asr
!      read*      
end subroutine

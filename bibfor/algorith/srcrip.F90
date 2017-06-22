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

subroutine srcrip(invar,s,vin,nvi,nbmat,mater,tmp,ucrip,seuil)

!

!!!
!!! MODELE LKR : EVALUATION DE FP
!!!

! ===================================================================================
! IN  : INVAR          :  INVARIANT DES CONTRAINTES
!     : S(6)           :  DEVIATEUR DES CONTRAINTES
!     : VIN(NVI)       :  VECTEUR DES VARIABLES INTERNES
!     : NVI            :  NOMBRE DE VARIABLES INTERNES
!     : NBMAT          :  NOMBRE DE PARAMETRES MATERIAU
!     : MATER(NBMAT,2) :  PARAMETRES MATERIAU A T+DT
!                              MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                              MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : TMP            : TEMPERATURE A L'INSTANT - OU +
! OUT : UCRIP          : TERME SOUS L EXPOSANT
!     : SEUIL          : VALEUR DE FP
! ===================================================================================

    implicit    none

#include "asterfort/cos3t.h"
#include "asterfort/lcprsc.h"
#include "asterfort/srhtet.h"
#include "asterfort/srvacp.h"
#include "asterfort/srvarp.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nvi,nbmat
    real(kind=8) :: invar,s(6),vin(nvi),mater(nbmat,2),ucrip,seuil,tmp
    
    !!!
    !!! Variables locales
    !!!
    
    real(kind=8) :: sii,sigc,pref
    real(kind=8) :: rcos3t,r0c,rtheta
    real(kind=8) :: paraep(3),varpl(4)
    
    !!!
    !!! Recuperation de sparametres materiau
    !!!
    
    sigc=mater(3,2)
    pref=mater(1,2)
    
    !!!
    !!! Calcul de la norme de s
    !!!
    
    call lcprsc(s,s,sii)
    sii=sqrt(sii)
    
    !!!
    !!! Appel a h0c et h(theta)
    !!!
    
    rcos3t=cos3t(s,pref,1.d-8)
    call srhtet(nbmat,mater,rcos3t,r0c,rtheta)
    
    !!!
    !!! Recuperation des parametres d'ecrouissage
    !!!
    
    call srvarp(vin,nvi,nbmat,mater,tmp,paraep)
    call srvacp(nbmat, mater, paraep, varpl)
    
    !!!
    !!! Calcul de fp
    !!!
    
    ucrip=varpl(1)*sii*rtheta+varpl(2)*invar+varpl(3)
    
    if (ucrip.lt.0.d0) goto 100
    
    seuil=sii*rtheta-sigc*r0c*(ucrip**paraep(1))
    
100  continue

end subroutine

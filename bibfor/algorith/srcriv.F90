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

subroutine srcriv(vintr, invar, s, nbmat, mater, tmp, ucriv, seuil)

!

!!!
!!! MODELE LKR : CALCUL DE FVP
!!!

! ===================================================================================
! IN  : VINTR          : VIN(3) OU XIVMAX
!     : INVAR          : INVARIANT DES CONTRAINTES
!     : S(6)           : DEVIATEUR DU TENSEUR DES CONTRAINTES A T+DT
!     : NBMAT          : NOMBRE DE PARAMETRES MATERIAU
!     : MATER(NBMAT,2) : COEFFICIENTS MATERIAU A T+DT
!                           MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                           MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : TMP            : TEMPERATURE A L'INSTANT - OU +
! OUT : SEUIL          : VALEUR DE FVP VISCO.
!     : UCRIV          : TERME SOUS L'EXPOSANT
! ===================================================================================

    implicit    none

#include "asterfort/cos3t.h"
#include "asterfort/lcprsc.h"
#include "asterfort/srhtet.h"
#include "asterfort/srvacv.h"
#include "asterfort/srvarv.h"

    !!!
    !!! Variable globale
    !!!
    
    integer :: nbmat
    real(kind=8) :: invar, vintr, s(6), mater(nbmat,2), ucriv, seuil, tmp
    
    !!!
    !!! Variableslocales
    !!!
    
    real(kind=8) :: sii, sigc, pref
    real(kind=8) :: r0c, rtheta
    real(kind=8) :: rcos3t
    real(kind=8) :: paravi(3), varvi(4)
    
    !!!
    !!! Parametres materiaux du modele
    !!!
    
    sigc=mater(3,2)
    pref=mater(1,2)
    
    !!!
    !!! Calcul du deviateur des contraintes
    !!!
    
    call lcprsc(s, s, sii)
    sii=sqrt(sii)
    
    !!!
    !!! Recuperation de h0c et h(theta) (r0c et r(theta))
    !!!
    
    rcos3t=cos3t(s, pref, 1.d-8)
    call srhtet(nbmat, mater, rcos3t, r0c, rtheta)
    
    !!!
    !!! Recuperation des parametres d'ecrouissage
    !!!
    
    call srvarv(vintr, nbmat, mater, tmp, paravi)
    call srvacv(nbmat, mater, paravi, varvi)
    
    !!!
    !!! Calcul du critere
    !!!
    
    ucriv=varvi(1)*sii*rtheta+varvi(2)*invar+varvi(3)
    if (ucriv.lt.0.0d0) ucriv=0.0d0
    seuil=sii*rtheta-sigc*r0c*(ucriv**paravi(1))

end subroutine

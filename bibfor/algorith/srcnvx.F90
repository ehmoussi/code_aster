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

subroutine srcnvx(sigd,sigf,nvi,vind,nmat,mater,seuil,vinf)

!

!!!
!!! MODELE LKR : CONVEXE ELASTO-VISCO-PLASTIQUE DE LKR A T + DT
!!!

! ===================================================================================
! IN  : SIGF(6)       :  CONTRAINTE ELASTIQUE
!     : SIGD(6)       :  CONTRAINTE A T
!     : NVI           :  NOMBRE DE VARIABLES INTERNES
!     : VIND(NVI)     :  VARIABLES INTERNES A T
!     : NMAT          :  DIMENSION MATER
!     : MATER(NMAT,2) :  COEFFICIENTS MATERIAU
! OUT : SEUIL : SEUIL  PLASTICITE  ET VISCOSITE
!          SI SEUILV OU SEUILP > 0 -> SEUIL = 1.D0 (NEWTON LOCAL ENCLENCHE)
!          VINF(7) : 0 OU 1 POUR PRISE EN COMPTE PLASTICITE DANS LCPLAS
! ===================================================================================
    
    implicit none

#include "asterc/r8prem.h"
#include "asterfort/lcdevi.h"
#include "asterfort/srcrip.h"
#include "asterfort/srcriv.h"
#include "asterfort/utmess.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nmat, nvi
    real(kind=8) :: mater(nmat,2),seuil,sigd(6),sigf(6),vind(nvi),vinf(nvi)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: ndt,ndi,i
    real(kind=8) :: i1,devsig(6),ubid,sigt(6),sigu(6),xit,seuilp,seuilv,somme
    real(kind=8) :: tmm,tpp
    common /tdim/ ndt,ndi
    
    !!!
    !!! Recuperation des temperatures
    !!!

    tmm=mater(6,1)
    tpp=mater(7,1)
    
    !!!
    !!! Passage en convention mecanique des sols
    !!!
    
    do i=1,ndt
        sigt(i)=-sigf(i)
        sigu(i)=-sigd(i)
    end do
    
    !!!
    !!! Verification d'un etat initial plastiquement admissible
    !!!
    
    somme=0.d0
    
    do i=1,nvi
        somme=somme+vind(i)
    end do
    
    if (abs(somme).lt.r8prem()) then
        i1=sigu(1)+sigu(2)+sigu(3)
        call lcdevi(sigu,devsig)
        call srcrip(i1,devsig,vind,nvi,nmat,mater,tmm,ubid,seuilp)
        if (seuilp/mater(4,1).gt.1.0d-6) then
            call utmess('F','ALGORITH2_81')
        endif
    endif
    
    !!!
    !!! Invariants du tenseur des contraintes
    !!!

    call lcdevi(sigt,devsig)
    i1=sigt(1)+sigt(2)+sigt(3)
    
    !!!
    !!! Calcul fonction seuil plastique en sigf
    !!!

    call srcrip(i1,devsig,vind,nvi,nmat,mater,tpp,ubid,seuilp)

    if (seuilp.ge.0.d0) then
        vinf(7)=1.d0
    else
        vinf(7)=0.d0
    endif
    
    !!!
    !!! Calcul fonction seuil visco. en sigf
    !!!
    
    xit=vind(3)
    
    call srcriv(xit,i1,devsig,nmat,mater,tpp,ubid,seuilv)
    
    !!!
    !!! Valeur de renvoi
    !!!
    
    if ((seuilv.ge.0.d0).or.(seuilp.ge.0.d0)) then
        seuil=1.d0
    else
        seuil=-1.d0
    endif

end subroutine

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

subroutine lcmaec(fami, kpg, ksp, poum, nmater,&
                  imat, necoul, nbval, valres, nmat)
    implicit none
!     MONOCRISTAL : RECUPERATION DU MATERIAU A T(TEMPD) ET T+DT(TEMPF)
!                  MATER(*,2) = COEF ECRO CINE
!     ----------------------------------------------------------------
!     IN  IMAT   :  ADRESSE DU MATERIAU CODE
!         NMATER :  NOM DU MATERIAU
!         NMAT   :  DIMENSION  DE MATER
!         NECOUL :  NOM DE LA LOI D'ECOULEMENT
!         VALPAR :  VALEUR DES PARAMETRES
!         NOMPAR :  NOM DES PARAMETRES
!     OUT VALRES :  COEFFICIENTS MATERIAU A T
!         NBVAL  :  NOMBRE DE COEF MATERIAU LUS
!     ----------------------------------------------------------------
#include "asterfort/lceqvn.h"
#include "asterfort/rcvalb.h"
    integer :: kpg, ksp, nmat, nbval, imat
    real(kind=8) :: valres(nmat), vallue(nmat)
    character(len=16) :: nomres(nmat)
    character(len=*) :: fami, poum
    integer :: icodre(nmat)
    character(len=16) :: nmater, necoul
!     ----------------------------------------------------------------
!
    if (necoul .eq. 'MONO_CINE1') then
        nbval=1
        nomres(1)='D'
        call rcvalb(fami, kpg, ksp, poum, imat,&
                    nmater, necoul, 0, ' ', [0.d0],&
                    nbval, nomres, vallue, icodre, 1)
        call lceqvn(nbval, vallue, valres(2))
        nbval=nbval+1
!         PAR CONVENTION ECRO_CINE1 A LE NUMERO 1
        valres(1)=1
!
    endif
    if (necoul .eq. 'MONO_CINE2') then
        nbval=4
        nomres(1)='D'
        nomres(2)='GM'
        nomres(3)='PM'
        nomres(4)='C'
        call rcvalb(fami, kpg, ksp, poum, imat,&
                    nmater, necoul, 0, ' ', [0.d0],&
                    nbval, nomres, vallue, icodre, 1)
        call lceqvn(nbval, vallue, valres(2))
        nbval=nbval+1
!         PAR CONVENTION ECRO_CINE2 A LE NUMERO 2
        valres(1)=2
!
    endif
end subroutine

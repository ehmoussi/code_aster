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

subroutine arhenius_3d(ar, ard, temp, temp0, asr,&
                       sr, srpal)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     activation thermique et hydrique
!=====================================================================
    implicit none
    real(kind=8) :: ar
    real(kind=8) :: ard
    real(kind=8) :: temp
    real(kind=8) :: temp0
    real(kind=8) :: asr
    real(kind=8) :: sr
    real(kind=8) :: srpal
    real(kind=8) :: sr0
    real(kind=8) :: ear
    real(kind=8) :: eadr, cg1
    ear=5000.d0
    eadr=5292.d0
!
!     activation thermique (loi d'arrhénus)      
    ar=dexp(-ear*((1.d0/temp)-(1.d0/temp0)))
    ard=dexp(-eadr*((1.d0/temp)-(1.d0/temp0)))
!
!     activation hydrique
!     on impose une valeur petite non nulle pour ne pas
!     avoir un temps caracteristique infini (cf calcul de khi)
!     sellier nov 2012      
!      asr=dmax1(sr-srpal,1.d-6)/(1.d0-srpal)
!     modification marie test courbe fidy
    sr0=srpal
    if ((sr0.lt.1.) .and. (sr0.gt.0.)) then
        cg1 = -0.2d1 * log(0.10d2) / (sr0 - 1.d0)
        asr=dexp(cg1*(sr-1.d0))           
    else
        if (sr0 .gt. 1.) then
            asr=1.d0
        else
            asr=1.d-6
        end if
    end if
end subroutine

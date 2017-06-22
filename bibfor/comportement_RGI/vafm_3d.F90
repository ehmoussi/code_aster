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

subroutine vafm_3d(khi, casol, alsol, ssol, ohsol,&
                   kafm, gam1, gam2, dafm)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     calcul de la vitesse de précipitation/dissolution del'afm
!=====================================================================
    implicit none
    real(kind=8) :: khi
    real(kind=8) :: casol
    real(kind=8) :: alsol
    real(kind=8) :: ssol
    real(kind=8) :: ohsol
    real(kind=8) :: kafm
    real(kind=8) :: gam1
    real(kind=8) :: gam2, dafm
    real(kind=8) :: actca
    real(kind=8) :: acts
    real(kind=8) :: actal
    real(kind=8) :: actoh
    real(kind=8) :: nom
    real(kind=8) :: denom
!     calcul des activités ioniques      
    actca=casol*gam2
    acts=ssol*gam2
    actal=alsol*gam1
    actoh=ohsol*gam1
!     décomposition du calcul: numérateur/dénominateur          
    nom=dlog10((actca**4.d0)*(acts**1.d0)*(actal**2.d0)*(actoh**4.d0))
    denom=dlog10(kafm)
    dafm=khi*(1.d0-(nom/denom))      
end subroutine 

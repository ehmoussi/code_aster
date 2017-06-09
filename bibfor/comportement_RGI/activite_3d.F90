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

subroutine activite_3d(gam1, gam2, temp, casol, nasol,&
                       ohsol)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     choix des coefficients d'activité
!=====================================================================
    implicit none
    real(kind=8) :: gam1
    real(kind=8) :: gam2
    real(kind=8) :: temp
    real(kind=8) :: casol
    real(kind=8) :: nasol
    real(kind=8) :: ohsol
!
    real(kind=8) :: elec
    real(kind=8) :: at
!
!     calcul de la constante fonction de t
!     dans l'équation de debye hückel      
    at=1.8d-6/(((7.73d-7*temp)**3)**0.5d0)
!
!     electroneutralité simplifiée (1)    (3 ci-dessous a verifier ?)  
    elec=nasol+3.d0*casol
!     détermination de la concentration en hydroxydes à partir de (1)      
    ohsol=nasol+2.d0*casol
!
!     calcul des coefficients d'activité suivant les valences des ions      
    gam1=10.d0**(-at*((elec**0.5d0/(1.d0+(elec**0.5d0)))-0.3d0*elec))
    gam2=10.d0**(-at*4.d0*((elec**0.5d0/(1.d0+(elec**0.5d0)))&
     -0.3d0*elec))      
end subroutine

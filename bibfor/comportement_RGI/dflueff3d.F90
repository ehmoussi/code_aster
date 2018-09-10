! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine dflueff3d(ccmax,dflu0,dflu1,dfin)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
     
!   endommagement par fluage
      implicit none

      
      real(kind=8) :: dflu0,dflu1,dfin,ccmax
      
      real(kind=8) :: dflu

      
!   calcul de l'edommagement effectif actuel en fonction de la consolidation
      dflu=dfin*(1.d0-1.d0/ccmax)
      
!   condition de croissance de l endo de fluage      
      dflu1=dmax1(dflu0,dflu)
      
end subroutine

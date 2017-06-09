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

subroutine xdefhm(dimdef, dimenr, addeme, adenme, addep1,&
                  ndim, degem1, degep1, defgem, defgep, adenhy, nfh)
!
    implicit none
!
! person_in_charge: daniele.colombo at ifpen.fr
!
!          BUT : ASSEMBLER LES DEFORMATIONS GENERALISEES DU MODELE
!                HM EN XFEM
!
! IN   DIMDEF  : DIMENSION DU TABLEAU DES DEF GENERALISEES ASSEMBLE
! IN   DIMENR  : DIMENSION DU TABLEAU DES DEF GENERALISEES BRUT
! IN   ADDEME  : ADRESSE DES DEFORMATIONS GENERALISEES CLASSIQUE
! IN   ADENME  : ADRESSE DES DEFORMATIONS GENERALISEES HEAVISIDE
! IN   NFH     : NOMBRE DE DDL HEAVISIDE PAR NOEUD
! OUT  DEFGEM  : TABLEAU ASSEMBLE A L'INSTANT -
! OUT  DEFGEP  : TABLEAU ASSEMBLE A L'INSTANT +
!     ------------------------------------------------------------------
    integer :: dimdef, dimenr, addeme, adenme, ndim, addep1, i, adenhy
    integer :: nfh, ifh
    real(kind=8) :: degem1(dimenr), degep1(dimenr)
    real(kind=8) :: defgem(dimdef), defgep(dimdef)
!
    do i = 1, dimdef
        defgem(i)=0.d0
        defgep(i)=0.d0
    end do
!
! ASSEMBLAGE (DEF CLASSIQUES + DEF HEAVISIDE) A L'INSTANT -
    do i = 1, ndim
        defgem(addeme-1+i)=degem1(addeme-1+i)
    end do
    do ifh = 1, nfh
       do i = 1, ndim
           defgem(addeme-1+i)=defgem(addeme-1+i)+degem1(adenme-1+i+(ifh-1)*(ndim+1))
       end do
    end do
!
    do i = 1, 6
        defgem(addeme-1+ndim+i)=degem1(addeme-1+ndim+i)
    end do
!
    defgem(addep1)=degem1(addep1)
    do ifh = 1, nfh
       defgem(addep1)=defgem(addep1) + degem1(adenhy+(ifh-1)*(ndim+1))
    end do
!
    do i = 1, ndim
        defgem(addep1+i)=degem1(addep1+i) 
    end do
!
! ASSEMBLAGE (DEF CLASSIQUES + DEF HEAVISIDE) A L'INSTANT +
    do i = 1, ndim
        defgep(addeme-1+i)=degep1(addeme-1+i)
    end do
    do ifh = 1, nfh
       do i = 1, ndim
           defgep(addeme-1+i)=defgep(addeme-1+i)+degep1(adenme-1+i+(ifh-1)*(ndim+1))
       end do
    end do
!
    do i = 1, 6
        defgep(addeme-1+ndim+i)=degep1(addeme-1+ndim+i)
    end do
!
    defgep(addep1)=degep1(addep1)
    do ifh = 1, nfh
       defgep(addep1)=defgep(addep1) + degep1(adenhy+(ifh-1)*(ndim+1))
    end do

!
    do i = 1, ndim
        defgep(addep1+i)=degep1(addep1+i)
    end do
end subroutine

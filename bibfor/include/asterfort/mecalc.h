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

!
interface
    subroutine mecalc(option, modele, chdepl, chgeom, chmate,&
                      chcara, chtemp, chtref, chtime,&
                      chharm, chsig, cheps, chfreq, chmass,&
                      chmeta, charge, typcoe, alpha, calpha,&
                      chdynr, suropt, chelem, chelex, ligrel,&
                      base, ch1, ch2, chvari, compor,&
                      chstrx, codret)
        character(len=*) :: option
        character(len=*) :: modele
        character(len=*) :: chdepl
        character(len=*) :: chgeom
        character(len=*) :: chmate
        character(len=*) :: chcara(*)
        character(len=*) :: chtemp
        character(len=*) :: chtref
        character(len=*) :: chtime
        character(len=*) :: chharm
        character(len=*) :: chsig
        character(len=*) :: cheps
        character(len=*) :: chfreq
        character(len=*) :: chmass
        character(len=*) :: chmeta
        character(len=*) :: charge
        character(len=*) :: typcoe
        real(kind=8) :: alpha
        complex(kind=8) :: calpha
        character(len=*) :: chdynr
        character(len=*) :: suropt
        character(len=*) :: chelem
        character(len=*) :: chelex
        character(len=*) :: ligrel
        character(len=*) :: base
        character(len=*) :: ch1
        character(len=*) :: ch2
        character(len=*) :: chvari
        character(len=*) :: compor
        character(len=*) :: chstrx
        integer :: codret
    end subroutine mecalc
end interface

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
!
interface
    subroutine sdmail(nomu, nommai, nomnoe, cooval, coodsc,&
                      cooref, grpnoe, gpptnn, grpmai, gpptnm,&
                      connex, titre, typmai, adapma)
        character(len=8) :: nomu
        character(len=24) :: nommai
        character(len=24) :: nomnoe
        character(len=24) :: cooval
        character(len=24) :: coodsc
        character(len=24) :: cooref
        character(len=24) :: grpnoe
        character(len=24) :: gpptnn
        character(len=24) :: grpmai
        character(len=24) :: gpptnm
        character(len=24) :: connex
        character(len=24) :: titre
        character(len=24) :: typmai
        character(len=24) :: adapma
    end subroutine sdmail
end interface

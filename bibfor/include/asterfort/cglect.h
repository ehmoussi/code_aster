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
    subroutine cglect(resu, modele, ndim, option, cas,&
                      typfis, nomfis, fonoeu, chfond, basfon,&
                      taillr, conf, lnoff, liss, ndeg, typdis)
        character(len=8) :: resu
        character(len=8) :: modele
        integer :: ndim
        character(len=16) :: option
        character(len=16) :: cas
        character(len=8) :: typfis
        character(len=8) :: nomfis
        character(len=24) :: fonoeu
        character(len=24) :: chfond
        character(len=24) :: basfon
        character(len=24) :: taillr
        character(len=8) :: conf
        integer :: lnoff
        character(len=24) :: liss
        integer :: ndeg
        character(len=16) :: typdis
    end subroutine cglect
end interface

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
    subroutine efcoq3d(nomte, nb1, nb2, cara, geom, lzr,& 
                   chg,matr,effg,                   &
                   nbcou,npgsn,npgsr,npge,nso,npgt)
        character(len=16) :: nomte
        integer :: nb1,nb2,npgsn,nso,nbcou,npgt,npgsr,npge
        real(kind=8) :: geom(*),cara(*),lzr(*),matr(*),chg(*),effg(*)
    end subroutine efcoq3d
end interface

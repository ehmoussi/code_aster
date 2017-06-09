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
    subroutine dtrgi_3d(f, dtmin, dalsol, dssol, daft,&
                        dafm, dsf, alsol, ssol, aft,&
                        afm, sf, alf, dtcal, phi,&
                        sr, dalpha, sc, alc, dallib,&
                        dcash, dcsheff, csheff, vsr)
        real(kind=8) :: f
        real(kind=8) :: dtmin
        real(kind=8) :: dalsol
        real(kind=8) :: dssol
        real(kind=8) :: daft
        real(kind=8) :: dafm
        real(kind=8) :: dsf
        real(kind=8) :: alsol
        real(kind=8) :: ssol
        real(kind=8) :: aft
        real(kind=8) :: afm
        real(kind=8) :: sf
        real(kind=8) :: alf
        real(kind=8) :: dtcal
        real(kind=8) :: phi
        real(kind=8) :: sr
        real(kind=8) :: dalpha
        real(kind=8) :: sc
        real(kind=8) :: alc
        real(kind=8) :: dallib
        real(kind=8) :: dcash
        real(kind=8) :: dcsheff
        real(kind=8) :: csheff
        real(kind=8) :: vsr
    end subroutine dtrgi_3d
end interface 

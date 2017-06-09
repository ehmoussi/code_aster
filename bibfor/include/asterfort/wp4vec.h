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
    subroutine wp4vec(nbfreq, nbvect, neq, shift, vp,&
                      vecp, mxresf, resufi, resufr, lagr,&
                      vauc, omecor)
        integer :: mxresf
        integer :: neq
        integer :: nbfreq
        integer :: nbvect
        complex(kind=8) :: shift
        complex(kind=8) :: vp(*)
        complex(kind=8) :: vecp(neq, *)
        integer :: resufi(mxresf, *)
        real(kind=8) :: resufr(mxresf, *)
        integer :: lagr(*)
        complex(kind=8) :: vauc(2*neq, *)
        real(kind=8) :: omecor
    end subroutine wp4vec
end interface

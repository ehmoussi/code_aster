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
    subroutine xpoajc(nnm, inm, inmtot, nbmac, ise,&
                      npg, jcesd1, jcesd2, jcvid1, jcvid2,&
                      ima, ndim, ndime, iadc, iadv,&
                      jcesv1, jcesl2, jcesv2, jcviv1, jcvil2,&
                      jcviv2)
        integer :: nnm
        integer :: inm
        integer :: inmtot
        integer :: nbmac
        integer :: ise
        integer :: npg
        integer :: jcesd1
        integer :: jcesd2
        integer :: jcvid1
        integer :: jcvid2
        integer :: ima
        integer :: ndim
        integer :: ndime
        integer :: iadc
        integer :: iadv
        integer :: jcesv1
        integer :: jcesl2
        integer :: jcesv2
        integer :: jcviv1
        integer :: jcvil2
        integer :: jcviv2
    end subroutine xpoajc
end interface 

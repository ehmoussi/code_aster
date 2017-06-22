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
#include "asterf_types.h"
!
interface
    subroutine nmdlog(fami, option, typmod, ndim, nno,&
                      npg, iw, ivf, vff, idff,&
                      geomi, dff, compor, mult_comp, mate, lgpg,&
                      carcri, angmas, instm, instp, matsym,&
                      deplm, depld, sigm, vim, sigp,&
                      vip, fint, matuu, codret)
        integer :: lgpg
        integer :: npg
        integer :: nno
        integer :: ndim
        character(len=*) :: fami
        character(len=16) :: option
        character(len=8) :: typmod(*)
        integer :: iw
        integer :: ivf
        real(kind=8) :: vff(nno, npg)
        integer :: idff
        real(kind=8) :: geomi(*)
        real(kind=8) :: dff(nno, *)
        character(len=16), intent(in) :: compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8), intent(in) :: carcri(*)
        integer :: mate
        real(kind=8) :: angmas(3)
        real(kind=8) :: instm
        real(kind=8) :: instp
        aster_logical :: matsym
        real(kind=8) :: deplm(*)
        real(kind=8) :: depld(*)
        real(kind=8) :: sigm(2*ndim, npg)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: sigp(2*ndim, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: fint(ndim*nno)
        real(kind=8) :: matuu(*)
        integer :: codret
    end subroutine nmdlog
end interface

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
    subroutine nmpl2d(fami, nno, npg, ipoids, ivf,&
                      idfde, geom, typmod, option, imate,&
                      compor, mult_comp, lgpg, carcri, instam, instap,&
                      ideplm, ideplp, angmas, sigm, vim,&
                      matsym, dfdi, def, sigp, vip,&
                      matuu, ivectu, codret)
        integer :: lgpg
        integer :: npg
        integer :: nno
        character(len=*) :: fami
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        real(kind=8) :: geom(2, nno)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        character(len=16), intent(in) :: compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: ideplm
        integer :: ideplp
        real(kind=8) :: angmas(3)
        real(kind=8) :: sigm(4, npg)
        real(kind=8) :: vim(lgpg, npg)
        aster_logical :: matsym
        real(kind=8) :: dfdi(nno, 2)
        real(kind=8) :: def(4, nno, 2)
        real(kind=8) :: sigp(4, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: matuu(*)
        integer :: ivectu
        integer :: codret
    end subroutine nmpl2d
end interface

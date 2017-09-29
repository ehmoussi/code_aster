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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface 
    subroutine assthm(nno, nnos, nnom, npg, npi,&
                      jv_poids, jv_poids2, jv_func, jv_func2, jv_dfunc,&
                      jv_dfunc2, elem_coor, crit, deplm, deplp,&
                      contm, contp, varim, varip, defgem,&
                      defgep, drds, drdsr, dsde, b,&
                      dfdi, dfdi2, r, sigbar, &
                      matuu, vectu, rinstm,&
                      rinstp, option, j_mater, mecani, press1,&
                      press2, tempe, dimdef, dimcon, dimuel,&
                      nbvari, nddls, nddlm, nddl_meca, nddl_p1,&
                      nddl_p2, ndim, compor, typmod, axi,&
                      perman, inte_type, codret, angmas, work1, work2)
        integer :: ndim
        integer :: nbvari
        integer :: dimuel
        integer :: dimcon
        integer :: dimdef
        integer :: npi
        integer :: nnos
        integer :: nno
        integer :: nnom
        integer :: npg
        integer, intent(in) :: nddl_meca, nddl_p1, nddl_p2
        integer, intent(in) :: jv_poids, jv_poids2
        integer, intent(in) :: jv_func, jv_func2
        integer, intent(in) :: jv_dfunc, jv_dfunc2
        real(kind=8), intent(in) :: elem_coor(ndim, nno)
        real(kind=8) :: crit(*)
        real(kind=8) :: deplm(dimuel)
        real(kind=8) :: deplp(dimuel)
        real(kind=8) :: contm(dimcon*npi)
        real(kind=8) :: contp(dimcon*npi)
        real(kind=8) :: varim(nbvari*npi)
        real(kind=8) :: varip(nbvari*npi)
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: defgep(dimdef)
        real(kind=8) :: drds(dimdef+1, dimcon)
        real(kind=8) :: drdsr(dimdef, dimcon)
        real(kind=8) :: dsde(dimcon, dimdef)
        real(kind=8) :: b(dimdef, dimuel)
        real(kind=8) :: dfdi(nno, 3)
        real(kind=8) :: dfdi2(nnos, 3)
        real(kind=8) :: r(dimdef+1)
        real(kind=8) :: sigbar(dimdef)
        real(kind=8) :: matuu(dimuel*dimuel)
        real(kind=8) :: vectu(dimuel)
        real(kind=8) :: rinstm
        real(kind=8) :: rinstp
        character(len=16) :: option
        integer :: j_mater
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        integer :: nddls
        integer :: nddlm
        character(len=16) :: compor(*)
        character(len=8) :: typmod(2)
        aster_logical :: axi
        aster_logical :: perman
        character(len=3), intent(in) :: inte_type
        integer :: codret
        real(kind=8) :: angmas(3)
        real(kind=8) :: work1(dimcon, dimuel)
        real(kind=8) :: work2(dimdef, dimuel)
    end subroutine assthm
end interface

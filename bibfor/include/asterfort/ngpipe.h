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
    subroutine ngpipe(typilo, npg, neps, nddl, b,&
                      ni2ldc, typmod, mat, compor, lgpg,&
                      ddlm, sigm, vim, ddld, ddl0,&
                      ddl1, tau, etamin, etamax, copilo)
        character(len=8) :: typmod(*)
        character(len=16) :: typilo, compor(*)
        integer :: npg, neps, nddl, mat, lgpg
        real(kind=8) :: ddlm(nddl), ddld(nddl), ddl0(nddl), ddl1(nddl)
        real(kind=8) :: sigm(0:neps*npg-1), vim(lgpg, npg), tau
        real(kind=8) :: copilo(5, npg), etamin, etamax
        real(kind=8) :: b(neps, npg, nddl), ni2ldc(0:neps*npg-1)
    end subroutine ngpipe
end interface

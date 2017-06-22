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
    subroutine xvfrot(algofr, coeffp, coeffr, ddlm, ddls,&
                      ffc, ffp, idepl, idepm, ifa,&
                      ifiss, indco, jac, jheavn, ncompn, jheafa,&
                      lact, mu, ncomph, nd, nddl,&
                      ndim, nfh, nfiss, nno, nnol,&
                      nnos, nvit, pla, reac12,&
                      seuil, singu, fk, tau1, tau2, vtmp)
        integer :: algofr
        real(kind=8) :: coeffp
        real(kind=8) :: coeffr
        integer :: ddlm
        integer :: ddls
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffp(27)
        integer :: idepl
        integer :: idepm
        integer :: ifa
        integer :: ifiss
        integer :: indco
        real(kind=8) :: jac
        integer :: jheafa
        integer :: lact(8)
        real(kind=8) :: mu
        integer :: ncomph
        integer :: jheavn
        integer :: ncompn
        real(kind=8) :: nd(3)
        integer :: nddl
        integer :: ndim
        integer :: nfh
        integer :: nfiss
        integer :: nno
        integer :: nnol
        integer :: nnos
        integer :: nvit
        integer :: pla(27)
        real(kind=8) :: reac12(3)
        real(kind=8) :: seuil
        integer :: singu
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: vtmp(400)
    end subroutine xvfrot
end interface

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
    subroutine xvcont(algocr, cohes, jcohes, ncompv,&
                      coefcp, coefcr, ddlm,&
                      ddls, ffc, ffp, idepl, idepm,&
                      ifa, ifiss, imate, indco, ipgf,&
                      jac, jheavn, ncompn, jheafa, lact, ncomph,&
                      nd, nddl, ndim, nfh, nfiss,&
                      nno, nnol, nnos, nvit, pla,&
                      rela, reac, singu, fk, tau1,&
                      tau2, vtmp)
        integer :: algocr
        real(kind=8) :: cohes(3)
        integer :: jcohes
        integer :: ncompv
        real(kind=8) :: coefcp
        real(kind=8) :: coefcr
        integer :: ddlm
        integer :: ddls
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffp(27)
        integer :: idepl
        integer :: idepm
        integer :: ifa
        integer :: ifiss
        integer :: imate
        integer :: indco
        integer :: ipgf
        real(kind=8) :: jac
        integer :: jheavn
        integer :: ncompn
        integer :: jheafa
        integer :: lact(8)
        integer :: ncomph
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
        real(kind=8) :: rela
        real(kind=8) :: reac
        integer :: singu
        real(kind=8) :: fk(27,3,3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: vtmp(400)
    end subroutine xvcont
end interface

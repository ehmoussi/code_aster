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
    subroutine xmprep(cface, contac, elref, elrefc, elc,&
                      ffc, ffp, fpg, iaint, ibasec,&
                      iptint, ifa, igeom, ipgf, jac,&
                      jlst, lact, nd, ndim, ninter,&
                      nlact, nno, nnos, nptf, nvit,&
                      rr, singu, tau1, tau2, ka, mu,&
                      jbaslo, jstno, jlsn, fk)
        integer :: cface(30, 6)
        integer :: contac
        character(len=8) :: elref
        character(len=8) :: elrefc
        character(len=8) :: elc
        real(kind=8) :: ffc(8)
        real(kind=8) :: ffp(27)
        character(len=8) :: fpg
        integer :: iaint
        integer :: ibasec
        integer :: iptint
        integer :: ifa
        integer :: igeom
        integer :: ipgf
        real(kind=8) :: jac
        integer :: jlst
        integer :: lact(8)
        real(kind=8) :: nd(3)
        integer :: ndim
        integer :: ninter
        integer :: nlact
        integer :: nno
        integer :: nnos
        integer :: nptf
        integer :: nvit
        real(kind=8) :: rr
        real(kind=8), optional :: ka
        real(kind=8), optional :: mu
        real(kind=8), optional :: fk(27,3,3)
        integer :: singu
        integer, optional :: jbaslo
        integer, optional :: jlsn
        integer, optional :: jstno
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
    end subroutine xmprep
end interface

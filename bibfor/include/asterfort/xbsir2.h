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
    subroutine xbsir2(elref, contac, ddlc, ddlm, ddls,&
                      igeom, jheavn, jlst, ivectu, singu,&
                      nddl, ndim, nfh, nfiss,&
                      nno, nnom, nnos, depref, sigref,&
                      jbaslo, jstno, jlsn)
        character(len=8) :: elref
        integer :: contac
        integer :: ddlc
        integer :: ddlm
        integer :: ddls
        integer :: igeom
        integer :: jheavn
        integer :: jlst
        integer :: ivectu
        integer :: singu
        integer :: nddl
        integer :: ndim
        integer :: nfh
        integer :: nfiss
        integer :: nno
        integer :: nnom
        integer :: nnos
        real(kind=8) :: depref
        real(kind=8) :: sigref
        integer :: jbaslo
        integer :: jstno
        integer :: jlsn
    end subroutine xbsir2
end interface

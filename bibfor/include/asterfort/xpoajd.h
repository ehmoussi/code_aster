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
    subroutine xpoajd(elrefp, ino, nnop, lsn, lst,&
                      ninter, iainc, ncompa, typma, co, igeom,&
                      jdirno, nfiss, jheavn, ncompn, he, ndime,&
                      ndim, cmp, nbcmp, nfh, nfe,&
                      ddlc, ima, jconx1, jconx2, jcnsv1,&
                      jcnsv2, jcnsl2, nbnoc, inntot, inn,&
                      nnn, contac, lmeca, pre1, heavno,&
                      nlachm, lacthm, jbaslo, &
                      jlsn, jlst, jstno, ka, mu)
        integer :: nbcmp
        integer :: nfiss
        integer :: nnop
        character(len=8) :: elrefp
        integer :: ino
        real(kind=8) :: lsn(nfiss)
        real(kind=8) :: lst(nfiss)
        integer :: ninter(4)
        integer :: iainc
        character(len=8) :: typma
        real(kind=8) :: co(3)
        integer :: igeom
        integer :: jdirno
        integer :: jfisno
        integer :: jheavn
        integer :: ncompn
        integer :: he(nfiss)
        integer :: ndime
        integer :: ndim
        integer :: cmp(*)
        integer :: nfh
        integer :: nfe
        integer :: ddlc
        integer :: ima
        integer :: jconx1
        integer :: jconx2
        integer :: jcnsv1
        integer :: jcnsv2
        integer :: jcnsl2
        integer :: nbnoc
        integer :: inntot
        integer :: inn
        integer :: nnn
        integer :: contac
        aster_logical :: lmeca
        aster_logical :: pre1
        integer :: ncompa
        integer :: heavno(20, 3)
        integer :: nlachm(2)
        integer :: lacthm(16)
        integer :: jbaslo
        integer :: jlsn
        integer :: jlst
        integer :: jstno
        real(kind=8) :: ka
        real(kind=8) :: mu
    end subroutine xpoajd
end interface 

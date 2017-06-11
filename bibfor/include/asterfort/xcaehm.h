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
! aslint: disable=W1504
!
interface 
    subroutine xcaehm(nomte, axi, perman, typmod, inte_type,&
                      mecani, press1, press2, tempe, dimdef,&
                      dimcon, nmec, np1, np2, ndim,&
                      nno, nnos, nnom, npi, npg,&
                      nddls, nddlm, dimuel, ipoids, ivf,&
                      idfde, ddld, ddlm, ddlp, enrmec, nenr,&
                      dimenr, nnop, nnops, nnopm, enrhyd, ddlc, nfh)
        character(len=16) :: nomte
        aster_logical :: axi
        aster_logical :: perman
        character(len=8) :: typmod(2)
        character(len=3), intent(out) :: inte_type
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        integer :: dimdef
        integer :: dimcon
        integer :: nmec
        integer :: np1
        integer :: np2
        integer :: ndim
        integer :: nno
        integer :: nnos
        integer :: nnom
        integer :: npi
        integer :: npg
        integer :: nddls
        integer :: nddlm
        integer :: dimuel
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: ddld
        integer :: ddlm
        integer :: ddlp
        integer :: enrmec(3)
        integer :: nenr
        integer :: dimenr
        integer :: nnop
        integer :: nnops
        integer :: nnopm
        integer :: enrhyd(3)
        integer :: ddlc
        integer :: nfh
    end subroutine xcaehm
end interface 

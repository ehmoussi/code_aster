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
    subroutine xassha_frac(nddls, nddlm, nnop, nnops,&
                           lact, elrefp, elrefc, elc, contac,&
                           dimuel, nface, npgf, nbspg, nptf,&
                           jcohes, jptint, igeom, jbasec,&
                           nlact, cface, fpg, ncompv,&
                           compor, jmate, ndim, idepm, idepd, jcoheo, incoca,&
                           pla, rela, algocr, jheavn, ncompn,&
                           ifiss, nfiss, nfh, jheafa, ncomph,&
                           pos)
                           
        integer :: nddls
        integer :: nddlm
        integer :: nnop
        integer :: nnops
        integer :: lact(16)
        character(len=8) :: elrefp
        character(len=8) :: elrefc
        character(len=8) :: elc
        integer :: contac
        integer :: dimuel
        integer :: nface
        integer :: npgf
        integer :: nbspg
        integer :: nptf
        integer :: jcohes
        integer :: jptint
        integer :: igeom
        integer :: jbasec
        integer :: nlact(2)
        integer :: cface(30,6)
        character(len=8) :: fpg
        integer :: ncompv
        character(len=16) :: compor(*)
        integer :: jmate
        integer :: ndim
        integer :: idepm
        integer :: idepd
        integer :: jcoheo
        integer :: incoca
        integer :: pla(27)
        real(kind=8) :: rela
        integer :: algocr
        integer :: jheavn
        integer :: ncompn
        integer :: ifiss
        integer :: nfiss
        integer :: nfh
        integer :: jheafa
        integer :: ncomph
        integer :: pos(16)
    end subroutine xassha_frac
end interface

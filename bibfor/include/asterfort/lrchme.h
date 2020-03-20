! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
interface
    subroutine lrchme(fieldNameAst, fieldNameMed ,&
                      meshMed     , meshAst      ,&
                      fieldSupport, fieldQuantity, entityType,&
                      cmpNb       , cmpAstName   , cmpMedName,&
                      prolz, iinst, numpt, numord, inst,&
                      storeCrit, storeEpsi, fileUnit, option, param,&
                      nbpgma, nbpgmm, nbspmm, codret)
        character(len=19) :: fieldNameAst
        character(len=*) :: cmpAstName, cmpMedName
        character(len=8) :: meshAst
        character(len=8) :: fieldQuantity
        character(len=4) :: fieldSupport
        character(len=3) :: prolz
        character(len=8) :: storeCrit, param
        character(len=24) :: option
        character(len=64) :: fieldNameMed, meshMed
        integer :: fileUnit, entityType
        integer :: codret
        integer :: cmpNb
        integer :: iinst, numpt, numord
        integer :: nbpgma(*), nbpgmm(*), nbspmm(*)
        real(kind=8) :: inst
        real(kind=8) :: storeEpsi
    end subroutine lrchme
end interface

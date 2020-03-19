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
    subroutine lrfmed(fileUnit    , resultName   , meshAst     ,&
                      fieldType   , fieldQuantity, fieldSupport, fieldNameMed_,&
                      option      , param        , prolz,&
                      storeAccess , storeCreaNb  ,&
                      storeIndxNb , storeTimeNb  ,&
                      storeIndx   , storeTime    ,&
                      storeCrit   , storeEpsi    , storePara   ,&
                      cmpNb       , cmpAstName   , cmpMedName  ,&
                      fieldStoreNb)
        integer, intent(in) :: fileUnit
        character(len=8), intent(in) :: resultName
        character(len=8), intent(in) :: meshAst
        character(len=16), intent(in) :: fieldType
        character(len=8), intent(in) :: fieldQuantity
        character(len=4), intent(in) :: fieldSupport
        character(len=64), intent(in) :: fieldNameMed_
        character(len=24), intent(in) :: option
        character(len=8), intent(in) :: param
        character(len=3), intent(in) :: prolz
        character(len=10), intent(in) :: storeAccess
        integer, intent(in) :: storeCreaNb, storeIndxNb, storeTimeNb
        character(len=19), intent(in) :: storeIndx, storeTime
        character(len=8), intent(in) :: storeCrit
        real(kind=8), intent(in) :: storeEpsi
        character(len=4) , intent(in):: storePara
        integer, intent(in) :: cmpNb
        character(len=24), intent(in) :: cmpAstName, cmpMedName
        integer, intent(out) :: fieldStoreNb
    end subroutine lrfmed
end interface

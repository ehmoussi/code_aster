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
    subroutine resuPrintIdeasNode(fileUnit   , dsName       ,&
                                  title      , storeIndx    ,&
                                  fieldType_ , fieldName_   ,&
                                  cmpUserNb_ , cmpUserName_ ,&
                                  nodeUserNb_, nodeUserNume_)
        integer, intent(in) :: fileUnit
        character(len=*), intent(in) :: title, dsName
        integer, intent(in) :: storeIndx
        character(len=*), optional, intent(in) :: fieldName_, fieldType_
        integer, optional, intent(in) :: cmpUserNb_
        character(len=8), optional, pointer :: cmpUserName_(:)
        integer, optional, intent(in) :: nodeUserNb_
        integer, optional, pointer :: nodeUserNume_(:)
    end subroutine resuPrintIdeasNode
end interface

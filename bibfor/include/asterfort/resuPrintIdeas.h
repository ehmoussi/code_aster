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
    subroutine resuPrintIdeas(fileUnit   , dsName       , lResu          ,&
                              storeNb    , storeListIndx,&
                              fieldListNb, fieldListType,&
                              title_     , titleKeywf_  ,&
                              titleKeywfIocc_, realFormat_,&
                              cmpUserNb_ , cmpUserName_ ,&
                              nodeUserNb_, nodeUserNume_,&
                              cellUserNb_, cellUserNume_)
        integer, intent(in) :: fileUnit
        character(len=*), intent(in) :: dsName
        aster_logical, intent(in) :: lResu
        integer, intent(in) :: storeNb, storeListIndx(:)
        integer, intent(in) :: fieldListNb
        character(len=*), intent(in) :: fieldListType(*)
        character(len=*), optional, intent(in) :: title_, titleKeywf_
        integer, optional, intent(in) :: titleKeywfIocc_
        character(len=*), optional, intent(in) :: realFormat_
        integer, optional, intent(in) :: cmpUserNb_
        character(len=8), optional, pointer :: cmpUserName_(:)
        integer, optional, intent(in) :: cellUserNb_
        integer, optional, pointer :: cellUserNume_(:)
        integer, optional, intent(in) :: nodeUserNb_
        integer, optional, pointer :: nodeUserNume_(:)
    end subroutine resuPrintIdeas
end interface

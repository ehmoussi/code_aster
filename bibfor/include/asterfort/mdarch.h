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
interface
    subroutine mdarch(typcal, isto1, ipas, disc, nbmode,&
                      iorsto, discst, dt, depger, vitger,&
                      accger, depstr, vitstr, accstr, passto,&
                      nbsym, nomsym, depgec, vitgec, accgec,&
                      depstc, vitstc, accstc)
        character(len=4) , intent(in)  :: typcal
        integer          , intent(in)  :: isto1
        integer          , intent(in)  :: ipas
        real(kind=8)     , intent(in)  :: disc
        integer          , intent(in)  :: nbmode
        integer                        :: iorsto(*)
        real(kind=8)                   :: discst(*)
        real(kind=8)     , optional, intent(in)  :: dt
        real(kind=8)     , optional, intent(in)  :: depger(nbmode)
        real(kind=8)     , optional, intent(in)  :: vitger(nbmode)
        real(kind=8)     , optional, intent(in)  :: accger(nbmode)
        real(kind=8)     , optional              :: depstr(*)
        real(kind=8)     , optional              :: vitstr(*)
        real(kind=8)     , optional              :: accstr(*)
        real(kind=8)     , optional              :: passto(*)
        integer          , optional, intent(in)  :: nbsym
        character(len=4) , optional, intent(in)  :: nomsym(*)
        complex(kind=8)  , optional, intent(in)  :: depgec(nbmode)
        complex(kind=8)  , optional, intent(in)  :: vitgec(nbmode)
        complex(kind=8)  , optional, intent(in)  :: accgec(nbmode)
        complex(kind=8)  , optional              :: depstc(*)
        complex(kind=8)  , optional              :: vitstc(*)
        complex(kind=8)  , optional              :: accstc(*)   
    end subroutine mdarch
end interface

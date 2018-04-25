! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"

interface 
subroutine bgpg3d(ppas,bg,pg,mg,phig,treps,&
                                          trepspg,epspt6,epspc6,phivg,&
                                          pglim,brgi,dpg_depsa6,dpg_depspg6,&
                                          taar,nrjg,tref0,aar0,sr1,&
                                          srsrag,teta1,dt,vrag00,aar1,&
                                          tdef,nrjd,def0,srsdef,vdef00,&
                                          def1,cna,nrjp,ttrd,tfid,ttdd,&
                                          tdid,exmd,exnd,cnab,cnak,ssad,&
                                          at,st,m1,e1,m2,e2,atf,stf,&
                                          m1f,e1f,m2f,e2f,phig0)
        aster_logical :: ppas
        real(kind=8) :: bg
        real(kind=8) :: pg
        real(kind=8) :: mg
        real(kind=8) :: phig
        real(kind=8) :: treps
        real(kind=8) :: trepspg
        real(kind=8) :: epspt6(6)
        real(kind=8) :: epspc6(6)
        real(kind=8) :: phivg
        real(kind=8) :: pglim
        real(kind=8) :: brgi
        real(kind=8) :: dpg_depsa6(6)
        real(kind=8) :: dpg_depspg6(6)
        real(kind=8) :: taar
        real(kind=8) :: nrjg
        real(kind=8) :: tref0
        real(kind=8) :: aar0
        real(kind=8) :: sr1
        real(kind=8) :: srsrag
        real(kind=8) :: teta1
        real(kind=8) :: dt
        real(kind=8) :: vrag00
        real(kind=8) :: aar1
        real(kind=8) :: tdef
        real(kind=8) :: nrjd
        real(kind=8) :: def0
        real(kind=8) :: srsdef
        real(kind=8) :: vdef00
        real(kind=8) :: def1
        real(kind=8) :: cna
        real(kind=8) :: nrjp
        real(kind=8) :: ttrd
        real(kind=8) :: tfid
        real(kind=8) :: ttdd
        real(kind=8) :: tdid
        real(kind=8) :: exmd
        real(kind=8) :: exnd
        real(kind=8) :: cnab
        real(kind=8) :: cnak
        real(kind=8) :: ssad
        real(kind=8) :: at
        real(kind=8) :: st
        real(kind=8) :: m1
        real(kind=8) :: e1
        real(kind=8) :: m2
        real(kind=8) :: e2
        real(kind=8) :: atf
        real(kind=8) :: stf
        real(kind=8) :: m1f
        real(kind=8) :: e1f
        real(kind=8) :: m2f
        real(kind=8) :: e2f
        real(kind=8) :: phig0
    end subroutine bgpg3d
end interface 

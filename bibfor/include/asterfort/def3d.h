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
      subroutine def3d(ppas,tdef,nrjd,tref0,def0,sr1,srsdef,teta1,dt,&
      vdef00,def1,vdef1,CNa,nrjp,ttrd,tfid,ttdd,tdid,exmd,exnd,&
      cnab,cnak,ssad,At,St,M1,E1,M2,E2,AtF,StF,M1F,E1F,M2F,E2F)
        aster_logical :: ppas
        real(kind=8) :: tdef
        real(kind=8) :: nrjd
        real(kind=8) :: tref0
        real(kind=8) :: def0
        real(kind=8) :: sr1
        real(kind=8) :: srsdef
        real(kind=8) :: teta1
        real(kind=8) :: dt
        real(kind=8) :: vdef00
        real(kind=8) :: def1
        real(kind=8) :: vdef1
        real(kind=8) :: CNa
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
        real(kind=8) :: At
        real(kind=8) :: St
        real(kind=8) :: M1
        real(kind=8) :: E1
        real(kind=8) :: M2
        real(kind=8) :: E2
        real(kind=8) :: AtF
        real(kind=8) :: StF
        real(kind=8) :: M1F
        real(kind=8) :: E1F
        real(kind=8) :: M2F
        real(kind=8) :: E2F
    end subroutine def3d
end interface 

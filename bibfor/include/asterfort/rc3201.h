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
    subroutine rc3201(ze200, ig, lpmpb, lsn, lther, lfat, lefat,&
                      yapass, seisme, iocs, mater,&
                      lieu, utot, utotenv, resuas,&
                      resuss, resuca, resucs,&
                      factus, factus2, resumax)
        aster_logical :: ze200
        integer :: ig
        aster_logical :: lpmpb
        aster_logical :: lsn
        aster_logical :: lther
        aster_logical :: lfat
        aster_logical :: lefat
        aster_logical :: yapass
        aster_logical :: seisme
        integer :: iocs
        character(len=8) :: mater
        character(len=4) :: lieu
        real(kind=8) :: utot
        real(kind=8) :: utotenv
        real(kind=8) :: resuas(*)
        real(kind=8) :: resuss(*)
        real(kind=8) :: resuca(*)
        real(kind=8) :: resucs(*)
        real(kind=8) :: factus(*)
        character(len=24) :: factus2(*)
        real(kind=8) :: resumax(*)
    end subroutine rc3201
end interface

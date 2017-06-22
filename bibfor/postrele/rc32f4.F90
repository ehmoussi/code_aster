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

subroutine rc32f4(typass, nbp12, nbp23, nbp13, nbsigr,&
                  nbsg1, nbsg2, nbsg3, saltij)
    implicit   none
    integer :: nbp12, nbp23, nbp13, nbsigr, nbsg1, nbsg2, nbsg3
    real(kind=8) :: saltij(*)
    character(len=3) :: typass
!
!     SI IL N'EXISTE PLUS DE SITUATION DE PASSAGE ENTRE 2 GROUPES,
!     ON MET LES TERMES CROISES DE SALT A ZERO
!
!     ------------------------------------------------------------------
    integer :: i1, i2, isl
!     ------------------------------------------------------------------
!
    if (typass .eq. '1_2') then
        if (nbp12 .eq. 0) then
!           BLOC 1_2
            do 100 i1 = 1, nbsg1
                isl = (i1-1)*nbsigr + nbsg1
                do 102 i2 = 1, nbsg2
                    saltij(isl+i2) = 0.d0
102              continue
100          continue
!           BLOC 2_1
            do 104 i1 = 1, nbsg2
                isl = nbsigr*nbsg1 + (i1-1)*nbsigr
                do 106 i2 = 1, nbsg1
                    saltij(isl+i2) = 0.d0
106              continue
104          continue
        endif
!
    else if (typass .eq. '2_3') then
        if (nbp23 .eq. 0) then
!           BLOC 2_3
            do 110 i1 = 1, nbsg2
                isl = nbsigr*nbsg1 + (i1-1)*nbsigr + (nbsg1+nbsg2)
                do 112 i2 = 1, nbsg3
                    saltij(isl+i2) = 0.d0
112              continue
110          continue
!           BLOC 3_2
            do 114 i1 = 1, nbsg3
                isl = nbsigr*(nbsg1+nbsg2) + (i1-1)*nbsigr + nbsg1
                do 116 i2 = 1, nbsg2
                    saltij(isl+i2) = 0.d0
116              continue
114          continue
        endif
!
    else if (typass .eq. '1_3') then
        if (nbp13 .eq. 0) then
!           BLOC 1_3
            do 120 i1 = 1, nbsg1
                isl = (i1-1)*nbsigr + (nbsg1+nbsg2)
                do 122 i2 = 1, nbsg3
                    saltij(isl+i2) = 0.d0
122              continue
120          continue
!           BLOC 3_1
            do 124 i1 = 1, nbsg3
                isl = nbsigr*(nbsg1+nbsg2) + nbsigr*(i1-1)
                do 126 i2 = 1, nbsg1
                    saltij(isl+i2) = 0.d0
126              continue
124          continue
        endif
    endif
!
end subroutine

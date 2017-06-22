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

subroutine rc36f5(nbp12, nbp23, nbp13, nbsigr, nbsg1,&
                  nbsg2, nbsg3, saltij)
    implicit   none
    integer :: nbp12, nbp23, nbp13, nbsigr, nbsg1, nbsg2, nbsg3
    real(kind=8) :: saltij(*)
!
!     SI IL N'EXISTE PAS DE SITUATION DE PASSAGE ENTRE 2 GROUPES,
!     ON MET LES TERMES CROISES DE SALT A ZERO
!
!     ------------------------------------------------------------------
    integer :: i1, i2, isl
!     ------------------------------------------------------------------
!
    if (nbp12 .eq. 0) then
!           BLOC 1_2
        do 100 i1 = 1, nbsg1
            isl = 4*(i1-1)*nbsigr + 4*nbsg1
            do 102 i2 = 1, nbsg2
                saltij(isl+4*(i2-1)+1) = 0.d0
                saltij(isl+4*(i2-1)+2) = 0.d0
                saltij(isl+4*(i2-1)+3) = 0.d0
                saltij(isl+4*(i2-1)+4) = 0.d0
102          continue
100      continue
!           BLOC 2_1
        do 104 i1 = 1, nbsg2
            isl = 4*nbsigr*nbsg1 + 4*(i1-1)*nbsigr
            do 106 i2 = 1, nbsg1
                saltij(isl+4*(i2-1)+1) = 0.d0
                saltij(isl+4*(i2-1)+2) = 0.d0
                saltij(isl+4*(i2-1)+3) = 0.d0
                saltij(isl+4*(i2-1)+4) = 0.d0
106          continue
104      continue
    endif
!
    if (nbp23 .eq. 0) then
!           BLOC 2_3
        do 110 i1 = 1, nbsg2
            isl = 4*nbsigr*nbsg1 + 4*(i1-1)*nbsigr + 4*(nbsg1+nbsg2)
            do 112 i2 = 1, nbsg3
                saltij(isl+4*(i2-1)+1) = 0.d0
                saltij(isl+4*(i2-1)+2) = 0.d0
                saltij(isl+4*(i2-1)+3) = 0.d0
                saltij(isl+4*(i2-1)+4) = 0.d0
112          continue
110      continue
!           BLOC 3_2
        do 114 i1 = 1, nbsg3
            isl = 4*nbsigr*(nbsg1+nbsg2) + 4*(i1-1)*nbsigr + 4*nbsg1
            do 116 i2 = 1, nbsg2
                saltij(isl+4*(i2-1)+1) = 0.d0
                saltij(isl+4*(i2-1)+2) = 0.d0
                saltij(isl+4*(i2-1)+3) = 0.d0
                saltij(isl+4*(i2-1)+4) = 0.d0
116          continue
114      continue
    endif
!
    if (nbp13 .eq. 0) then
!           BLOC 1_3
        do 120 i1 = 1, nbsg1
            isl = 4*(i1-1)*nbsigr + 4*(nbsg1+nbsg2)
            do 122 i2 = 1, nbsg3
                saltij(isl+4*(i2-1)+1) = 0.d0
                saltij(isl+4*(i2-1)+2) = 0.d0
                saltij(isl+4*(i2-1)+3) = 0.d0
                saltij(isl+4*(i2-1)+4) = 0.d0
122          continue
120      continue
!           BLOC 3_1
        do 124 i1 = 1, nbsg3
            isl = 4*nbsigr*(nbsg1+nbsg2) + 4*nbsigr*(i1-1)
            do 126 i2 = 1, nbsg1
                saltij(isl+4*(i2-1)+1) = 0.d0
                saltij(isl+4*(i2-1)+2) = 0.d0
                saltij(isl+4*(i2-1)+3) = 0.d0
                saltij(isl+4*(i2-1)+4) = 0.d0
126          continue
124      continue
    endif
!
end subroutine

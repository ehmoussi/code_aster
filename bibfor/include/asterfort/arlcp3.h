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
interface
    subroutine arlcp3(nbma1 ,nbma2 ,numno1,numno2,m3dea , &
                  m1dea ,numn1t,numn2t,len1  ,len2  , lisrel, charge)
       integer :: nbnomx
       parameter    (nbnomx=27)
       integer          :: nbma1,nbma2
       integer          :: len1,len2
       real(kind=8)     :: m3dea(12,3*nbnomx,nbma1),m1dea(12,12,nbma2)
       character(len=5), dimension(nbnomx+2,nbma1) :: numno1
       character(len=5), dimension(2,nbma2)  :: numno2
       character(len=5), dimension(nbnomx*nbma1) :: numn1t
       character(len=5), dimension(2*nbma2)  :: numn2t
       character(len=8) :: charge
       character(len=19) :: lisrel
    end subroutine arlcp3
end interface

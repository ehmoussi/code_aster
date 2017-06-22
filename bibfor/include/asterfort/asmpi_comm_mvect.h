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
            subroutine asmpi_comm_mvect(optmpi,typsca,nbval,jtrav,bcrank&
     &,vi,vi4,vr,vc,sci,sci4,scr,scc)
              character(len=*), intent(in) :: optmpi
              character(len=*), intent(in) :: typsca
              integer ,optional, intent(in) :: nbval
              integer ,optional, intent(in) :: jtrav
              integer ,optional, intent(in) :: bcrank
              integer ,optional, intent(inout) :: vi(*)
              integer(kind=4) ,optional, intent(inout) :: vi4(*)
              real(kind=8) ,optional, intent(inout) :: vr(*)
              complex(kind=8) ,optional, intent(inout) :: vc(*)
              integer ,optional, intent(inout) :: sci
              integer(kind=4) ,optional, intent(inout) :: sci4
              real(kind=8) ,optional, intent(inout) :: scr
              complex(kind=8) ,optional, intent(inout) :: scc
            end subroutine asmpi_comm_mvect
          end interface 

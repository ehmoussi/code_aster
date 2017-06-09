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
            subroutine rsadpa(nomsd,cel,npara,lpara,iordr,itype,tjv,ttyp&
     &,sjv,styp,istop)
              integer, intent(in) :: npara
              character(len=*), intent(in) :: nomsd
              character(len=1), intent(in) :: cel
              character(len=*), intent(in) :: lpara(*)
              integer, intent(in) :: iordr
              integer, intent(in) :: itype
              integer ,optional, intent(out) :: tjv(*)
              character(len=*) ,optional, intent(out) :: ttyp(*)
              integer ,optional, intent(out) :: sjv
              character(len=*) ,optional, intent(out) :: styp
              integer ,optional, intent(in) :: istop
            end subroutine rsadpa
          end interface 

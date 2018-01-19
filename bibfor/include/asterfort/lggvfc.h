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

interface
    subroutine lggvfc(refe,ndim, nno, nnob, npg, nddl, axi, &
                  geom,ddl, vff, vffb, idff, idffb,&
                  iw, sief,fint)
        aster_logical :: refe,axi
        integer       :: ndim, nno, nnob, npg, nddl, idff, idffb, iw
        real(kind=8)  :: geom(ndim,nno),ddl(nddl),vff(nno, npg), vffb(nnob, npg)
        real(kind=8)  :: sief(3*ndim+2,npg)
        real(kind=8)  :: fint(nddl)
    end subroutine lggvfc
end interface

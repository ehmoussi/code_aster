!--------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
  subroutine pcptcc(option, ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, mpicou,&
                    nbordr, nbpas, vldist, vcham, lisori, nbordi, lisord,&
                    modele, sd_partition, lsdpar,&
                    i, ipas, ideb, ifin, irelat,&
                    chamno, lonnew, lonch, ktyp, vcnoch, noch, nochc)
    integer           :: option
    aster_logical     :: ldist
    aster_logical     :: dbg_ob
    aster_logical     :: dbgv_ob
    aster_logical     :: lcpu
    aster_logical     :: ltest
    integer           :: rang
    integer           :: nbproc
    mpi_int           :: mpicou
    integer           :: nbordr
    integer           :: nbpas
    character(len=24)  :: vldist
    character(len=24)  :: vcham
    character(len=24)  :: lisori
    integer           :: nbordi
    character(len=19)  :: lisord
    character(len=24)  :: modele
    character(len=8)   :: sd_partition
    aster_logical      :: lsdpar
    integer            :: i
    integer            :: ipas
    integer            :: ideb
    integer            :: ifin
    integer            :: irelat
    character(len=24)  :: chamno
    integer            :: lonnew
    integer            :: lonch
    character(len=1)   :: ktyp
    character(len=24)   :: vcnoch
    real(kind=8), pointer :: noch(:)
    complex(kind=8), pointer :: nochc(:)
  end subroutine pcptcc
end interface

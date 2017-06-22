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

subroutine asmpi_warn(iexc)
! person_in_charge: mathieu.courtois at edf.fr
!
!
    use parameters_module
    implicit none
#include "asterf_debug.h"
#include "asterf_types.h"
#include "asterc/asmpi_comm.h"
#include "asterc/asmpi_split_comm.h"
#include "asterc/asabrt.h"
#include "asterfort/asmpi_check.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/asmpi_status.h"
#include "asterfort/gtstat.h"
#include "asterfort/ststat.h"
#include "asterfort/utmess.h"
    integer, intent(in) :: iexc
!-----------------------------------------------------------------------
!   Function : MPI COMM WARN
!       A processor raised an error, it emits the message
!       and send the information to proc #0.
!       iexc = 0 (stop with abort)
!       iexc = 1 (raise an exception)
!-----------------------------------------------------------------------
#ifdef _USE_MPI
!
! Si on désactive le controle des erreurs entre processeurs, on fait abort
!
# ifdef ASTER_DISABLE_MPI_CHECK
    call asabrt(6)
# else
!
#include "mpif.h"
!
    mpi_int :: iermpi, rank, nbpro4, mpicou, mpicow
    integer :: iret, ibid
!
! --- COMMUNICATEUR MPI COM_WORLD (MPICOW) ET COM COURANT (MPICOU)
! --- SI ILS SONT DIFFERENTS, ON NETTOIE ET ON MET LE COM WORLD POUR
! --- QUE LE PLANTON CONCERNE TOUS LES PROCESSUS MPI.
    call asmpi_comm('GET_WORLD', mpicow)
    call asmpi_comm('GET', mpicou)
    if (mpicou .ne. mpicow) then
        call asmpi_comm('FREE', mpicou)
        call asmpi_comm('SET', mpicow)
        mpicou=mpicow
    endif
!
    call asmpi_info(mpicou, rank=rank)
    call asmpi_info(mpicou, size=nbpro4)
!
!     SI PAS 'ST_OK', IL NE FAUT PAS COMMUNIQUER ENCORE UNE FOIS
    if (nbpro4 .le. 1 .or. .not. gtstat(ST_OK)) then
        goto 999
    endif
    DEBUG_MPI('mpi_warn', rank, nbpro4)
!
!     SUR LES PROCESSEURS AUTRES QUE #0
    if (rank .ne. 0) then
        call ststat(ST_ER_OTH)
        if (iexc .eq. 0) then
            call utmess('I', 'APPELMPI_82')
        else
            call utmess('I', 'APPELMPI_92')
            call ststat(ST_EXCEPT)
        endif
        call asmpi_status(ST_ER, iret)
!
!     SUR LE PROCESSEUR #0
    else
        call ststat(ST_ER_PR0)
        if (iexc .eq. 1) then
            call ststat(ST_EXCEPT)
        endif
        call asmpi_check(iret)
    endif
!     INUTILE DE TESTER IRET, ON SAIT QU'IL Y A UNE ERREUR
!
999  continue
# endif
#else
    integer :: idummy
    idummy = iexc
#endif
end subroutine

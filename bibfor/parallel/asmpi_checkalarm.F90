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

subroutine asmpi_checkalarm()
! person_in_charge: mathieu.courtois at edf.fr
!
!
    use parameters_module
    implicit none
!-----------------------------------------------------------------------
!     FONCTION REALISEE : MPI CHECK ALARM
!       EN FIN D'EXECUTION, LE PROCESSEUR #0 DONNE A L'UTILISATEUR
!       LA LISTE DES ALARMES QUI ONT ETE EMISES PAR PROCESSEUR.
!-----------------------------------------------------------------------
#include "asterf_types.h"
#include "asterf.h"
#include "asterc/asmpi_comm.h"
#include "asterc/gtalrm.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/gtstat.h"
#include "asterfort/utmess.h"
#ifdef _USE_MPI
!
#include "mpif.h"
#include "asterc/asmpi_recv_i4.h"
#include "asterc/asmpi_send_i4.h"
!
    mpi_int :: i, rank, nbpro4, ival(1), mpicou, mpicow, nbv
    mpi_int, parameter :: pr0=0
    integer :: ia, np1, vali(2)
    aster_logical :: vu
!
! --- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET_WORLD', mpicow)
    call asmpi_comm('GET', mpicou)
    ASSERT(mpicow == mpicou)
    call asmpi_info(mpicou, rank=rank, size=nbpro4)
    np1 = nbpro4 - 1
    nbv = 1
!
    if (.not. gtstat(ST_OK)) then
        if (rank .eq. 0) then
            call utmess('I', 'CATAMESS_88')
        endif
        goto 9999
    endif
!
!     SUR LES PROCESSEURS AUTRES QUE #0
!
    if (rank .ne. 0) then
!       RECUPERER LA LISTE DES ALARMES
        ia = 0
        call gtalrm(ia)
!       CHAQUE PROCESSEUR ENVOIE LA LISTE DES ALARMES EMISES AU PROC #0
        ival(1) = ia
        call asmpi_send_i4(ival, nbv, pr0, ST_TAG_ALR, mpicou)
!
!     SUR LE PROCESSEUR #0
!
    else
!       DEMANDE LA LISTE DES ALARMES A CHAQUE PROCESSEUR
        vu = .false.
        do i = 1, np1
            call asmpi_recv_i4(ival, nbv, i, ST_TAG_ALR, mpicou)
            if (ival(1) .ne. 0) then
                vu = .true.
                vali(1) = i
                vali(2) = ival(1)
                if (ival(1) .eq. 1) then
                    call utmess('A+', 'APPELMPI_1', ni=2, vali=vali)
                else
                    call utmess('A+', 'APPELMPI_2', ni=2, vali=vali)
                endif
            endif
        end do
        if (vu) then
            call utmess('A', 'VIDE_1')
        endif
!
    endif
9999 continue
#endif
end subroutine

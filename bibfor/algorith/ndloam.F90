! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine ndloam(sddyna, result, evonol, nume)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/getvid.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynkk.h"
#include "asterfort/r8inir.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
#include "blas/dcopy.h"
!
character(len=19) :: sddyna
character(len=8) :: result
integer :: nume
aster_logical :: evonol
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE)
!
! LECTURE DES DEPL/VITE/ACCEL GENERALISES DANS SD_RESULT
!
! ----------------------------------------------------------------------
!
!
! IN  RESULT : NOM UTILISATEUR DU CONCEPT RESULTAT
! IN  SDDYNA : SD DYNAMIQUE
!
!
!
!
    character(len=8) :: ctype
    integer :: iret
    integer :: nbmodp
    character(len=24) :: trgene
    integer :: jtrgen
    aster_logical :: linit
    character(len=19) :: depgem, vitgem, accgem
    integer :: jdepgm, jvitgm, jaccgm
    character(len=19) :: depgep, vitgep, accgep
    integer :: jdepgp, jvitgp, jaccgp
    character(len=19) :: dgen, vgen, agen
    character(len=19) :: depgen, vitgen, accgen
    integer :: jrestd, jrestv, jresta
    integer :: ifm, niv
    integer :: nocc1, nocc2, nocc3, nocc
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... LECTURE PROJ. MODALE'
    endif
!
! --- INITIALISATIONS
!
    linit = .false.
    ctype = 'K24'
!
! --- OBJETS PROJECTION MODALE
!
    nbmodp = ndynin(sddyna,'NBRE_MODE_PROJ')
    call ndynkk(sddyna, 'PRMO_DEPGEM', depgem)
    call ndynkk(sddyna, 'PRMO_VITGEM', vitgem)
    call ndynkk(sddyna, 'PRMO_ACCGEM', accgem)
    call ndynkk(sddyna, 'PRMO_DEPGEP', depgep)
    call ndynkk(sddyna, 'PRMO_VITGEP', vitgep)
    call ndynkk(sddyna, 'PRMO_ACCGEP', accgep)
    call jeveuo(accgem, 'E', jaccgm)
    call jeveuo(accgep, 'E', jaccgp)
    call jeveuo(vitgem, 'E', jvitgm)
    call jeveuo(vitgep, 'E', jvitgp)
    call jeveuo(depgem, 'E', jdepgm)
    call jeveuo(depgep, 'E', jdepgp)
!
! --- SI PAS RE-ENTRANT: ON PART DE ZERO
!
    if (.not.evonol) then
        linit = .true.
        call getvid('PROJ_MODAL', 'DEPL_INIT_GENE', iocc=1, scal=depgen, nbret=nocc1)
        call getvid('PROJ_MODAL', 'VITE_INIT_GENE', iocc=1, scal=vitgen, nbret=nocc2)
        call getvid('PROJ_MODAL', 'ACCE_INIT_GENE', iocc=1, scal=accgen, nbret=nocc3)
        nocc = nocc1+nocc2+nocc3
        if (nocc .ne. 0) linit = .false.
    else
!
! --- EXISTENCE DU PARAMETRE DANS SD_RESULTAT
!
        call rsadpa(result, 'L', 1, 'TRAN_GENE_NOLI', nume,&
                    1, sjv=jtrgen, styp=ctype)
        trgene = zk24(jtrgen)
        call jeexin(trgene(1:18)//'D', iret)
        if (iret .eq. 0) then
            call utmess('A', 'MECANONLINE5_31')
            linit = .true.
        else
            dgen = trgene(1:18)//'D'
            vgen = trgene(1:18)//'V'
            agen = trgene(1:18)//'A'
        endif
    endif
!
! --- INITIALISATION OU LECTURE
!
    if (linit) then
        call r8inir(nbmodp, 0.d0, zr(jaccgm), 1)
        call r8inir(nbmodp, 0.d0, zr(jaccgp), 1)
        call r8inir(nbmodp, 0.d0, zr(jvitgm), 1)
        call r8inir(nbmodp, 0.d0, zr(jvitgp), 1)
        call r8inir(nbmodp, 0.d0, zr(jdepgm), 1)
        call r8inir(nbmodp, 0.d0, zr(jdepgp), 1)
    else
        if (evonol) then
            call jeveuo(dgen, 'L', jrestd)
            call jeveuo(vgen, 'L', jrestv)
            call jeveuo(agen, 'L', jresta)
            call dcopy(nbmodp, zr(jrestd), 1, zr(jdepgm), 1)
            call dcopy(nbmodp, zr(jrestd), 1, zr(jdepgp), 1)
            call dcopy(nbmodp, zr(jrestv), 1, zr(jvitgm), 1)
            call dcopy(nbmodp, zr(jrestv), 1, zr(jvitgp), 1)
            call dcopy(nbmodp, zr(jresta), 1, zr(jaccgm), 1)
            call dcopy(nbmodp, zr(jresta), 1, zr(jaccgp), 1)
        else
            call r8inir(nbmodp, 0.d0, zr(jaccgm), 1)
            call r8inir(nbmodp, 0.d0, zr(jaccgp), 1)
            call r8inir(nbmodp, 0.d0, zr(jvitgm), 1)
            call r8inir(nbmodp, 0.d0, zr(jvitgp), 1)
            call r8inir(nbmodp, 0.d0, zr(jdepgm), 1)
            call r8inir(nbmodp, 0.d0, zr(jdepgp), 1)
            if (nocc1 .ne. 0) then
                call jeveuo(depgen//'.VALE', 'L', jrestd)
                call dcopy(nbmodp, zr(jrestd), 1, zr(jdepgm), 1)
                call dcopy(nbmodp, zr(jrestd), 1, zr(jdepgp), 1)
            endif
            if (nocc2 .ne. 0) then
                call jeveuo(vitgen//'.VALE', 'L', jrestv)
                call dcopy(nbmodp, zr(jrestv), 1, zr(jvitgm), 1)
                call dcopy(nbmodp, zr(jrestv), 1, zr(jvitgp), 1)
            endif
            if (nocc3 .ne. 0) then
                call jeveuo(accgen//'.VALE', 'L', jresta)
                call dcopy(nbmodp, zr(jresta), 1, zr(jaccgm), 1)
                call dcopy(nbmodp, zr(jresta), 1, zr(jaccgp), 1)
            endif
        endif
    endif
!
    call jedema()
!
end subroutine

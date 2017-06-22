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

subroutine cbondp(load, mesh, ndim, vale_type)
!
    implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/char_crea_cart.h"
#include "asterfort/char_read_val.h"
#include "asterfort/getelem.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/utmess.h"
#include "asterfort/vetyma.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: load
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: ndim
    character(len=4), intent(in) :: vale_type
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Treatment of load ONDE_PLANE
!
! --------------------------------------------------------------------------------------------------
!
!
! In  mesh      : name of mesh
! In  load      : name of load
! In  ndim      : space dimension
! In  vale_type : affected value type (real, complex or function)
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8) :: c16dummy
    real(kind=8) :: r8dummy
    character(len=8) :: k8dummy
    character(len=16) :: k16dummy
    real(kind=8) :: wave_dire(3), wave_type_r, dist
    character(len=8) :: signal, signde
    character(len=16) :: wave_type
    integer :: jvalv
    integer :: iocc, ndir, val_nb, nondp, codret
    character(len=16) :: keywordfact
    character(len=19) :: carte(2)
    integer :: nb_carte, nb_cmp
    character(len=24) :: list_elem
    integer :: j_elem
    integer :: nb_elem
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    keywordfact = 'ONDE_PLANE'
    call getfac(keywordfact, nondp)
    if (nondp .eq. 0) goto 99
!
! - Initializations
!
    ASSERT(vale_type.eq.'FONC')
!
! - Creation and initialization to zero of <CARTE>
!
    call char_crea_cart('MECANIQUE', keywordfact, load, mesh, vale_type,&
                        nb_carte, carte)
    ASSERT(nb_carte.eq.2)
!
! - Loop on factor keyword
!
    do iocc = 1, nondp
!
! ----- Read mesh affectation
!
        list_elem = '&&CBONDP.LIST_ELEM'
        call getelem(mesh, keywordfact, iocc, 'A', list_elem, &
                     nb_elem)
        if (nb_elem .ne. 0) then
            call jeveuo(list_elem, 'L', j_elem)
!
! --------- Get wave function
!
            call char_read_val(keywordfact, iocc, 'FONC_SIGNAL', 'FONC', val_nb,&
                               r8dummy, signal, c16dummy, k16dummy)
            ASSERT(val_nb.eq.1)
            call char_read_val(keywordfact, iocc, 'DEPL_IMPO', 'FONC', val_nb,&
                               r8dummy, signde, c16dummy, k16dummy)
            if (val_nb .ne. 1) then
               signde = '&FOZERO'
            endif
!
! --------- Affectation of values in <CARTE> - Wave function
!
            call jeveuo(carte(1)//'.VALV', 'E', jvalv)
            nb_cmp = 2
            zk8(jvalv-1+1) = signal
            zk8(jvalv-1+2) = signde
            call nocart(carte(1), 3, nb_cmp, mode='NUM', nma=nb_elem,&
                        limanu=zi(j_elem))
!
! --------- Get direction
!
            wave_dire(1) = 0.d0
            wave_dire(2) = 0.d0
            wave_dire(3) = 0.d0
            call getvr8(keywordfact, 'DIRECTION', iocc=iocc, nbval=0, nbret=ndir)
            ndir = - ndir
            ASSERT(ndir.eq.3)
            call getvr8(keywordfact, 'DIRECTION', iocc=iocc, nbval=ndir, vect=wave_dire)
!
! --------- Get wave type
!
            call char_read_val(keywordfact, iocc, 'TYPE_ONDE', 'TEXT', val_nb,&
                               r8dummy, k8dummy, c16dummy, wave_type)
            ASSERT(val_nb.eq.1)
            if (ndim .eq. 3) then
                if (wave_type .eq. 'P ') then
                    wave_type_r = 0.d0
                else if (wave_type.eq.'SV') then
                    wave_type_r = 1.d0
                else if (wave_type.eq.'SH') then
                    wave_type_r = 2.d0
                else if (wave_type.eq.'S ') then
                    call utmess('F', 'CHARGES2_61')
                else
                    ASSERT(.false.)
                endif
            else if (ndim .eq. 2) then
                if (wave_type .eq. 'P ') then
                    wave_type_r = 0.d0
                else if (wave_type.eq.'S ') then
                    wave_type_r = 1.d0
                else if (wave_type.eq.'SV'.or.wave_type.eq.'SH') then
                    call utmess('A', 'CHARGES2_62')
                    wave_type_r = 1.d0
                else
                    ASSERT(.false.)
                endif
            else
                ASSERT(.false.)
            endif
!
! --------- Get distance
!
!            dist = 0.d0
!            call getvr8(keywordfact, 'DIST', iocc=iocc, scal=dist)
!
! --------- Affectation of values in <CARTE> - Wave type and direction
!
            call jeveuo(carte(2)//'.VALV', 'E', jvalv)
            nb_cmp = 6
            zr(jvalv-1+1) = wave_dire(1)
            zr(jvalv-1+2) = wave_dire(2)
            zr(jvalv-1+3) = wave_dire(3)
            zr(jvalv-1+4) = wave_type_r
            zr(jvalv-1+5) = r8vide()
            zr(jvalv-1+6) = r8vide()
            call getvr8(keywordfact, 'DIST', iocc=iocc,&
                        nbval=0, nbret=ndir)
            if (ndir .ne. 0) then
               call getvr8(keywordfact, 'DIST', iocc=iocc, scal=dist)
               zr(jvalv-1+5) = dist
            endif
            call getvr8(keywordfact, 'DIST_REFLECHI', iocc=iocc,&
                        nbval=0, nbret=ndir)
            if (ndir .ne. 0) then
               call getvr8(keywordfact, 'DIST_REFLECHI', iocc=iocc,&
                           scal=dist)
               zr(jvalv-1+6) = dist
            endif
            call nocart(carte(2), 3, nb_cmp, mode='NUM', nma=nb_elem,&
                        limanu=zi(j_elem))
        endif
!
! ----- Check elements
!
        call vetyma(mesh, ndim, keywordfact, list_elem, nb_elem,&
                    codret)
!
        call jedetr(list_elem)
!
    end do
!
99  continue
    call jedema()
end subroutine
